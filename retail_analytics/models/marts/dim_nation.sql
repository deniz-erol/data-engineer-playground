select
    nation_id,
    nation_name
from {{ ref('stg_nation') }}