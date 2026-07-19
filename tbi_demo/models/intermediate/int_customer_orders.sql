select
    c.customer_id,
    c.customer_name,
    count(f.order_id) as total_orders,
    sum(f.total_price) as total_spent,
    avg(f.total_price) as avg_order_value,
    min(f.order_date) as first_order,
    max(f.order_date) as last_order
from {{ ref('stg_orders') }} f
join {{ ref('stg_customers') }} c on f.customer_id = c.customer_id
group by c.customer_id, c.customer_name