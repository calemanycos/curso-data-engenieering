{{
  config(
    materialized='view',
    schema='sql_server',
    unique_key = 'user_id'
  )
}}

WITH src_orders AS (
    SELECT
        user_id,
        shipping_cost_eur,
        tracking_id,
        status,
        CASE
            WHEN TRIM(shipping_service) = '' THEN 'No shipphing service' ELSE
                shipping_service
        END AS shipping_service,
        MD5(shipping_service),
        CONVERT_TIMEZONE('UTC', estimated_delivery_at)
            AS estimated_delivery_at_utc,
        CONVERT_TIMEZONE('UTC', delivered_at) AS delivered_at_utc
    FROM {{ ref('base_sql_server_dbo__orders') }}
)

SELECT * FROM src_orders
