select
    date_trunc('month', order_date) as order_month,
    sum(total_price) as total_revenue,
    count(order_id) as order_count,
    avg(total_price) as average_order_price
from {{ ref('fact_orders') }}
group by date_trunc('month', order_date)