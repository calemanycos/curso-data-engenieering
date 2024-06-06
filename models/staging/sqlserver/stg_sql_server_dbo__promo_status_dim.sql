{{
  config(
    materialized='table'
  )
}}
{{ config(
    schema='sql_server'
) }}
SELECT
    0 AS Status_ID,
    'Active' AS Status_Name
UNION ALL
SELECT
    1 AS Status_ID,
    'Inactive' AS Status_Name
