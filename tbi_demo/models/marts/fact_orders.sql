SELECT
    order_id,
    customer_id,
    order_date,
    total_price,
    order_status
FROM {{ ref('stg_orders') }}