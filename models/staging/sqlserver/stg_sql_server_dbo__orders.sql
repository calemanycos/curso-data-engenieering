{{
  config(
    materialized='view'
  )
}}
{{ config(
    schema='sql_server'
) }}
WITH src_orders AS (
    SELECT 
    MD5(shipping_service) as shipping_service_id,
    address_id,
    CONVERT_TIMEZONE('UTC', created_at) as created_at_utc,
    order_cost,
    order_id,
    order_total,
    promo_id,
    user_id,
    _fivetran_deleted,
    FROM {{ ref('base_sql_server_dbo__orders') }}
)

SELECT * FROM src_orders 
