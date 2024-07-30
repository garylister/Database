
WITH recursive xym 
AS (
-- this is the counter that runs the script
SELECT 12 AS cnt,
-- set the initial year_month to the next year and first month
extract( year from (current_timestamp + '12 month')) || 
ltrim(to_char(extract( month from (current_timestamp + '12 month')), '00'), ' ')
	as year_month,
-- set the first day of the next year
date_trunc('month', current_timestamp + '12 month')::date AS beg_date,
-- set the last day of the next year
-- you have to get the first day of the next month and subract 1 day  
(date_trunc('month', current_timestamp + '12 month') + interval '1 month - 1 day')::date AS end_date,
-- set the month by name and the next year
to_char((current_timestamp + '12 month'), 'Month') || ' ' || 
  extract( year from (current_timestamp + '12 month')) AS month_desc,
-- set the year for the next year and add the quarter of the year
extract( year from (current_timestamp + '12 month')) || ' (' ||  
extract( quarter from (current_timestamp + '12 month')) ||
	CASE 
	when extract( quarter from (current_timestamp + '12 month')) = 1 then 'st Quarter)'
	when extract( quarter from (current_timestamp + '12 month')) = 2 then 'nd Quarter)'
	when extract( quarter from (current_timestamp + '12 month')) = 3 then 'rd Quarter)'
	else 'th Quarter)' end AS quarter
   
UNION ALL
-- decrement the cnt number for the next run
SELECT cnt -1 AS cnt , 
-- get the year_month to prior to the previous one 
extract( year from (current_timestamp + make_interval(months => (cnt -1)))) || 
ltrim(to_char(extract( month from (current_timestamp + make_interval(months => cnt -1))), '00'), ' ')  as year_month,
-- get the first day of the month prior to the previous one
-- cast the result as date to remove the time from the timestamp  
date_trunc('month', current_timestamp + make_interval(months => (cnt -1)))::date AS beg_date,
-- get the last day of the month prior to the previous one
-- you have to get the first day of the next month and subract 1 day
-- cast the result as date to remove the time from the timestamp   
(date_trunc('month', current_timestamp + make_interval(months => (cnt -1))) + interval '1 month - 1 day')::date AS end_date,
-- get the month by name and year that's prior to the previous one 
to_char((current_timestamp + make_interval(months => (cnt -1))), 'Month') || ' ' ||
	extract( year from (current_timestamp + make_interval(months => (cnt -1)))) AS month_desc,
-- get the year and add the quarter of the year that equates to the month prior to the previous one
extract( year from (current_timestamp + make_interval(months => (cnt -1)))) || ' (' || 
	extract( quarter from (current_timestamp + make_interval(months => (cnt -1)))) ||
	CASE 
	when extract( quarter from (current_timestamp + make_interval(months => (cnt -1)))) = 1 then 'st Quarter)'
	when extract( quarter from (current_timestamp + make_interval(months => (cnt -1)))) = 2 then 'nd Quarter)'
	when extract( quarter from (current_timestamp + make_interval(months => (cnt -1)))) = 3 then 'rd Quarter)'
	else 'th Quarter)' end AS quarter
FROM xym 
-- where condition to end the script so it doesn't run forever
WHERE extract( year from (current_timestamp + make_interval(months => (cnt -1)))) || 
ltrim(to_char(extract( month from (current_timestamp + make_interval(months => cnt -1))), '00'), ' ')
	-- > '201812'  -- for testing
	-- set the date to match the current results in the table which go back 12 years
	> concat(extract(year from current_timestamp)-12, 12) 
)
SELECT year_month, beg_date, end_date, month_desc, quarter FROM xym ORDER BY year_month;
end


