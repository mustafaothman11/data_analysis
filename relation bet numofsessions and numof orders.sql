-- the relationship between the number of session and the number of orders in the month
SELECT 
    year(web.created_at) AS year,
    COUNT(DISTINCT web.website_session_id) AS number_of_session,
    COUNT(DISTINCT o.order_id) AS nums_of_orders,
    ROUND(
        (COUNT(DISTINCT o.order_id) * 1.0 / COUNT(DISTINCT web.website_session_id)) * 100, 
        2
    ) AS conversion_rate_percent
FROM website_pageviews AS web
LEFT JOIN orders AS o
    ON web.website_session_id = o.website_session_id
GROUP BY year(web.created_at)
order by conversion_rate_percent DESC;

