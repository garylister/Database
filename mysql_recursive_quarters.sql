WITH recursive xym  as (
-- this is the counter that runs the script
SELECT 12 AS cnt,
-- set the initial yearmonth to the next year and current month
CONCAT( year(date_add(CURRENT_date, interval 12 month)), lpad(month(date_add(CURRENT_date, interval 12 month )) ,2, 0))  as yearmonth,
-- set the first day of current month of the next year
date_add(date_add(last_day(date_add(CURRENT_date, interval 12 month)), interval +1 day), interval -1 month) AS beg_date,
-- set the last day of current month of the next year
last_day(date_add(CURRENT_date, interval 12 month)) AS end_date,
-- set the current month by name and the next year
CONCAT(monthname(date_add(CURRENT_date, interval 12 month)),CONCAT(' ',YEAR(date_add(CURRENT_date, interval 12 month)))) AS month_desc,
-- set the year for the next year and add the quarter of the year
CONCAT(YEAR(date_add(CURRENT_date, interval 12 month)) , CONCAT(' (', CONCAT(quarter(date_add(CURRENT_date, interval 12 month)),
	CASE quarter(date_add(CURRENT_date, interval 12 month) )
	when 1 then 'st Quarter)'
	when 2 then 'nd Quarter)'
	when 3 then 'rd Quarter)'
	else 'th Quarter)' END))) AS quarter
FROM dual
UNION ALL
-- decrement the cnt number for the next run
SELECT a.cnt -1 AS cnt , 
-- get the yearmonth prior to the previous one 
CONCAT( year(date_add(CURRENT_date, interval a.cnt -1 month)), lpad(month(date_add(CURRENT_date, interval a.cnt-1 month)) ,2, 0))  as yearmonth,
-- get the first day of the month prior to the previous one
date_add(date_add(last_day(date_add(CURRENT_date, interval a.cnt-1 month)), interval +1 day), interval -1 month) AS beg_date,
-- get the last day of the month prior to the previous one
last_day(date_add(CURRENT_date, interval a.cnt-1 month)) AS end_date,
-- get the month by name and year that's prior to the previous one 
CONCAT(monthname(date_add(CURRENT_date, interval a.cnt-1 month)),CONCAT(' ',YEAR(date_add(CURRENT_date, interval a.cnt-1 month)))) AS month_desc,
-- get the year and add the quarter of the year that equates to the month prior to the previous one
CONCAT(YEAR(date_add(CURRENT_date, interval a.cnt-1 month)) , CONCAT(' (', CONCAT(quarter(date_add(CURRENT_date, interval a.cnt-1 month)),
	CASE quarter(date_add(CURRENT_date, interval a.cnt-1 month) )
	when 1 then 'st Quarter)'
	when 2 then 'nd Quarter)'
	when 3 then 'rd Quarter)'
	else 'th Quarter)' END))) AS quarter
FROM xym a 
-- where condition to end the script so it doesn't run forever
WHERE CONCAT( year(date_add(CURRENT_date, INTERVAL a.cnt -1 month)), lpad(month(date_add(CURRENT_date, interval a.cnt-1 month)) ,2, 0)) 
--	 > 201812  for testing
	-- set the date to 201912 to match the current results in the table in DW3 which start at 201001 
	> CONCAT( year(CURRENT_date)-12,  12)
)
SELECT yearmonth, beg_date, end_date, month_desc, quarter FROM xym ORDER BY yearmonth;
