# E-Commerce Analytics: dbt Project

A dbt project built to practice the modern analytics-engineering workflow end to end: raw source data modeled through a staging layer into analytics-ready marts, with automated data-quality tests and generated documentation. Built on DuckDB.

## What it does

Takes four raw e-commerce sources (customers, orders, order items, products) and transforms them into clean, tested business tables that answer real questions (customer spend and product performance) using the standard **raw → staging → marts** pattern.

## Architecture

```
seeds (raw)              staging (cleaned)           marts (business logic)
─────────────            ─────────────────           ──────────────────────
customers        →       stg_customers        ┐
orders           →       stg_orders           ├─→   customer_orders      (spend & order count per customer)
order_items      →       stg_order_items      ┤
products         →       stg_products         ┘─→   product_performance  (revenue & units sold per product)
```

- **Staging models** (`models/staging/`): one per source. Light, consistent cleanup: standardizing text (trimming whitespace, normalizing case on `city` and `status`), selecting explicit columns, materialized as views.
- **Marts** (`models/marts/`): business logic built on the clean staging layer. Multi-step transformations written as stacked CTEs, joining line items → orders → customers and line items → products, materialized as tables.

## Data quality

Automated tests (`schema.yml`) validate keys across the pipeline, `unique` and `not_null` on the primary keys of staging models and marts, so a broken join or duplicated row is caught on every run rather than silently reaching a dashboard.

## Stack

- **dbt** (transformation, testing, docs, lineage)
- **DuckDB** (local warehouse)
- **SQL** (CTEs, joins, aggregation)

## Running it

```bash
dbt seed        # load the raw CSVs
dbt run         # build staging + marts
dbt test        # run data-quality tests
dbt docs generate && dbt docs serve   # docs + lineage graph
```

## Notes

Built as a hands-on project to learn the modern data stack. The dataset is generated sample data, deliberately given realistic messiness (inconsistent casing, mixed statuses) so the staging layer does real cleanup work. The structure, tests, and modeling patterns mirror how production dbt projects are organized.
=======
