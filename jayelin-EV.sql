
-- ===================================================================== EV Total ===================================================================
-- $1,626,326
select sum(pt.tran_amount/100)
from parking_transaction pt
JOIN evcharging evc on pt.transaction_id = evc.id
JOIN car_park cp ON pt.car_park_id = cp.id
JOIN cp_indent ci on evc.order_id = ci.session_id
WHERE convert_tz(pt.exit_date_time, '+00:00', '+08:00') >= '2025-01-01 00:00:00' and convert_tz(pt.exit_date_time, '+00:00', '+08:00') <= '2025-12-31 23:59:59'
and pt.payment_status = 1
-- ===================================================================== EV Tran Amt by Month ===================================================================
select date_format(convert_tz(pt.exit_date_time, '+00:00', '+08:00'), '%Y-%m'), sum(tran_amount/100), sum(ci.power), count(*)
from parking_transaction pt
JOIN evcharging evc on pt.transaction_id = evc.id
JOIN car_park cp ON pt.car_park_id = cp.id
JOIN cp_indent ci on evc.order_id = ci.session_id
WHERE convert_tz(exit_date_time, '+00:00', '+08:00') >= '2025-01-01 00:00:00' and convert_tz(exit_date_time, '+00:00', '+08:00') <= '2025-12-31 23:59:59'
and pt.payment_status = 1
GROUP BY date_format(convert_tz(pt.exit_date_time, '+00:00', '+08:00'), '%Y-%m')
order by date_format(convert_tz(pt.exit_date_time, '+00:00', '+08:00'), '%Y-%m')

-- ===================================================================== All Chargers PPU Users ===================================================================

select date_format(convert_tz(exit_date_time, '+00:00', '+08:00'), '%Y-%m'), sum(tran_amount/100), sum(ci.power), count(*)
from parking_transaction pt
JOIN evcharging evc on pt.transaction_id = evc.id
JOIN car_park cp ON pt.car_park_id = cp.id
JOIN cp_indent ci on evc.order_id = ci.session_id
WHERE convert_tz(exit_date_time, '+00:00', '+08:00') >= '2025-01-01 00:00:00' and convert_tz(exit_date_time, '+00:00', '+08:00') <= '2025-12-31 23:59:59'
and pt.payment_status = 1 and ci.note is null -- null then PPU
group by date_format(convert_tz(exit_date_time, '+00:00', '+08:00'), '%Y-%m')

-- ===================================================================== All Chargers Corporate Paid ===================================================================

select date_format(convert_tz(exit_date_time, '+00:00', '+08:00'), '%Y-%m'), sum(tran_amount/100), sum(ci.power), count(*)
from parking_transaction pt
JOIN evcharging evc on pt.transaction_id = evc.id
JOIN car_park cp ON pt.car_park_id = cp.id
JOIN cp_indent ci on evc.order_id = ci.session_id
WHERE convert_tz(exit_date_time, '+00:00', '+08:00') >= '2025-01-01 00:00:00' and convert_tz(exit_date_time, '+00:00', '+08:00') <= '2025-12-31 23:59:59'
and pt.payment_status = 1 and ci.note is not null -- not null then corporate
and pt.tran_amount != 0 -- corporate paid
group by date_format(convert_tz(exit_date_time, '+00:00', '+08:00'), '%Y-%m')

-- ===================================================================== All Chargers Corporate Free ===================================================================

select date_format(convert_tz(exit_date_time, '+00:00', '+08:00'), '%Y-%m'), sum(tran_amount/100), sum(ci.power), count(*), (sum(ci.power)/count(*)), sum(tran_amount/100)/sum(ci.power)
from parking_transaction pt
JOIN evcharging evc on pt.transaction_id = evc.id
JOIN car_park cp ON pt.car_park_id = cp.id
JOIN cp_indent ci on evc.order_id = ci.session_id
WHERE convert_tz(exit_date_time, '+00:00', '+08:00') >= '2025-01-01 00:00:00' and convert_tz(exit_date_time, '+00:00', '+08:00') <= '2025-12-31 23:59:59'
and pt.payment_status = 1 and ci.note is not null -- not null then corporate
and pt.tran_amount = 0 -- corporate free
group by date_format(convert_tz(exit_date_time, '+00:00', '+08:00'), '%Y-%m')

-- ===================================================================== QR Valley ========================================================================

select * from parking_transaction
where car_park_id = 408
and remarks = 'Adhoc Payment'
and payment_amount <> 0
and payment_status = 1
and driver_code is null

-- ========================================================== All Chargers ID by Carpark Name ==========================================================

select cp.name, ci.stake_id, sum(tran_amount/100), sum(ci.power), count(*), (sum(ci.power)/count(*)), sum(tran_amount/100)/sum(ci.power)
from parking_transaction pt
JOIN evcharging evc on pt.transaction_id = evc.id
JOIN car_park cp ON pt.car_park_id = cp.id
JOIN cp_indent ci on evc.order_id = ci.session_id
WHERE convert_tz(exit_date_time, '+00:00', '+08:00') >= '2025-01-01 00:00:00' and convert_tz(exit_date_time, '+00:00', '+08:00') <= '2025-12-31 23:59:59'
and pt.payment_status = 1
group by cp.name
order by sum(ci.power) desc

-- ========================================================== EV Tran Amt, Power, Vol, Avg Tran Price, Charge Price by Region ==========================================================
select CASE
WHEN cp.name IN ('(Private) Currency House','(Private) EVOne [DSO]','(Private) EVOne [Sulisam Investments]','(Private) Holt Residences','(Private) MAS Building',
	'(Private) N','(Private) Novena Regency','(Private) One Leicester','(Private) One Robin','(Private) Parc Stevens','(Private) ST Elec Hub','(Private) State Courts of Singapore',
	'(Private) Sunglade Condo','(Private) Tan Tock Meng Tower','AIA Alexandra','AIA Tower','LTA - Corporate HQ','NTU EV [LKC Medicine]','NTU EV [One North]','TOYOGO HQ') THEN 'Central'
WHEN cp.name IN ('(Private) AIA Tampines', '(Private) BluWaters 2 Condo', '(Private) Eastwood Regency', '(Private) EVOne [KLN Logistics Tampines]', 'EVOne [SIA Airline House]',
    'EVOne [SIA Training Center]', 'EVOne [StorHub Changi]') THEN 'East'
WHEN cp.name IN ('(Private) CCL Design', '(Private) EVOne [ TYJ ]', 'EVOne [ StorHub Marsiling ]', 'EVOne [Harvest Woodlands]') THEN 'North'
WHEN cp.name IN ('(Private) EVOne [DHL Greenwich]','(Private) Kovan Residences','(Private) ST Engineering Hub AMK','(Private) The Waterline','EVOne [ Jalan Pemimpin ]','LTA - Sin Ming Office',
	'Natural Cool Defu','Union Gas [ Defu Lane ]') THEN 'North-East'
WHEN cp.name IN ('(Private) Katoen Natie (Jurong)','(Private) Regent Grove','(Private) ST Land Systems JBL','(Private) STEngg JE Hub','(Private) STEngg Marine Benoi','(Private) STEngg Marine Gul Rd',
	'(Private) Varsity Park Condo','EVOne [ Aste Global ]','EVOne [ DArena ]','EVOne [ Pioneer Center ]','EVOne [ StorHub Jurong East ]','EVOne [ Toh Guan #111 ]','EVOne [ Toh Guan #150 ]',
	'EVOne [Cnergy]','GoParkin Testing',
	'NTU EV [ Car Park A ]','NTU EV [ Car Park B ]','NTU EV [ Car Park Crescent ]','NTU EV [ Car Park D ]','NTU EV [ Car Park North Hill ]','NTU EV [ Car Park Q ]','NTU EV [ Car Park SBS ]',
	'YCH Bulim') THEN 'West'
ELSE concat(cp.name,' latitude',cp.latitude,' longitude',cp.longitude)
END AS region,
sum(tran_amount/100), sum(ci.power), count(*), (sum(ci.power)/count(*)), sum(tran_amount/100)/sum(ci.power)
from parking_transaction pt
JOIN evcharging evc on pt.transaction_id = evc.id
JOIN car_park cp ON pt.car_park_id = cp.id
JOIN cp_indent ci on evc.order_id = ci.session_id
-- WHERE pt.car_park_id in (select id from car_park where car_park_operator_id = 3)
WHERE convert_tz(exit_date_time, '+00:00', '+08:00') >= '2025-01-01 00:00:00' and convert_tz(exit_date_time, '+00:00', '+08:00') <= '2025-12-31 23:59:59'
and pt.payment_status = 1
group by region
order by sum(ci.power) desc

-- ===================================================================== Count Chargers by Region ===================================================================================
select CASE
WHEN cp.name IN ('(Private) Currency House','(Private) EVOne [DSO]','(Private) EVOne [Sulisam Investments]','(Private) Holt Residences','(Private) MAS Building',
	'(Private) N','(Private) Novena Regency','(Private) One Leicester','(Private) One Robin','(Private) Parc Stevens','(Private) ST Elec Hub','(Private) State Courts of Singapore',
	'(Private) Sunglade Condo','(Private) Tan Tock Meng Tower','AIA Alexandra','AIA Tower','LTA - Corporate HQ','NTU EV [LKC Medicine]','NTU EV [One North]','TOYOGO HQ') THEN 'Central'
WHEN cp.name IN ('(Private) AIA Tampines', '(Private) BluWaters 2 Condo', '(Private) Eastwood Regency', '(Private) EVOne [KLN Logistics Tampines]', 'EVOne [SIA Airline House]',
    'EVOne [SIA Training Center]', 'EVOne [StorHub Changi]') THEN 'East'
WHEN cp.name IN ('(Private) CCL Design', '(Private) EVOne [ TYJ ]', 'EVOne [ StorHub Marsiling ]', 'EVOne [Harvest Woodlands]') THEN 'North'
WHEN cp.name IN ('(Private) EVOne [DHL Greenwich]','(Private) Kovan Residences','(Private) ST Engineering Hub AMK','(Private) The Waterline','EVOne [ Jalan Pemimpin ]','LTA - Sin Ming Office',
	'Natural Cool Defu','Union Gas [ Defu Lane ]') THEN 'North-East'
WHEN cp.name IN ('(Private) Katoen Natie (Jurong)','(Private) Regent Grove','(Private) ST Land Systems JBL','(Private) STEngg JE Hub','(Private) STEngg Marine Benoi','(Private) STEngg Marine Gul Rd',
	'(Private) Varsity Park Condo','EVOne [ Aste Global ]','EVOne [ DArena ]','EVOne [ Pioneer Center ]','EVOne [ StorHub Jurong East ]','EVOne [ Toh Guan #111 ]','EVOne [ Toh Guan #150 ]',
	'EVOne [Cnergy]','GoParkin Testing',
	'NTU EV [ Car Park A ]','NTU EV [ Car Park B ]','NTU EV [ Car Park Crescent ]','NTU EV [ Car Park D ]','NTU EV [ Car Park North Hill ]','NTU EV [ Car Park Q ]','NTU EV [ Car Park SBS ]',
	'YCH Bulim') THEN 'West'
ELSE concat(cp.name,' latitude',cp.latitude,' longitude',cp.longitude)
END AS region,
count(distinct(ci.stake_id))
from parking_transaction pt
JOIN evcharging evc on pt.transaction_id = evc.id
JOIN car_park cp ON pt.car_park_id = cp.id
JOIN cp_indent ci on evc.order_id = ci.session_id
and convert_tz(exit_date_time, '+00:00', '+08:00') >= '2025-01-01 00:00:00' and convert_tz(exit_date_time, '+00:00', '+08:00') <= '2025-12-31 23:59:59'
and pt.payment_status = 1
group by region
order by count(distinct(ci.stake_id)) desc

select * from cp_indent limit 1

-- ========================================================== EV Tran Amt, Power, Vol, Avg Tran Price, Charge Price by Commercial / Private ==========================================================
select CASE
WHEN cp.name IN ('(Private) BluWaters 2 Condo','(Private) Eastwood Regency','(Private) Holt Residences','(Private) Kovan Residences','(Private) Novena Regency','(Private) One Leicester',
	'(Private) One Robin','(Private) Parc Stevens','(Private) Regent Grove','(Private) Sunglade Condo','(Private) Tan Tock Meng Tower','(Private) The Waterline',
	'(Private) Varsity Park Condo') THEN 'Condo'
WHEN cp.name IN ('(Private) AIA Tampines','(Private) CCL Design','(Private) Currency House','(Private) EVOne [ TYJ ]','(Private) EVOne [DHL Greenwich]','(Private) EVOne [DSO]',
'(Private) EVOne [KLN Logistics Tampines]','(Private) EVOne [Sulisam Investments]','(Private) Katoen Natie (Jurong)','(Private) MAS Building','(Private) N','(Private) ST Elec Hub',
'(Private) ST Engineering Hub AMK','(Private) ST Land Systems JBL','(Private) State Courts of Singapore','(Private) STEngg JE Hub','(Private) STEngg Marine Benoi','(Private) STEngg Marine Gul Rd',
'AIA Alexandra','AIA Tower','EVOne [SIA Airline House]','EVOne [SIA Training Center]') THEN 'Commercial'
WHEN cp.name IN ('EVOne [ Aste Global ]','EVOne [ DArena ]','EVOne [ Jalan Pemimpin ]','EVOne [ Pioneer Center ]','EVOne [ StorHub Jurong East ]','EVOne [ StorHub Marsiling ]',
	'EVOne [ Toh Guan #111 ]','EVOne [ Toh Guan #150 ]','EVOne [Cnergy]','EVOne [Harvest Woodlands]','EVOne [StorHub Changi]',
	'GoParkin Testing',
	'LTA - Corporate HQ','LTA - Sin Ming Office','Natural Cool Defu','NTU EV [ Car Park A ]','NTU EV [ Car Park B ]','NTU EV [ Car Park Crescent ]','NTU EV [ Car Park D ]','NTU EV [ Car Park North Hill ]',
	'NTU EV [ Car Park Q ]','NTU EV [ Car Park SBS ]','NTU EV [LKC Medicine]'
	'NTU EV [One North]','TOYOGO HQ','Union Gas [ Defu Lane ]','YCH Bulim') THEN 'Public'
ELSE cp.name
END AS CondoComPrivate,
sum(tran_amount/100), sum(ci.power), count(*), (sum(ci.power)/count(*)), sum(tran_amount/100)/sum(ci.power)
from parking_transaction pt
JOIN evcharging evc on pt.transaction_id = evc.id
JOIN car_park cp ON pt.car_park_id = cp.id
JOIN cp_indent ci on evc.order_id = ci.session_id
-- WHERE pt.car_park_id in (select id from car_park where car_park_operator_id = 3)
and convert_tz(exit_date_time, '+00:00', '+08:00') >= '2025-01-01 00:00:00' and convert_tz(exit_date_time, '+00:00', '+08:00') <= '2025-12-31 23:59:59'
and pt.payment_status = 1
group by CondoComPrivate
order by sum(ci.power) desc

-- ========================================================== EVOne Chargers by Carpark Name ==========================================================
-- $1,120,851 (EVOne)
-- 1,626,326 (All)
select cp.name, sum(tran_amount/100), sum(ci.power), count(*), (sum(ci.power)/count(*)), sum(tran_amount/100)/sum(ci.power)
from parking_transaction pt
JOIN evcharging evc on pt.transaction_id = evc.id
JOIN car_park cp ON pt.car_park_id = cp.id
JOIN cp_indent ci on evc.order_id = ci.session_id
WHERE pt.car_park_id in (select id from car_park where car_park_operator_id = 3)
and convert_tz(exit_date_time, '+00:00', '+08:00') >= '2025-01-01 00:00:00' and convert_tz(exit_date_time, '+00:00', '+08:00') <= '2025-12-31 23:59:59'
and pt.payment_status = 1
group by cp.name
order by sum(ci.power) desc



