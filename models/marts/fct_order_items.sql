WITH src_order_items AS (
    SELECT *
    FROM {{ ref('stg_sql_server_dbo__order_items') }}
),
src_products AS (
    SELECT *
    FROM {{ source('sql_server_dbo', 'products') }}
),
renamed_casted AS (
    SELECT
        src_order_items.order_id,
        src_order_items.product_id,
        src_products.price AS product_unitary_price,
        src_order_items._fivetran_deleted,
        orders.shipping_service_id,
        orders.address_id,
        orders.created_at_utc,
        orders.order_cost,
        orders.order_total,
        orders.promo_id,
        orders.user_id,
        CONVERT_TIMEZONE('UTC', src_order_items._fivetran_synced) AS date_load_utc,
        COALESCE(quantity, 0) AS quantity
    FROM src_order_items
    LEFT JOIN src_products ON src_order_items.product_id = src_products.product_id
    LEFT JOIN (
        SELECT
            shipping_service_id,
            address_id,
            created_at_utc,
            order_cost,
            order_id,
            order_total,
            promo_id,
            user_id
        FROM {{ ref('stg_sql_server_dbo__orders') }}
    ) AS orders ON src_order_items.order_id = orders.order_id
    WHERE COALESCE(src_order_items._fivetran_deleted, FALSE) = FALSE
)

SELECT * FROM renamed_casted
