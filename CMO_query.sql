use depiecommerce;
-- CMO 
-- SESSION ORDER BY CHANNEL
SELECT utm_source, COUNT(*) AS sessions
FROM website_sessions
GROUP BY utm_source
ORDER BY sessions DESC;
-- BY DEVICE
SELECT device_type, COUNT(*) AS sessions
FROM website_sessions
GROUP BY device_type;
-- OVERALL CVR
SELECT 
    COUNT(DISTINCT o.order_id) * 1.0 / COUNT(DISTINCT s.website_session_id) AS conversion_rate
FROM website_sessions s
LEFT JOIN orders o
    ON s.website_session_id = o.website_session_id;


-- CVR by utm_source / campaign / device_type
SELECT 
    s.utm_source,
    s.utm_campaign,
    s.device_type,
    COUNT(DISTINCT o.order_id) AS orders,
    COUNT(DISTINCT s.website_session_id) AS sessions,
    ROUND(COUNT(DISTINCT o.order_id) * 1.0 / COUNT(DISTINCT s.website_session_id), 4) AS conversion_rate
FROM website_sessions s
LEFT JOIN orders o
    ON s.website_session_id = o.website_session_id
GROUP BY 
    s.utm_source,
    s.utm_campaign,
    s.device_type
ORDER BY conversion_rate DESC;

-- Revenue Per Session (RPS)
SELECT 
    s.utm_source,
    s.device_type,
    COUNT(DISTINCT s.website_session_id) AS sessions,
    SUM(IFNULL(o.price_usd, 0)) AS revenue,
    ROUND(
      SUM(IFNULL(o.price_usd, 0)) / NULLIF(COUNT(DISTINCT s.website_session_id), 0),
      2
    ) AS rps
FROM website_sessions s
LEFT JOIN orders o 
    ON s.website_session_id = o.website_session_id
GROUP BY s.utm_source, s.device_type
ORDER BY rps DESC;

-- New vs Repeat Customers
WITH first_order AS (
    SELECT 
        user_id, 
        MIN(created_at) AS first_order_date
    FROM orders
    GROUP BY user_id
)
SELECT 
    CASE WHEN o.created_at = f.first_order_date THEN 'New' ELSE 'Repeat' END AS customer_type,
    COUNT(DISTINCT o.order_id) AS orders,
    COUNT(DISTINCT o.user_id) AS unique_customers,
    ROUND(SUM(o.price_usd), 2) AS revenue
FROM orders o
JOIN first_order f 
    ON o.user_id = f.user_id
GROUP BY customer_type;

 -- Cross-Sell Impact (multi-item orders vs single)
 WITH items_per_order AS (
    SELECT 
        order_id, 
        COUNT(order_item_id) AS items_count
    FROM order_items
    GROUP BY order_id
)
SELECT 
    CASE WHEN ipo.items_count > 1 THEN 'Cross-Sell' ELSE 'Single Item' END AS order_type,
    COUNT(DISTINCT o.order_id) AS orders,
    ROUND(AVG(o.price_usd), 2) AS avg_order_value,
    ROUND(SUM(o.price_usd), 2) AS total_revenue
FROM orders o
JOIN items_per_order ipo 
    ON o.order_id = ipo.order_id
GROUP BY order_type;

