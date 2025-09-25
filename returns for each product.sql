-- returns for each producT
select
p.product_id as productID , 
p.product_name as productName, 
count(o.order_id) total_orders , 
count(r.order_item_refund_id) as total_refunds
, (count(r.order_item_refund_id) / count(o.order_id)) as refund_Rate
from products as p 
join orders as o 
on p.product_id = o.primary_product_id 
left join order_item_refunds as r
on o.order_id = r.order_id 
group by p.product_id , p.product_name
order by refund_Rate DESC; 