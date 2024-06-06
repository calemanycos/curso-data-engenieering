{{
  config(
    materialized='view'
  )
}}
{{ config(
    schema='sql_server'
) }}

WITH src_products AS (
    SELECT *
    FROM {{ source('sql_server_dbo', 'products') }}
),

renamed_casted AS (
    SELECT
        product_id,
        price,
        name,
        inventory,
        _fivetran_deleted,
       CONVERT_TIMEZONE('UTC', _fivetran_synced) AS date_load_UTC
    FROM src_products
    WHERE COALESCE(_fivetran_deleted, FALSE) = FALSE
)

SELECT * FROM renamed_casted
