select
    n.nation_name,
    count(f.order_id) as total_orders,
    sum(f.total_price) as total_revenue,
    avg(f.total_price) as avg_order_value
from {{ ref('fact_orders') }} f
join {{ ref('dim_customers') }} c on f.customer_id = c.customer_id
join {{ ref('dim_nation') }} n on c.nation_id = n.nation_id
group by n.nation_name