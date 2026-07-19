SELECT
    c.customer_id,
    c.customer_name,
    count(o.order_id) as order_count,
    sum(o.total_price) as total_spent
FROM
    {{ ref('stg_customers') }} c
    JOIN {{ ref('stg_orders') }} o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name