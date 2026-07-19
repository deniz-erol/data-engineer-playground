select
    row_number() over (order by i.total_spent desc) as spending_rank,
    i.customer_id,
    i.customer_name,
    c.market_segment,
    i.total_orders,
    i.total_spent,
    i.avg_order_value,
    i.first_order,
    i.last_order
from {{ ref('int_customer_orders') }} i
join {{ ref('dim_customers') }} c on i.customer_id = c.customer_id