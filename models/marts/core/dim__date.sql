{{ config(materialized='table') }}{{ config(
    schema='marts'
) }}
WITH FECHIYA AS (
    {{ dbt_date.get_date_dimension("2010-01-01", "2030-12-31") }}
)

SELECT
    DATE_DAY AS DATE_ID,
    DAY_OF_WEEK,
    DAY_OF_MONTH,
    DAY_OF_YEAR,
    MONTH_OF_YEAR,
    QUARTER_OF_YEAR
FROM FECHIYA
