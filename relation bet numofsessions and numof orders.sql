-- the relationship between the number of session and the number of orders in a day
SELECT 
    DATE(ods.created_at) AS date,
    COUNT(web.website_session_id) AS number_of_session,
    COUNT(ods.order_id) AS nums_of_orders
FROM orders AS ods
LEFT JOIN website_pageviews AS web
    ON ods.website_session_id = web.website_session_id
GROUP BY DATE(ods.created_at);

