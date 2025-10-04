-- website pageviews growth trend
with monthy_views as
(
select 
Year (created_at) as year ,
Month (created_at) as month,
count(website_pageview_id) as pageviews
from website_pageviews
group by Year (created_at) , Month (created_at)
)

select
 year ,
 month,
 pageviews,
 lag(pageviews) over (order by year, month) as prev_pageviews
 ,(pageviews - lag(pageviews) over (order by year, month)) as the_growth
from  monthy_views

