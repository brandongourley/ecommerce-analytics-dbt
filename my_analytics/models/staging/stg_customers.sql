{{ config(materialized='view') }}

select customer_id, name, signup_date, lower(trim(city)) as city
from {{ ref('customers') }}
