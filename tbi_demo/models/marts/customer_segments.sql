with customer_stats as (
    select
        customer_id,
        customer_name,
        total_spent,
        total_orders,
        last_order
    from {{ ref('int_customer_orders') }}
),
spending_quartiles as (
    select
        *,
        ntile(4) over (order by total_spent desc) as spending_quartile
    from customer_stats
),
final as (
    select
        *,
        case
            when spending_quartile = 1 then 'High Value'
            when spending_quartile = 2 then 'Regular'
            when spending_quartile = 3 then 'Occasional'
            when spending_quartile = 4 then 'Low Value'
        end as customer_segment
    from spending_quartiles
)

select * from final


