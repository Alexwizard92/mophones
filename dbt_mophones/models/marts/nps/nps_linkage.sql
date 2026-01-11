with credit as (
  select * from {{ ref('credit_customer_snapshot') }}
),
-- Link each NPS response to the closest reporting_date snapshot for that customer
linked as (
  select
    n.customer_id,
    n.response_date,
    n.nps_score,
    n.nps_group,
    c.reporting_date,
    c.account_status,
    c.dpd,
    c.arrears_amount,
    c.balance,
    c.age_band,
    c.income_band,
    c.region,
    c.plan_type
  from {{ ref('stg_nps') }} n
  left join credit c
    on n.customer_id = c.customer_id
   and abs(datediff(day, n.response_date, c.reporting_date)) = (
       select min(abs(datediff(day, n2.response_date, c2.reporting_date)))
       from {{ ref('stg_nps') }} n2
       join credit c2 on n2.customer_id = c2.customer_id
       where n2.customer_id = n.customer_id
         and n2.response_date = n.response_date
   )
)
select * from linked