# Data Engineering Demo — Modern Data Stack with dbt & Snowflake

A small but production-styled analytics engineering project built on **dbt Core** and **Snowflake**, following a layered (staging → intermediate → marts) architecture with a star-schema data mart, source definitions, data tests, and layer-based materialization.

Built as a hands-on demo to model a modern ELT pipeline end to end.

---

## Stack

| Layer | Tool |
|---|---|
| Data warehouse | Snowflake |
| Transformation / modeling | dbt Core (SQL) |
| Source data | Snowflake `SNOWFLAKE_SAMPLE_DATA` (TPCH_SF1 — ~1.5M orders) |
| Version control | Git / GitHub |

---

## Architecture

Classic ELT flow: raw data is **loaded** into the warehouse, then **transformed** in place with dbt.

```
SNOWFLAKE_SAMPLE_DATA (raw TPCH)
        │  (dbt sources)
        ▼
   staging   →   stg_customers, stg_orders        (light cleaning, renamed columns) [views]
        │
        ▼
 intermediate →  int_customer_orders              (joins + aggregation)             [view]
        │
        ▼
    marts     →  dim_customers, fact_orders        (star schema)                     [tables]
        │
        ▼
   BI / analytics (Power BI, Snowsight, ...)
```

**Why layered:** each layer has a single responsibility — staging standardizes raw data, intermediate applies business logic, marts serves analysis-ready tables. This mirrors software layering (separation of concerns) and keeps transformations testable and maintainable.

---

## Data model (star schema)

The marts layer is modeled dimensionally:

- **`fact_orders`** — one row per order; numeric measures (`total_price`) plus a foreign key (`customer_id`) to the customer dimension. ~1.5M rows.
- **`dim_customers`** — descriptive customer attributes (name, market segment, nation, account balance). ~150K rows.

Analytical questions are answered by joining the fact to its dimensions, filtering on dimension attributes, and aggregating the fact.

---

## Layers & models

```
models/
├── staging/
│   ├── _tpch_sources.yml      # raw source definitions (TPCH tables)
│   ├── stg_customers.sql      # cleaned customers (view)
│   └── stg_orders.sql         # cleaned orders (view)
├── intermediate/
│   └── int_customer_orders.sql   # customer-level order summary (view)
└── marts/
    ├── _marts.yml             # tests + documentation
    ├── dim_customers.sql      # customer dimension (table)
    └── fact_orders.sql        # order fact (table)
```

**Materialization strategy** (set in `dbt_project.yml`):
- `staging` / `intermediate` → **views** (lightweight, always fresh)
- `marts` → **tables** (frequently queried by consumers, materialized for performance)

**Sources:** raw TPCH tables are declared in `_tpch_sources.yml` and referenced with `{{ source(...) }}` rather than hard-coded paths — enabling lineage and centralized source management.

---

## Data quality tests

Defined in `_marts.yml`, run with `dbt test`:

| Test | Model.column | Purpose |
|---|---|---|
| `unique`, `not_null` | `dim_customers.customer_id` | primary key integrity |
| `unique`, `not_null` | `fact_orders.order_id` | primary key integrity |
| `not_null` | `fact_orders.customer_id` | no orphan orders |
| `relationships` | `fact_orders.customer_id → dim_customers.customer_id` | referential integrity between fact and dimension |

All 6 tests pass — the `relationships` test in particular guarantees every order references a customer that actually exists in the dimension.

---

## Running the project

```bash
# 1. create & activate a virtual environment
python -m venv venv
.\venv\Scripts\Activate.ps1        # Windows PowerShell

# 2. install dbt with the Snowflake adapter
pip install dbt-snowflake

# 3. verify the connection
dbt debug

# 4. build all models
dbt run

# 5. run data quality tests
dbt test
```

Connection settings live in `~/.dbt/profiles.yml` (Snowflake account, warehouse, database, role). Credentials are not committed.

---

## Notes

- Built with dbt Core 1.12 and the Snowflake adapter.
- Source data is Snowflake's built-in TPCH sample dataset, so the project runs on any Snowflake trial account with no data loading required.
- Structured to reflect real-world analytics engineering practices: source-driven staging, layered modeling, dimensional marts, and tested, version-controlled transformations.