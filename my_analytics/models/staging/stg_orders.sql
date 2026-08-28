{{ config(materialized='view') }}

select order_id, customer_id, order_date, lower(trim(status)) as status

from {{ ref('orders') }}