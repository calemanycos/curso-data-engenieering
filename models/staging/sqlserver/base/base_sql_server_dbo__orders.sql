{{
  config(
    materialized='view'
  )
}}
{{ config(
    schema='sql_server'
) }}

WITH src_orders AS (
    SELECT *
    FROM {{ source('sql_server_dbo', 'orders') }}
),

order_counts AS (
    SELECT
        user_id,
        COUNT(*) AS total_orders
    FROM src_orders
    WHERE COALESCE(_fivetran_deleted, FALSE) = FALSE
    GROUP BY user_id
),

renamed_casted AS (
    SELECT
        order_id,
        address_id,
        created_at,
        estimated_delivery_at,
        src_orders.user_id,
        delivered_at,
        status,
        _fivetran_deleted,
        _fivetran_synced AS date_load,
        oc.total_orders,
        CASE WHEN TRIM(shipping_service) = '' THEN 'No shipphing service' ELSE shipping_service END as shipping_service,
        COALESCE(shipping_cost, 0) AS shipping_cost_EUR,
        CASE WHEN TRIM(promo_id) = '' THEN 'No promo' ELSE promo_id END
            AS promo_name,
        MD5(promo_id) AS promo_id,
        COALESCE(order_cost, 0) AS order_cost,
        COALESCE(order_total, 0) AS order_total,
        NULLIF(tracking_id, '') AS tracking_id,
        MD5(shipping_service) as shipping_service_id
    FROM src_orders
    LEFT JOIN order_counts AS oc ON src_orders.user_id = oc.user_id
    WHERE COALESCE(_fivetran_deleted, FALSE) = FALSE
),

user_order_totals AS (
    SELECT
        user_id,
        SUM(order_total)::real AS total_money_in_orders
    FROM renamed_casted
    GROUP BY user_id
)

SELECT
    rc.order_id,
    rc.shipping_service,
    rc.shipping_service_id,
    rc.shipping_cost_EUR,
    rc.address_id,
    rc.created_at,
    rc.promo_name,
    rc.estimated_delivery_at,
    rc.order_cost,
    rc.user_id,
    rc.order_total,
    rc.delivered_at,
    rc.tracking_id,
    rc.status,
    rc._fivetran_deleted,
    rc.date_load,
    rc.total_orders,
    rc.promo_id,
    uot.total_money_in_orders
FROM renamed_casted AS rc
LEFT JOIN user_order_totals AS uot ON rc.user_id = uot.user_id
