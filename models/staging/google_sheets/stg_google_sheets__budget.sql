{{ config(
    materialized = 'incremental',
    schema  = 'google_sheets',
    on_schema_change = 'append_new_columns',
    unique_key = '_row'
) }}
WITH src_budget AS (
    SELECT *
    FROM {{ source('google_sheets', 'budget') }}
),

renamed_casted AS (
    SELECT
        _row,
        product_id,
        month,
        CONVERT_TIMEZONE('UTC', _fivetran_synced) AS date_load_utc,
        COALESCE(quantity, 0) AS quantity
    FROM src_budget
)


SELECT * FROM renamed_casted

{% if is_incremental() %}

    WHERE date_load_utc > (SELECT MAX(date_load_utc) FROM {{ this }})

{% endif %}
