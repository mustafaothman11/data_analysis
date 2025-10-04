-- growth margin

select 
year (created_at) as year ,
month(created_at) as month,
sum(price_usd) as total_Revenue ,
sum(cogs_usd) as total_costs,
(sum(price_usd) - sum(cogs_usd)) as profit_margin,
round ( (sum(price_usd) - sum(cogs_usd) / sum(cogs_usd)) *100 , 2) as growth_margin_percent 
from order_items
group by year (created_at) , month (created_at)
order by  year (created_at) , month (created_at);