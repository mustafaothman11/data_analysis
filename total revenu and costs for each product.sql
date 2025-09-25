-- total revenu and costs for each product
select 
 pds.product_name ,sum(price_usd) as total_revenu , sum(cogs_usd) as total_cogs
from orders as ods 
left join 
products as pds
on ods.primary_product_id = pds.product_id
group by pds.product_name;

