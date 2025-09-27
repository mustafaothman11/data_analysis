-- COO 
-- Seasonality (Monthly / Weekly Orders & Sessions)
-- Monthly Seasonality
SELECT 
    YEAR(s.created_at) AS year,
    MONTH(s.created_at) AS month,
    COUNT(DISTINCT s.website_session_id) AS sessions,
    COUNT(DISTINCT o.order_id) AS orders
FROM website_sessions s
LEFT JOIN orders o 
    ON s.website_session_id = o.website_session_id
GROUP BY YEAR(s.created_at), MONTH(s.created_at)
ORDER BY year, month;

-- Weekly Seasonality
SELECT 
    YEARWEEK(s.created_at, 1) AS year_week,
    COUNT(DISTINCT s.website_session_id) AS sessions,
    COUNT(DISTINCT o.order_id) AS orders
FROM website_sessions s
LEFT JOIN orders o 
    ON s.website_session_id = o.website_session_id
GROUP BY YEARWEEK(s.created_at, 1)
ORDER BY year_week;

-- Daily & Hourly Traffic (for staff planning)
-- Daily Traffic
SELECT 
    DATE(s.created_at) AS date,
    COUNT(DISTINCT s.website_session_id) AS sessions
FROM website_sessions s
GROUP BY DATE(s.created_at)
ORDER BY date;

-- Hourly Traffic (Heatmap basis)
SELECT 
    DAYNAME(s.created_at) AS day_of_week,
    HOUR(s.created_at) AS hour,
    COUNT(DISTINCT s.website_session_id) AS sessions
FROM website_sessions s
GROUP BY DAYNAME(s.created_at), HOUR(s.created_at)
ORDER BY FIELD(day_of_week, 'Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'),
         hour;

-- Refund Rates by Product (Supplier Quality)
SELECT 
    p.product_id,
    p.product_name,
    COUNT(oi.order_item_id) AS total_sold,
    COUNT(r.order_item_refund_id) AS total_refunds,
    ROUND(COUNT(r.order_item_refund_id) * 1.0 / COUNT(oi.order_item_id), 4) AS refund_rate
FROM order_items oi
JOIN products p 
    ON oi.product_id = p.product_id
LEFT JOIN order_item_refunds r
    ON oi.order_item_id = r.order_item_id
GROUP BY p.product_id, p.product_name
ORDER BY refund_rate DESC;



