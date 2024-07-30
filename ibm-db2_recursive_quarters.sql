WITH xym (cnt, year_month, beg_date, end_date, month_desc, quarter) AS (
-- this is the counter that runs the script
SELECT 12 AS cnt,
-- set the initial year_month to the next year and first month
CONCAT( year(add_months(CURRENT date,  12)), lpad(month(add_months(CURRENT date, 12)) ,2, 0))  as year_month,
-- set the first day of the next year
first_day(add_months(CURRENT date, 12)) AS beg_date,
-- set the last day of the next year
last_day(add_months(CURRENT date, 12)) AS end_date,
-- set the month by name and the next year
CONCAT(monthname(add_months(CURRENT date, 12)),CONCAT(' ',YEAR(add_months(CURRENT date, 12)))) AS month_desc,
-- set the year for the next year and add the quarter of the year
CONCAT(YEAR(add_months(CURRENT date, 12)) , CONCAT(' (', CONCAT(quarter(add_months(CURRENT date, 12)),
	CASE quarter(add_months(CURRENT date, 12) )
	when 1 then 'st Quarter)'
	when 2 then 'nd Quarter)'
	when 3 then 'rd Quarter)'
	else 'th Quarter)' END))) AS quarter
FROM SYSIBM.sysdummy1
UNION ALL
-- decrement the cnt number for the next run
SELECT a.cnt -1 AS cnt , 
-- get the year_month to prior to the previous one 
CONCAT( year(add_months(CURRENT date, a.cnt -1)), lpad(month(add_months(CURRENT date, a.cnt-1)) ,2, 0))  as year_month,
-- get the first day of the month prior to the previous one
first_day(add_months(CURRENT date, a.cnt-1)) AS beg_date,
-- get the last day of the month prior to the previous one
last_day(add_months(CURRENT date, a.cnt-1)) AS end_date,
-- get the month by name and year that's prior to the previous one 
CONCAT(monthname(add_months(CURRENT date, a.cnt-1)),CONCAT(' ',YEAR(add_months(CURRENT date, a.cnt-1)))) AS month_desc,
-- get the year and add the quarter of the year that equates to the month prior to the previous one
CONCAT(YEAR(add_months(CURRENT date, a.cnt-1)) , CONCAT(' (', CONCAT(quarter(add_months(CURRENT date, a.cnt-1)),
	CASE quarter(add_months(CURRENT date, a.cnt-1) )
	when 1 then 'st Quarter)'
	when 2 then 'nd Quarter)'
	when 3 then 'rd Quarter)'
	else 'th Quarter)' END))) AS quarter
FROM xym a , SYSIBM.sysdummy1 b
-- where condition to end the script so it doesn't run forever
WHERE CONCAT( year(add_months(CURRENT date, a.cnt -1)), lpad(month(add_months(CURRENT date, a.cnt-1)) ,2, 0)) 
--	 > 201812  for testing
	-- set the date to match the current results in the table which go back 12 years
	> CONCAT( year(CURRENT date)-12,  12)
)
SELECT year_month, beg_date, end_date, month_desc, quarter FROM xym ORDER BY year_month;
end
