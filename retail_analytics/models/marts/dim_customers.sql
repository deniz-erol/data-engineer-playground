SELECT
    customer_id,
    customer_name,
    market_segment,
    nation_id,
    account_balance
FROM {{ ref('stg_customers') }}