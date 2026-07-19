select
    c.customer_id,
    c.customer_name,
    count(f.order_id) as total_orders,
    coalesce(sum(f.total_price), 0) as total_spent,
    avg(f.total_price) as avg_order_value,
    min(f.order_date) as first_order,
    max(f.order_date) as last_order
from {{ ref('stg_customers') }} c
left join {{ ref('stg_orders') }} f on f.customer_id = c.customer_id
group by c.customer_id, c.customer_name