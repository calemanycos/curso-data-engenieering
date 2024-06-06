{{
  config(
    materialized='view',
    schema='sql_server'
  )
}}

WITH src_promos AS (
    SELECT *
    FROM {{ source('sql_server_dbo', 'promos') }}
),

renamed_casted AS (
    SELECT
        _fivetran_deleted,
        discount AS discount_euros,
        CONVERT_TIMEZONE('UTC', _fivetran_synced) AS date_load_utc,
        CASE WHEN TRIM(promo_id) = '' THEN 'No promo' ELSE promo_id END
            AS promo_name,
        MD5(promo_id) AS promo_id


    FROM src_promos
    WHERE COALESCE(_fivetran_deleted, FALSE) = FALSE
)

SELECT * FROM renamed_casted
