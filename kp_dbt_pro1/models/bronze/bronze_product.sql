{{
  config(
    materialized = 'view',
    )
}}
SELECT
*
from
{{ source('source', 'dim_product') }}