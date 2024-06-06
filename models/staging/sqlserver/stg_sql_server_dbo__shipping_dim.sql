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
    user_id,
    CASE WHEN TRIM(shipping_service) = '' THEN 'No shipphing service' ELSE shipping_service END as shipping_service,
    MD5(shipping_service),
    shipping_cost_eur,
    CONVERT_TIMEZONE('UTC', estimated_delivery_at) AS estimated_delivery_at_UTC,
    CONVERT_TIMEZONE('UTC', delivered_at) AS delivered_at_UTC,
    tracking_id,
    status,
    FROM {{ ref('base_sql_server_dbo__orders') }}
)

SELECT * FROM src_orders 