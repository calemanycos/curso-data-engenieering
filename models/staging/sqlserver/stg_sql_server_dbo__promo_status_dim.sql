{{
  config(
    materialized='table'
  )
}}
{{ config(
    schema='sql_server'
) }}
SELECT
    0 AS STATUS_ID,
    'Active' AS STATUS_NAME
UNION ALL
SELECT
    1 AS STATUS_ID,
    'Inactive' AS STATUS_NAME
