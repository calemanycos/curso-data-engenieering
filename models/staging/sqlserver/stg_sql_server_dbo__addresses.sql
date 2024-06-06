{{
  config(
    materialized='view',
    schema='sql_server'
  )
}}

WITH src_addresses AS (
    SELECT *
    FROM {{ source('sql_server_dbo', 'addresses') }}
),

renamed_casted AS (
    SELECT
        address_id,
        zipcode,
        country,
        address,
        state,
        _fivetran_deleted,
        CONVERT_TIMEZONE('UTC', _fivetran_synced) AS date_load_utc
    FROM src_addresses
    WHERE COALESCE(_fivetran_deleted, FALSE) = FALSE
)

SELECT * FROM renamed_casted
