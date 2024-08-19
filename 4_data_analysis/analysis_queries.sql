/* 
Photography Business Analysis: Queries
Author: Oliverius, Miranda
*/
 

/* A number of analysis queries will be performed to answer business questions for the business owner. The comment preceding 
each query will contain the question being answered, while a comment following the query will state the answer. For queries 
that result in large tables, the commented results will only include a summary of the findings.

The complete output of each query was exported from pgAdmin and compiled in the Excel 
workbook "analysis_results.xlsx".
*/

-- Query 1 --
-- How many project sites did we shoot during 2023 (Full Year) vs. 2024 (YTD)?
SELECT  EXTRACT('year' from order_create_date) AS year, 
        COUNT(DISTINCT site_id) AS total_orders
FROM orders
GROUP BY year;
-- Answer: We shot 31 properties during 2023, and have shot 78 properties year-to-date (07/31/2024).

-- Query 2 --
-- How many orders have been submitted each month?
SELECT 	EXTRACT('year' FROM order_create_date) AS year,
		EXTRACT('month' FROM order_create_date) AS month,
		COUNT(order_id) AS total_orders
FROM orders
GROUP BY year, month
ORDER BY year, month;
/* Answer: The business owner was still working part-time for his previous employer until mid-way through September 2023, and 
the slow season for real estate tends to be October through March, explaining the low volume of monthly orders from May 2023
through March 2024. April 2024 saw the highest number of orders up to that point (10 orders), but was lower than expected due
to a slow real estate market. Although uncertainty has continued in the market, the next three months averaged 20 orders per
month, doubling the monthly orders from April.
*/

-- Query 3 --
-- What is the average order value?
SELECT ROUND(SUM(amount) / COUNT(DISTINCT order_id), 2) AS avg_order_value
FROM invoices;
-- Answer: $378.57

-- Query 4 --
-- What is the average number of photos delivered per order? 
SELECT ROUND((CAST(SUM(photo_qty) AS numeric) / COUNT(DISTINCT order_id)), 2) AS avg_photos_per_order
FROM invoices;
-- Answer: 70.71 photos/order

-- Query 5 --
-- What are the top 5 most common task categories (with ties)?
SELECT  task_category, 
        COUNT(task_category)
FROM order_tasks
--- 'Dont need a drone' is not a true product, it's used to remove drone photography from residential photography packages
WHERE task_name != 'Dont need a drone?'
GROUP BY task_category
ORDER BY COUNT(task_category) DESC
FETCH NEXT 5 ROWS WITH TIES;
-- Answer: Residential Photography, Video, Custom, Drone, and 2D/3D Floorplans 

-- Query 6 --
-- What are top 10 most commonly ordered services (with ties)?
SELECT  task_name, 
        COUNT(task_name)
FROM order_tasks
--- 'Dont need a drone' is not a true product, it's used to remove drone photography from residential photography packages
WHERE task_name != 'Dont need a drone?'
GROUP BY task_name
ORDER BY COUNT(task_name) DESC
FETCH NEXT 10 ROWS WITH TIES;
/* Answer: 40 Photos, 30 Photos, Custom, 2D Floorplan, Basic HD Video Walk-through, Unlimited Photos-SqFt Based,
Drone Photos & Video, Social Media Upgrade, Twilight Photography, and Drone Photos & Exteriors (tied with 8.5x11 Design Fee)
*/

-- Query 7 --
-- What are the 3 most frequent cities for our clients photoshoots (with ties)?
SELECT  city, 
        COUNT(city)
FROM project_sites
GROUP BY city
ORDER BY COUNT(city) DESC
FETCH NEXT 3 ROWS WITH TIES;
-- Answer: Fort Collins, Greeley, and Loveland (tied with Windsor)

-- Query 8 --
-- What are the 3 least frequent cities for our clients' photoshoots (with ties)?
SELECT  city, 
        COUNT(city)
FROM project_sites
GROUP BY city
ORDER BY COUNT(city)
FETCH NEXT 3 ROWS WITH TIES;
/* Answer: The least frequent cities are all tied with one photoshoot each- Evans, Platteville, Longmont, Timnath, Berthoud, 
Estes Park, and Kersey
*/

-- Query 9 --
-- What is the maximum number of project sites visited in a single day?
SELECT 	CAST(task_complete_date AS date), 
		COUNT(DISTINCT site_id) AS project_sites_visited
FROM order_tasks
JOIN orders
USING(order_id)
JOIN project_sites
USING(site_id)
GROUP BY CAST(task_complete_date AS date)
ORDER BY COUNT(DISTINCT site_id) DESC
FETCH NEXT 1 ROWS WITH TIES;
/* Answer: The maximum number of project sites visited in a single day is four, which happened on 06/09/2024
*/

-- Query 10 --
-- What is the maximum number of cities visited in a single day?
SELECT 	CAST(task_complete_date AS date), 
		COUNT(DISTINCT city) AS cities_visited
FROM order_tasks
JOIN orders
USING(order_id)
JOIN project_sites
USING(site_id)
GROUP BY CAST(task_complete_date AS date)
ORDER BY 	COUNT(DISTINCT city) DESC
FETCH NEXT 1 ROWS WITH TIES;
/* Answer: The maximum number of cities visited in a single day is three, which happened on 05/28/2024.
*/

-- Query 11 --
-- Who are our top 5 clients (based on total number of orders)?
SELECT  client_id, 
        client_name, 
        COUNT(order_id) AS total_orders
FROM clients
JOIN project_sites
USING(client_id)
JOIN orders
USING(site_id)
GROUP BY client_id
ORDER BY COUNT(order_id) DESC
FETCH NEXT 5 ROWS WITH TIES;
-- Answer: Andrew Mitchell, Jessica Ramos, David Hill, Elizabeth Schultz, and David Thompson (tied with Ashley Cantrell)

-- Query 12 --
-- Who are our top 5 clients (based on gross sales)?
SELECT  client_id, 
        client_name, 
        SUM(amount) AS total_sales
FROM clients
JOIN project_sites
USING(client_id)
JOIN orders
USING(site_id)
JOIN invoices
USING(order_id)
GROUP BY client_id
ORDER BY total_sales DESC
FETCH NEXT 5 ROWS WITH TIES;
-- Answer: David Thompson, Elizabeth Schultz, Ashley Cantrell, Jessica Ramos, and Andrew Mitchell

-- Query 13 --
/* For clients who have only booked one photoshoot, who has booked during 2024 and might return for future photoshoots 
if we reach out? 

(Note: We would normally only look back 90 days, but this has been a strange and slow year for real
estate, so looking further back may be worthwhile.)
*/
SELECT 	client_id, 
		client_name, 
		MAX(order_create_date) AS last_order_date
FROM clients
JOIN project_sites
USING(client_id)
JOIN orders
USING(site_id)
GROUP BY client_id
HAVING  COUNT(order_id) = 1 AND
        MAX(order_create_date) > '2023-12-31'
ORDER BY MAX(order_create_date) DESC;
/* Answer: There are six clients who have only booked with us once but tried our services this year. They are Brooke Pearson,
Carlos Vaughn, Michael Aguirre, Debra Austin, Brianna Lawrence, and Ashley Willis.
*/

-- Query 14 --
-- What is the average number of days between invoice creation and payment (overall)?
SELECT ROUND(AVG(payment_date - invoice_date), 2) AS days_outstanding
FROM invoices;
-- Answer: 9.86 days

-- Query 15 -- 
-- What is the average number of days between invoice creation and payment (by client)? 
SELECT 	client_id, 
		client_name, 
		ROUND(AVG(payment_date - invoice_date), 2) AS days_outstanding
FROM invoices
JOIN orders
USING(order_id)
JOIN project_sites
USING(site_id)
JOIN clients
USING(client_id)
GROUP BY client_id, client_name
ORDER BY days_outstanding DESC;
/* Answer: Casey Morris takes the longest to pay, averaging 37.33 days between invoice and payment date.
Meanwhile, Erin Arnold is the quickest to pay, averaging 0.00 days between invoice and payment date.
*/