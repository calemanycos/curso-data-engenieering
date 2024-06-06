{{
  config(
    materialized='view'
  )
}}

{{ config(
    schema='sql_server'
) }}
WITH src_events AS (
    SELECT *
    FROM {{ source('sql_server_dbo', 'events') }}
),

renamed_casted AS (
    SELECT
        event_id,
        page_url,
        event_type,
        user_id,
        session_id,
        CONVERT_TIMEZONE('UTC', created_at) AS created_at_utc,
        _fivetran_deleted,
        CONVERT_TIMEZONE('UTC', _fivetran_synced) AS date_load_UTC,
        NULLIF(product_id, '') AS product_id,
        NULLIF(order_id, '') AS order_id
    FROM src_events
    WHERE COALESCE(_fivetran_deleted, FALSE) = FALSE
)

SELECT * FROM renamed_casted
