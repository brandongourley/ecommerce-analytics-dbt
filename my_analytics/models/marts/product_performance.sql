{{ config(materialized='table') }}

with product_performance as (

select product_name, category, sum(quantity * price) as total_revenue, sum(quantity) as units_sold

from {{ ref('stg_order_items') }} oi

inner join {{ ref('stg_products') }} p

on oi.product_id = p.product_id

group by product_name, category

)

select * from product_performance


