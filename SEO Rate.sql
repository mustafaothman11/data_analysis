-- SEO Rate  
WITH daily_views AS (
    SELECT 
        DATE(created_at) AS date,
        COUNT(*) AS pageviews
    FROM website_pageviews
    GROUP BY DATE(created_at)
)
SELECT 
    date,
    pageviews,
    LAG(pageviews) OVER (ORDER BY date) AS prev_pageviews,
    ROUND(
        (pageviews - LAG(pageviews) OVER (ORDER BY date)) * 100.0 
        / NULLIF(LAG(pageviews) OVER (ORDER BY date), 0), 
    2) AS SEO_rate
FROM daily_views
ORDER BY date;
