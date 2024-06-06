{%- macro convert_to_utc(timestamp_column) -%}
    {{ dbt_date.convert_timezone('Etc/UTC', timestamp_column) }}
{%- endmacro -%}