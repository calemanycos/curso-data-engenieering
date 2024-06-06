{{
  config(
    materialized ='view',
    schema ='sql_server',)
}}

WITH src_order_items AS (
    SELECT *
    FROM {{ source('sql_server_dbo', 'order_items') }}
),

renamed_casted AS (
    SELECT
        order_id,
        product_id,
        _fivetran_deleted,
        _fivetran_synced,
        COALESCE(quantity, 0) AS quantity
    FROM src_order_items
    WHERE COALESCE(_fivetran_deleted, FALSE) = FALSE
)

SELECT * FROM renamed_casted
