-- FY25 Annual Report

-- No. of carparks in 2025 - 145 carparks
-- 145 - 92 = 53 // 46 + 53 = 99 - 1 (testing) 98
select count(distinct(car_park_id)) from parking_transaction where exit_date_time >= '2024-12-31 16:00:00' and exit_date_time <= '2025-12-31 15:59:59'

-- No. of carparks in 2024 - 92 carparks
select count(distinct(car_park_id)) from parking_transaction where exit_date_time >= '2023-12-31 16:00:00' and exit_date_time <= '2024-12-31 15:59:59' 

-- LIST OF CAR PARKS 2025
SELECT * FROM car_park
where id in (select distinct(car_park_id) from parking_transaction
where exit_date_time >= '2024-12-31 16:00:00' and exit_date_time <= '2025-12-31 16:00:00') and sum is not is not null

-- LIST OF CAR PARKS 2025 BUT NOT 2024
SELECT * FROM car_park
where id in (select distinct(car_park_id) from parking_transaction where exit_date_time >= '2024-12-31 16:00:00' and exit_date_time <= '2025-12-31 16:00:00')
AND name not in (SELECT name FROM car_park where id in (select distinct(car_park_id) from parking_transaction where exit_date_time >= '2023-12-31 16:00:00' and exit_date_time <= '2024-12-31 15:59:59'))

-- Transaction amount of newly added carpark order by trans amt
-- 17 carpark tran amount = 0 or testing
SELECT cp.name, SUM(pt.tran_amount) AS total_tran_amount, SUM(pt.payment_amount) AS total_payment_amount
FROM parking_transaction pt
JOIN car_park cp ON pt.car_park_id = cp.id
WHERE pt.car_park_id IN (SELECT id FROM car_park WHERE id IN (SELECT DISTINCT car_park_id FROM parking_transaction WHERE exit_date_time >= '2024-12-31 16:00:00' AND exit_date_time <= '2025-12-31 16:00:00')
AND name NOT IN (SELECT name FROM car_park WHERE id IN (SELECT DISTINCT car_park_id FROM parking_transaction WHERE exit_date_time >= '2023-12-31 16:00:00' AND exit_date_time <= '2024-12-31 15:59:59')))
GROUP BY cp.name ORDER BY total_tran_amount DESC;

select * from parking_transaction limit 1

-- NO OF EV CHARGERS 340
SELECT count(cs.stake_id), cp.name, csa.current_type, cpo.name
FROM cp_stake cs 
JOIN car_park cp on cp.id = cs.stop_id
JOIN cp_stakeapi csa on cs.stake_id = csa.stake_id
JOIN car_park_operator cpo on cs.operator_id = cpo.id
WHERE cs.enable = 0
and cs.production_date >= '2025-01-01'
group by cp.name;

select * from car_park_operator

SELECT COUNT(cs.stake_id) AS stake_count,
       cp.name,
       csa.current_type
FROM cp_stake cs 
JOIN car_park cp ON cp.id = cs.stop_id
JOIN cp_stakeapi csa ON cs.stake_id = csa.stake_id
JOIN car_park_operator cpo ON cs.operator_id = cpo.id
WHERE cs.enable = 0
  AND cs.production_date >= '2025-01-01'
  AND cp.name IN (
      SELECT name
      FROM car_park
      WHERE id IN (
          SELECT DISTINCT car_park_id
          FROM parking_transaction
          WHERE exit_date_time BETWEEN '2024-12-31 16:00:00'
                                   AND '2025-12-31 16:00:00')
      AND name NOT IN (
          SELECT name FROM car_park WHERE id IN (SELECT DISTINCT car_park_idFROM parking_transaction
              WHERE exit_date_time BETWEEN '2023-12-31 16:00:00'
                                       AND '2024-12-31 15:59:59')))
GROUP BY cp.name, csa.current_type;


select * from cp_stakeapi

-- LIST OF EV CHARGERS 
-- Q: If a charger has connector 1 and 2, is it counted as 1 charger or 2 chargers
SELECT cpo.name as operator_name, cp.name as car_park_name, cs.stake_id, csa.connector_id, csa.current_type 
FROM cp_stake cs JOIN car_park cp on cp.id = cs.stop_id
JOIN cp_stakeapi csa on cs.stake_id = csa.stake_id
JOIN car_park_operator cpo on cs.operator_id = cpo.id
WHERE cs.enable = 0 and ;

-- PAYMENT COLLECTED
select * from payment_transaction limit 10

-- EV Charging Tran Amt 1,626,804
select sum(tran_amount) from parking_transaction where exit_date_time >= '2024-12-31 16:00:00'
and exit_date_time <= '2025-12-31 15:59:59'
and payment_status = 1 
and parking_type_id = 5

-- EV Charging Payment Amt 1,276,868 (Exclude corporate Charging)
select sum(payment_amount) from parking_transaction where exit_date_time >= '2024-12-31 16:00:00'
and exit_date_time <= '2025-12-31 16:00:00'
and payment_status = 1 and parking_type_id = 5

-- Smart parking prepaid (corporate charging) $202,357
-- select SUM(quantity*unit_price) from company_invoice_item where invoice_date >= '2025-01-01' and invoice_date <= '2025-12-31' AND type = 'PREPAID'

-- see all prepaid (corporate charging) transactions **ONLY UNTILL 31 OCT 2025
-- select * from company_invoice_item where invoice_date >= '2025-01-01' and invoice_date <= '2026-12-31' AND type = 'PREPAID' order by invoice_date desc

SELECT * FROM parking_transaction where exit_date >= '2024-12-31 16:00:00 and 2025-12-31 15:59:59'

-- EV Charging users that did not pay because corporate charging *Check corporate 
select * from parking_transaction where exit_date_time >= '2024-12-31 16:00:00'
and exit_date_time <= '2025-12-31 16:00:00' and payment_amount < tran_amount
and payment_status = 1 and parking_type_id = 5

-- EV Total Dev power
select * from evcharging where ended_charged_time >= '2025-01-01' and ended_charged_time <= '2025-12-31'

-- $1,688,617
-- select sum(charged_amount) from evcharging where ended_charged_time >= '2025-01-01' and ended_charged_time <= '2025-12-31'

-- EV Charging Tran Amt 1,626,804
select sum(tran_amount) from parking_transaction 
where exit_date_time >= '2024-12-31 16:00:00' and exit_date_time <= '2025-12-31 15:59:59'
and payment_status = 1 
and parking_type_id = 5

-- EV Charging Payment Amt 1,276,868 (Exclude corporate Charging)
select sum(payment_amount) from parking_transaction where exit_date_time >= '2024-12-31 16:00:00'
and exit_date_time <= '2025-12-31 16:00:00'
and payment_status = 1 and parking_type_id = 5

-- Smart Parking Hourly Tran Amt $3,612,036 (excludes season)
-- parking_type_id = 2 (hourly)
select sum(payment_amount) from parking_transaction 
where exit_date_time >= '2024-12-31 16:00:00' and exit_date_time <= '2025-12-31 15:59:59'
and parking_type_id = 2
and payment_status = 1

-- Smart Parking Season $3,196,859
select sum(amount) from season_list 
where start_date >= '2025-01-01' and end_date <= '2025-12-31'
order by end_date asc

-- *** PREPAID $202,357
select sum(quantity*unit_price) from company_invoice_item where type = 'PREPAID' and invoice_date >= '2025-01-01' and invoice_date <= '2025-12-31'
-- select sum(total_amount) from company_invoice where issued_date >= '2025-01-01' and issued_date <= '2025-12-31'

-- Prepaid Transactions type = 'PREPAID' or status = 'UNISSUED'     type = 'SEASON' (status = 'ISSUED')
select * from company_invoice_item where type = 'PREPAID' AND invoice_date >= '2025-01-01' and invoice_date <= '2025-12-31'

-- Smart Parking Performance by Month 
-- Smart Parking – Hourly 
SELECT DATE_FORMAT(exit_date_time, '%Y-%m') AS month, SUM(payment_amount) AS amount, cp.name, pt.payment_method
CASE WHEN payment_method = 2 THEN 'EPS' WHEN payment_method = 3 THEN 'CEPAS (TBD)' WHEN payment_method = 5 THEN 'Pending' WHEN payment_method = 6 THEN 'Stripe' ELSE 'UNKNOWN' END as payment_method_label
FROM parking_transaction pt
JOIN car_park cp on pt.car_park_id = cp.id
WHERE exit_date_time >= '2024-12-31 16:00:00' AND exit_date_time <= '2025-12-31 15:59:59'
AND parking_type_id = 2 AND payment_status = 1
GROUP BY DATE_FORMAT(exit_date_time, '%Y-%m'), cp.name

 -- Smart Parking – Season
SELECT DATE_FORMAT(start_date, '%Y-%m') AS month, SUM(amount) AS amount
FROM season_list
WHERE start_date >= '2025-01-01' AND end_date <= '2025-12-31'
GROUP BY DATE_FORMAT(start_date, '%Y-%m')

-- Smart Parking - Prepaid
SELECT DATE_FORMAT(invoice_date, '%Y-%m') AS month, SUM(quantity * unit_price) AS amount
FROM company_invoice_item
WHERE type = 'PREPAID'
AND invoice_date BETWEEN '2025-01-01' AND '2025-12-31'
GROUP BY DATE_FORMAT(invoice_date, '%Y-%m')

-- Payment Methods Hourly
SELECT sum(tran_amount/100),
CASE WHEN payment_method = 2 THEN 'EPS' WHEN payment_method = 3 THEN 'CEPAS (TBD)' WHEN payment_method = 5 THEN 'Pending' WHEN payment_method = 6 THEN 'Stripe' WHEN payment_method = 10 THEN 'Prepaid' ELSE 'UNKNOWN' END as payment_method_label
FROM parking_transaction pt
WHERE exit_date_time >= '2024-12-31 16:00:00' AND exit_date_time <= '2025-12-31 15:59:59'
AND payment_status = 1
AND parking_type_id = 2
and payment_method != 1
GROUP BY payment_method


-- 'Stripe' 'InvoicePayment' 'Shared Season' 'Temporary CoV'
select distinct(payment_type) from season_list

-- Payment type for season_list 
-- InvoicePayment 281,475 
-- Strip 2,915,384
select payment_type, sum(amount) from season_list 
WHERE start_date >= '2025-01-01' AND end_date <= '2025-12-31'
group by payment_type

SELECT DATE_FORMAT(start_date, '%Y-%m') AS month, SUM(amount) AS amount
FROM season_list

-- payment  method season
SELECT payment_type, SUM(amount/100) AS amount
FROM season_list
WHERE start_date >= '2025-01-01' AND end_date <= '2025-12-31'
GROUP BY payment_type

select * from payment_type

-- EV Charging Tran Amt 1,626,804
select count(*), DATE_FORMAT(exit_date_time, '%Y-%m')
from parking_transaction 
where exit_date_time >= '2024-12-31 16:00:00' and exit_date_time <= '2025-12-31 15:59:59'
and payment_status = 1
and parking_type_id = 5
group by DATE_FORMAT(exit_date_time, '%Y-%m')

select * from parking_transaction limit 1
JOIN cp_indent ci on evc.order_id = ci.session_id

select * from cp_indent where power is not null

JOIN car_park cp ON pt.car_park_id = cp.id
JOIN car_park_operator cpot on cpot.id = cp.car_park_operator_id
JOIN evcharging evc on pt.transaction_id = evc.id
JOIN cp_indent ci on evc.order_id = ci.session_id

-- Average Transacted Price by month
select (SUM(pt.tran_amount)/(count(*))), DATE_FORMAT(pt.exit_date_time, '%Y-%m')
from parking_transaction pt
JOIN car_park cp ON pt.car_park_id = cp.id
JOIN car_park_operator cpot on cpot.id = cp.car_park_operator_id
JOIN evcharging evc on pt.transaction_id = evc.id
JOIN cp_indent ci on evc.order_id = ci.session_id
where exit_date_time >= '2024-12-31 16:00:00' and exit_date_time <= '2025-12-31 15:59:59'
and payment_status = 1
and parking_type_id = 5
group by DATE_FORMAT(exit_date_time, '%Y-%m')

-- Average Charge Price by month
select (SUM(pt.tran_amount)/SUM(ci.power)), DATE_FORMAT(pt.exit_date_time, '%Y-%m')
from parking_transaction pt
JOIN car_park cp ON pt.car_park_id = cp.id
JOIN car_park_operator cpot on cpot.id = cp.car_park_operator_id
JOIN evcharging evc on pt.transaction_id = evc.id
JOIN cp_indent ci on evc.order_id = ci.session_id
where exit_date_time >= '2024-12-31 16:00:00' and exit_date_time <= '2025-12-31 15:59:59'
and payment_status = 1
and parking_type_id = 5
group by DATE_FORMAT(exit_date_time, '%Y-%m')

--
SELECT
    SUM(pt.tran_amount) / SUM(ci.power) AS amount_per_power,
    DATE_FORMAT(pt.exit_date_time, '%Y-%m') AS month
FROM parking_transaction pt
JOIN car_park cp ON pt.car_park_id = cp.id
JOIN car_park_operator cpot ON cpot.id = cp.car_park_operator_id
JOIN evcharging evc ON pt.transaction_id = evc.id
JOIN cp_indent ci ON evc.order_id = ci.session_id
WHERE pt.exit_date_time BETWEEN '2024-12-31 16:00:00'
                             AND '2025-12-31 15:59:59'
  AND pt.payment_status = 1
  AND pt.parking_type_id = 5
GROUP BY DATE_FORMAT(pt.exit_date_time, '%Y-%m');

-- Payment by Region
select cp.name, cp.longitude, cp.latitude
FROM parking_transaction pt
JOIN car_park cp ON pt.car_park_id = cp.id

-- Payment by Region
select cp.name, sum(pt.tran_amount), cp.longitude, cp.latitude
from parking_transaction pt
JOIN car_park cp ON pt.car_park_id = cp.id
where exit_date_time >= '2024-12-31 16:00:00' and exit_date_time <= '2025-12-31 15:59:59'
and payment_status = 1
and parking_type_id = 5
group by cp.name

-- ***CHECK THIS AGAIN
-- Transaction amount of newly added carpark order by trans amt
-- 17 carpark tran amount = 0 or testing
SELECT cp.name, SUM(pt.tran_amount) AS total_tran_amount, SUM(pt.payment_amount) AS total_payment_amount
FROM parking_transaction pt
JOIN car_park cp ON pt.car_park_id = cp.id
WHERE pt.car_park_id IN (SELECT id FROM car_park WHERE id IN (SELECT DISTINCT car_park_id FROM parking_transaction WHERE exit_date_time >= '2024-12-31 16:00:00' AND exit_date_time <= '2025-12-31 16:00:00')
AND name NOT IN (SELECT name FROM car_park WHERE id IN (SELECT DISTINCT car_park_id FROM parking_transaction WHERE exit_date_time >= '2023-12-31 16:00:00' AND exit_date_time <= '2024-12-31 15:59:59')))
GROUP BY cp.name ORDER BY total_tran_amount DESC;

-- Payment by Region
SELECT CASE
WHEN cp.name = '(Private) Kovan Residences' THEN 'North-East'
WHEN cp.name = 'AIA Tower' THEN 'Central'
WHEN cp.latitude >= 1.40 THEN 'North'
WHEN cp.longitude >= 103.88 AND cp.latitude >= 1.34 THEN 'North-East'
WHEN cp.longitude >= 103.90 AND cp.latitude < 1.34 THEN 'East'
WHEN cp.longitude < 103.78 THEN 'West'
ELSE 'Central' END AS region,
cp.name, SUM(pt.tran_amount) AS total_tran_amount, cp.longitude, cp.latitude
FROM parking_transaction pt
JOIN car_park cp ON pt.car_park_id = cp.id
WHERE exit_date_time >= '2024-12-31 16:00:00' AND exit_date_time <= '2025-12-31 15:59:59'
AND payment_status = 1 AND parking_type_id = 5
GROUP BY region
ORDER BY CASE region WHEN 'North' THEN 1 WHEN 'North-East' THEN 2 WHEN 'East' THEN 3 WHEN 'Central' THEN 4
WHEN 'West' THEN 5 ELSE 6 END, total_tran_amount DESC;


select * from parking_transaction limit 1


