SELECT
*
from
{{ source('source', 'dim_store') }}