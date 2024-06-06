WITH src_order_items AS (
    SELECT *
    FROM {{ ref('stg_sql_server_dbo__order_items') }}
),


renamed_casted AS (
    SELECT
        oi.order_id,
        oi.product_id,
        oi._fivetran_deleted,
        o.shipping_service_id,
        o.address_id,
        o.created_at_utc,
        o.order_cost,
        o.order_total,
        o.promo_id,
        o.user_id,
        CONVERT_TIMEZONE('UTC', oi._fivetran_synced) AS date_load_utc,
        COALESCE(oi.quantity, 0) AS quantity
    FROM {{ ref('stg_sql_server_dbo__order_items') }} AS oi
    LEFT JOIN
        {{ ref('stg_sql_server_dbo__orders') }} AS o
        ON oi.order_id = o.order_id
    WHERE COALESCE(oi._fivetran_deleted, FALSE) = FALSE
)

SELECT * FROM renamed_casted
