SELECT
    C_CUSTKEY AS customer_id,
    C_NAME AS customer_name,
    C_ADDRESS AS address,
    C_NATIONKEY AS nation_id,
    C_ACCTBAL AS account_balance,
    C_MKTSEGMENT AS market_segment
FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER