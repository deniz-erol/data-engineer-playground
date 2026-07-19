select
    row_number() over (order by sum(f.total_price) desc) as spending_rank,
    c.customer_id,
    c.customer_name,
    c.market_segment,
    count(f.order_id) as total_orders,
    sum(f.total_price) as total_spent,
    avg(f.total_price) as avg_order_value,
    min(f.order_date) as first_order,
    max(f.order_date) as last_order
from {{ ref('fact_orders') }} f
join {{ ref('dim_customers') }} c on f.customer_id = c.customer_id
group by c.customer_id, c.customer_name, c.market_segment