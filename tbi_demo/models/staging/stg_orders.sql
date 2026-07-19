SELECT O_ORDERKEY as order_id,
O_CUSTKEY as customer_id,
O_TOTALPRICE as total_price,
O_ORDERDATE as order_date,
O_ORDERSTATUS as order_status
FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.ORDERS