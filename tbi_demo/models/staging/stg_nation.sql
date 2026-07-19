SELECT
    N_NATIONKEY as nation_id,
    N_NAME as nation_name
FROM {{ source('tpch', 'nation') }}