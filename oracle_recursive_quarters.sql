
WITH xym (cnt, year_month, beg_date, end_date, month_desc, quarter) AS
(
-- this is the counter that runs the script
SELECT 12 AS cnt,
-- set the initial year_month to the next year and first month
CONCAT( extract(year from (add_months(current_date,12))), 
       lpad(extract(month from (add_months(current_date,12))),2,00))  as year_month,
-- set the first day of the next year
-- you have to get the last day of the previous month and add one day  
to_char(last_day(add_months((CURRENT_date - interval '1' month), 12)) + interval '1' day, 'DD-MM-YYYY') AS beg_date,
-- set the last day of the next year
to_char(last_day(add_months(CURRENT_date, 12)), 'DD-MM-YYYY') AS end_date,
-- set the month by name and the next year
CONCAT(to_char(add_months(CURRENT_date, 12),'MONTH'),
  CONCAT(' ',extract(year from (add_months(current_date,12))))) AS month_desc,
-- set the year for the next year and add the quarter of the year
CONCAT(extract(year from add_months(CURRENT_date, 12)) , 
       CONCAT(' (', CONCAT(to_char(add_months(CURRENT_date, 12), 'Q'),
	CASE to_char(add_months(CURRENT_date, 12), 'Q')
	when '1' then 'st Quarter)'
	when '2' then 'nd Quarter)'
	when '3' then 'rd Quarter)'
	else 'th Quarter)' END))) AS quarter
FROM dual
UNION ALL
-- decrement the cnt number for the next run
SELECT a.cnt -1 AS cnt , 
-- get the year_month to prior to the previous one 
CONCAT( extract(year from (add_months(current_date, a.cnt -1))), 
       lpad(extract(month from (add_months(current_date, a.cnt-1))) ,2, 00))   as year_month,
-- get the first day of the month prior to the previous one
-- you have to get the last day of the previous month and add one day  
to_char(last_day(add_months((CURRENT_date - interval '1' month), a.cnt-1)) + interval '1' day, 'DD-MM-YYYY') AS beg_date,
-- get the last day of the month prior to the previous one
to_char(last_day(add_months(CURRENT_date, a.cnt-1)), 'DD-MM-YYYY') AS end_date,
-- get the month by name and year that's prior to the previous one 
CONCAT(to_char(add_months(CURRENT_date, a.cnt-1),'MONTH'),
  CONCAT(' ',extract(year from (add_months(current_date, a.cnt-1))))) AS month_desc,
-- get the year and add the quarter of the year that equates to the month prior to the previous one
CONCAT(extract(year from add_months(CURRENT_date, a.cnt-1)) , 
       CONCAT(' (', CONCAT(to_char(add_months(CURRENT_date, a.cnt-1), 'Q'),
	CASE to_char(add_months(CURRENT_date, a.cnt-1),'Q' )
	when '1' then 'st Quarter)'
	when '2' then 'nd Quarter)'
	when '3' then 'rd Quarter)'
	else 'th Quarter)' END))) AS quarter
FROM xym a , dual b
-- where condition to end the script so it doesn't run forever
WHERE CONCAT( extract(year from (add_months(current_date, a.cnt -1))), 
      lpad(extract(month from (add_months(current_date, a.cnt-1))) ,2, 0)) 
--	 > 201812  -- for testing
	-- set the date to match the current results in the table which go back 12 years
	>  CONCAT( extract(year from (current_date - interval '12' year)),  12)
)
SELECT year_month, beg_date, end_date, month_desc, quarter FROM xym ORDER BY year_month;
