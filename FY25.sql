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

-- Smart parking Prepaid $320,830
select SUM(QUANTITY*UNIT_PRICE) from company_invoice_item where invoice_date >= '2025-01-01' and invoice_date <= '2025-12-31' AND status = 'ISSUED'

select sum(total_amount) from company_invoice where issued_date >= '2025-01-01' and issued_date <= '2025-12-31'

-- Prepaid breakdown company_invoice
-- select * from company_invoice where issued_date >= '2025-01-01' and issued_date <= '2025-12-31' ORDER BY issued_date desc
select * from company_invoice_item where invoice_date >= '2025-01-01' and invoice_date <= '2025-12-31' AND status = 'ISSUED' ORDER BY invoice_date desc, company_id

select * from season_list
