{{ config(materialized='table') }}

with order_item_revenue as (
    select
        oi.order_id,
        oi.quantity * p.price as line_revenue
    from {{ ref('stg_order_items') }} oi
    inner join {{ ref('stg_products') }} p
        on oi.product_id = p.product_id
),

order_revenue as (
    select order_id, sum(line_revenue) as order_total
    from order_item_revenue
    group by order_id
),

customer_totals as (
    select o.customer_id, sum(r.order_total) as total_spent, count(*) as order_count
    from order_revenue r
    inner join {{ ref('stg_orders') }} o
    on r.order_id = o.order_id
    group by o.customer_id
)

select * from customer_totals

