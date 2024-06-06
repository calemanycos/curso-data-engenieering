{{
  config(
    materialized='view',
    schema='sql_server'
  )
}}

WITH src_orders AS (
    SELECT
        address_id,
        order_cost,
        order_id,
        order_total,
        promo_id,
        user_id,
        _fivetran_deleted,
        MD5(shipping_service) AS shipping_service_id,
        CONVERT_TIMEZONE('UTC', created_at) AS created_at_utc
    FROM {{ ref('base_sql_server_dbo__orders') }}
)

SELECT * FROM src_orders
