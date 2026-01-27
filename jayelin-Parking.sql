-- ========================================================================= Parking by Month ===========================================================================================================
-- main table by month  1,833,083
select date_format(convert_tz(exit_date_time, '+00:00', '+08:00'), '%Y-%m'), sum(tran_amount/100)
from parking_transaction pt
WHERE convert_tz(exit_date_time, '+00:00', '+08:00') >= '2025-01-01 00:00:00' and convert_tz(exit_date_time, '+00:00', '+08:00') <= '2025-03-31 23:59:59'
and parking_type_id in (1,2)
and pt.payment_status = 1
group by date_format(convert_tz(exit_date_time, '+00:00', '+08:00'), '%Y-%m')
order by date_format(convert_tz(exit_date_time, '+00:00', '+08:00'), '%Y-%m')

-- jun to oct table by month 1,782,456
select date_format(convert_tz(exit_date_time, '+00:00', '+08:00'), '%Y-%m'), sum(tran_amount/100)
from parking_transaction_2025_Jun_2025_Oct_ndc pt
WHERE convert_tz(exit_date_time, '+00:00', '+08:00') >= '2025-01-01 00:00:00' and convert_tz(exit_date_time, '+00:00', '+08:00') <= '2025-12-31 23:59:59'
and parking_type_id in (1,2)
and pt.payment_status = 1
group by date_format(convert_tz(exit_date_time, '+00:00', '+08:00'), '%Y-%m')
order by date_format(convert_tz(exit_date_time, '+00:00', '+08:00'), '%Y-%m')

-- apr to may 1,782,456
select date_format(convert_tz(exit_date_time, '+00:00', '+08:00'), '%Y-%m'), sum(tran_amount/100)
from parking_transaction_2025_Apr_2025_May_ndc pt
WHERE convert_tz(exit_date_time, '+00:00', '+08:00') >= '2025-01-01 00:00:00' and convert_tz(exit_date_time, '+00:00', '+08:00') <= '2025-12-31 23:59:59'
and parking_type_id in (1,2)
and pt.payment_status = 1
group by date_format(convert_tz(exit_date_time, '+00:00', '+08:00'), '%Y-%m')
order by date_format(convert_tz(exit_date_time, '+00:00', '+08:00'), '%Y-%m')

-- jan to mar 
select date_format(convert_tz(exit_date_time, '+00:00', '+08:00'), '%Y-%m'), sum(tran_amount/100)
from parking_transaction_2025_Jan_2025_Mar_ndc pt
WHERE convert_tz(exit_date_time, '+00:00', '+08:00') >= '2025-01-01 00:00:00' and convert_tz(exit_date_time, '+00:00', '+08:00') <= '2025-12-31 23:59:59'
and parking_type_id in (1,2)
and pt.payment_status = 1
group by date_format(convert_tz(exit_date_time, '+00:00', '+08:00'), '%Y-%m')
order by date_format(convert_tz(exit_date_time, '+00:00', '+08:00'), '%Y-%m')

-- ========================================================================= Parking by Payment Method ===========================================================================================================
-- payment_method  1,833,083
select payment_method, sum(tran_amount/100)
from parking_transaction pt
WHERE convert_tz(exit_date_time, '+00:00', '+08:00') >= '2025-01-01 00:00:00' and convert_tz(exit_date_time, '+00:00', '+08:00') <= '2025-03-31 23:59:59'
and parking_type_id in (1,2)
and pt.payment_status = 1
group by payment_method

select * from parking_transaction limit 1

-- jun to oct table by month 1,782,456
select payment_method, sum(tran_amount/100)
from parking_transaction_2025_Jun_2025_Oct_ndc pt
WHERE convert_tz(exit_date_time, '+00:00', '+08:00') >= '2025-01-01 00:00:00' and convert_tz(exit_date_time, '+00:00', '+08:00') <= '2025-12-31 23:59:59'
and parking_type_id in (1,2)
and pt.payment_status = 1
group by payment_method

-- apr to may 1,782,456
select payment_method, sum(tran_amount/100)
from parking_transaction_2025_Apr_2025_May_ndc pt
WHERE convert_tz(exit_date_time, '+00:00', '+08:00') >= '2025-01-01 00:00:00' and convert_tz(exit_date_time, '+00:00', '+08:00') <= '2025-12-31 23:59:59'
and parking_type_id in (1,2)
and pt.payment_status = 1
group by payment_method

-- jan to mar 
select payment_method, sum(tran_amount/100)
from parking_transaction_2025_Jan_2025_Mar_ndc pt
WHERE convert_tz(exit_date_time, '+00:00', '+08:00') >= '2025-01-01 00:00:00' and convert_tz(exit_date_time, '+00:00', '+08:00') <= '2025-12-31 23:59:59'
and parking_type_id in (1,2)
and pt.payment_status = 1
group by payment_method

-- ========================================================================= No. of Carparks ===========================================================================================================
-- 1,833,083  -- 59 distinct carparks if parking_type_id IN (1,2)    112 carparks if no filter parking_type_id
select count(distinct(car_park_id))
from parking_transaction pt
WHERE convert_tz(exit_date_time, '+00:00', '+08:00') >= '2025-01-01 00:00:00' and convert_tz(exit_date_time, '+00:00', '+08:00') <= '2025-03-31 23:59:59'
-- and parking_type_id in (1,2) 
and pt.payment_status = 1

-- view distinct cp name from main table
select distinct(cp.name)
from parking_transaction pt 
JOIN car_park cp ON pt.car_park_id = cp.id
WHERE convert_tz(exit_date_time, '+00:00', '+08:00') >= '2025-01-01 00:00:00' and convert_tz(exit_date_time, '+00:00', '+08:00') <= '2025-03-31 23:59:59'
-- and parking_type_id in (1,2) 
and pt.payment_status = 1

select * from parking_transaction limit 1

-- jun to oct table 1,782,456
select count(distinct(car_park_id))
from parking_transaction_2025_Jun_2025_Oct_ndc pt
WHERE convert_tz(exit_date_time, '+00:00', '+08:00') >= '2025-01-01 00:00:00' and convert_tz(exit_date_time, '+00:00', '+08:00') <= '2025-12-31 23:59:59'
and parking_type_id in (1,2) and pt.payment_status = 1

-- apr to may  59 distinct carparks
select count(distinct(car_park_id))
from parking_transaction_2025_Apr_2025_May_ndc pt
WHERE convert_tz(exit_date_time, '+00:00', '+08:00') >= '2025-01-01 00:00:00' and convert_tz(exit_date_time, '+00:00', '+08:00') <= '2025-12-31 23:59:59'
and parking_type_id in (1,2) and pt.payment_status = 1

-- jan to mar 59 distinct carparks if exclude 
select count(distinct(car_park_id))
from parking_transaction_2025_Jan_2025_Mar_ndc pt
WHERE convert_tz(exit_date_time, '+00:00', '+08:00') >= '2025-01-01 00:00:00' and convert_tz(exit_date_time, '+00:00', '+08:00') <= '2025-12-31 23:59:59'
-- and parking_type_id in (1,2) 
and pt.payment_status = 1

-- ========================================================================= Season ===========================================================================================================
-- season by month
select date_format(end_date,'%Y-%m'), sum(amount/100)
from season_list
where year(end_date) = 2025
group by date_format(end_date,'%Y-%m')

-- season by payment method 2025
select payment_type, date_format(end_date,'%Y-%m'), sum(amount/100)
from season_list
where year(end_date) = 2025
group by payment_type

-- ========================================================================= Prepaid ===========================================================================================================
select SUM(total_amount) from company_invoice
where type = 'PREPAID' 
and issued_date >= '2025-01-01 00:00:00' and issued_date <= '2025-12-31 23:59:59'

-- Prepaid by Month
select date_format(convert_tz(issued_date, '+00:00', '+08:00'), '%Y-%m'), SUM(total_amount) 
from company_invoice
where type = 'PREPAID' and issued_date >= '2025-01-01 00:00:00' and issued_date <= '2025-12-31 23:59:59'
group by date_format(convert_tz(issued_date, '+00:00', '+08:00'), '%Y-%m')
order by date_format(convert_tz(issued_date, '+00:00', '+08:00'), '%Y-%m')
 