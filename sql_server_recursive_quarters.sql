with xym as (
-- this is the counter that runs the script
  select 12 as cnt,
-- set the initial yearmonth to the next year and current month
 concat(year(dateadd(month, 12, getdate())), format(MONTH(dateadd(month, 12, getdate())), '00') ) as year_month,
-- set the first day of current month of the next year
-- you have to get the last day of the previous month and add one day
 dateadd(day, 1, eomonth(dateadd(month, -1, dateadd(month, 12, getdate())))) as beg_date,
-- set the last day of the next year
 eomonth(dateadd(month, 12, getdate())) as end_date,
-- set the month by name and the next year
 concat(datename(month, dateadd(month, 12,getdate())),' ', year(dateadd(month, 12, getdate())) ) as month_desc,
-- set the year for the next year and add the quarter of the year
 concat( year(dateadd(month, 12, getdate())), ' (', datepart(quarter, dateadd(month, 12, getdate())), 
	case datepart(quarter, dateadd(month, 12, getdate()))
    when 1 then 'st Quarter)'
    when 2 then 'nd Quarter)' 
    when 3 then 'rd Quarter)'
    else 'th Quarter)' 
    end ) as quarter
 union all
-- decrement the cnt number for the next run
 select a.cnt-1 as cnt,
-- get the year_month to prior to the previous one
 concat(year(dateadd(month, a.cnt-1, getdate())), format(MONTH(dateadd(month, a.cnt-1, getdate())), '00') ) as year_month,
-- get the first day of the month prior to the previous one
-- you have to get the last day of the previous month and add one day 
 dateadd(day, 1, eomonth(dateadd(month, -1, dateadd(month, a.cnt-1, getdate())))) as beg_date,
-- get the last day of the month prior to the previous one 
 eomonth(dateadd(month, a.cnt-1, getdate())) as end_date,
-- get the month by name and year that's prior to the previous one 
 concat(datename(month, dateadd(month, a.cnt-1, getdate())),' ', year(dateadd(month, a.cnt-1, getdate())) ) as month_desc,
-- get the year and add the quarter of the year that equates to the month prior to the previous one 
 concat( year(dateadd(month, a.cnt-1, getdate())), ' (', datepart(quarter, dateadd(month, a.cnt-1, getdate())), 
	case datepart(quarter, dateadd(month, a.cnt-1, getdate()))
    when 1 then 'st Quarter)'
    when 2 then 'nd Quarter)' 
    when 3 then 'rd Quarter)'
    else 'th Quarter)' 
    end ) as quarter
 from xym a 
-- where condition to end the script so it doesn't run forever
 where concat(year(dateadd(month, a.cnt-1, getdate())), format(MONTH(dateadd(month, a.cnt-1, getdate())), '00') )
--	 > 201812  -- for testing
	-- set the date to match the current results in the table which go back 12 years 
  -- > concat( year(getdate())-12, 12)
    -- set to only 7 years so the max recursion of 100 in sql fiddle isn't exhausted
 	> concat( year(getdate())-7, 12)
    ) 
   SELECT year_month, beg_date, end_date, month_desc, quarter FROM xym ORDER BY year_month;


