{{ config(materialized='incremental', unique_key='order_id', incremental_strategy='merge') }}

select
    order_id,
    customer_id,
    order_date,
    total_price,
    order_status
from {{ ref('stg_orders') }}

{% if is_incremental() %}
where order_date >= (select max(order_date) from {{ this }})
{% endif %}