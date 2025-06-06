WITH CTE_MY_DATE AS (
SELECT DATEADD(DAY, SEQ4(), '2017-01-01 00:00:00') AS MY_DATE
FROM TABLE(GENERATOR(ROWCOUNT=>20000))
)
SELECT 
TO_DATE(MY_DATE) as fulldate
,YEAR(MY_DATE) as year_number
,MONTH(MY_DATE) as month_number
,MONTHNAME(MY_DATE) as month_name
,dayofmonth(MY_DATE) as day_of_month
,DAYOFWEEK(MY_DATE) as day_of_week
,WEEKOFYEAR(MY_DATE) as week_of_year
,DAYOFYEAR(MY_DATE) as day_of_year
,{{ get_date_sid('MY_DATE') }} as DATE_ID
FROM CTE_MY_DATE


