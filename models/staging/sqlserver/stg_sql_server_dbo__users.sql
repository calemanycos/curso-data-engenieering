 {{       config(
    materialized = 'view',
    schema = 'sql_server',  
    unique_key = 'user_id'
) }}


WITH src_users AS (
    SELECT *
    FROM {{ source('sql_server_dbo', 'users') }}
),

src_orders AS (
    SELECT
        user_id,
        COUNT(*) AS total_orders
    FROM {{ source('sql_server_dbo', 'orders') }}
    WHERE COALESCE(_fivetran_deleted, FALSE) = FALSE
    GROUP BY user_id
),

renamed_casted AS (
    SELECT
        address_id,
        created_at,
        email,
        first_name,
        last_name,
        phone_number,
        CONVERT_TIMEZONE('UTC',updated_at) AS updated_at_utc,
        su.user_id,
        su._fivetran_deleted,
        CONVERT_TIMEZONE('UTC', su._fivetran_synced) AS date_load_UTC,
        coalesce (regexp_like(email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$')= true,false) as is_valid_email_address,
        COALESCE(su.total_orders, 0)
        + COALESCE(so.total_orders, 0) AS total_orders
    FROM src_users AS su
    LEFT JOIN src_orders AS so ON su.user_id = so.user_id
    WHERE COALESCE(_fivetran_deleted, FALSE) = FALSE
)

SELECT * FROM renamed_casted
