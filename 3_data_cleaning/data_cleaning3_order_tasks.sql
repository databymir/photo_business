/* 
Photography Business Analysis: Data Cleaning - Order Tasks Table
Author: Oliverius, Miranda
*/
 

/* When reviewing this table, several items were identified for cleaning:
1.	Order tasks that were canceled before they took place
2.	Order tasks that were discounts applied, rather than photography tasks
3.	Order tasks that had inconsistent names
4.	Null values in the task_category field

The cleaning code removes canceled tasks and discounts, updates task names for consistency, and categorizes 
the uncategorized tasks.
*/


-- The first two cleaning tasks are removing canceled tasks and tasks that are actually discounts applied.

-- delete order tasks that were canceled
DELETE FROM order_tasks
WHERE task_status = 'Canceled';

-- delete order tasks that are actually discounts applied
DELETE FROM order_tasks
WHERE task_name LIKE '%Discount%'
OR task_name LIKE '%adjustment%';

/* Next, distinct order tasks are viewed along with the counts for how often they occur in the dataset. 
Based on these results, order tasks are updated with consistent names to aid later analysis.
*/

-- view distinct order tasks and counts
SELECT task_name, COUNT(task_name)
FROM order_tasks
GROUP BY task_name
ORDER BY task_name;

/* The previous query identified the following items for cleaning:
1. Inconsistent names for square footage based packages
2. Inconsistent names for Custom tasks
3. Inconsistent names for 11x17 brochure design fees
4. Inconsistent names for print costs
5. Inconsistent names for drone photos & video packages 
6. Inconsistent names for 20 photo packages
7. Superfluous characters in the 2D Floorplan task name
8. Inconsistent names for virtual staging services
9. Inconsistent names for 8.5x11 brochure design fees
10. Inconsistent names for social media upgrades
11. Inconsistent names for drone photos & exteriors packages
12. Inconsistent names for refresh (30 photo) packages
13. Inconsistent names for trip charges
*/

-- apply consistent naming scheme to square footage based packages
UPDATE order_tasks
SET task_name = 'Unlimited Photos-SqFt Based'
WHERE task_name IN (
    '0 - 1199 SqFt', 
    '1200-2500 SqFt ', 
    '2500-3500 SqFt', 
    '4501-5999 SqFt'
);

-- apply consistent naming scheme to custom tasks
UPDATE order_tasks
SET task_name = 'Custom'
WHERE task_name IN (
    '1 Min video walkthrough with limited anlges and 1 drone angle',
    'Alpine Sky Quick Shots',
    'Interior Portfolio Photography of Home. Woodshop Photo, Group Photo and Exterior Wood Photos',
    'Remodel Photos'
);

-- apply consistent naming scheme to 11x17 brochure design fees
UPDATE order_tasks
SET task_name = '11x17 Design Fee'
WHERE task_name = '11x17 Custom Brochure';

-- apply consistent naming scheme to print costs
UPDATE order_tasks
SET task_name = 'Prints'
WHERE task_name LIKE '%Prints%';

-- apply consistent naming scheme to drone photos & video
UPDATE order_tasks
SET task_name = 'Drone Photos & Video'
WHERE task_name LIKE '%Drone Video and Exteriors'
OR task_name IN (
	'Drone photography with 3 angles and 1 video angle',
	'Drone photos and video.  Still Exterior Photography'
);

-- apply consistent naming scheme to 20 photo packages
UPDATE order_tasks
SET task_name = '20 Photos'
WHERE task_name LIKE '20 Interior Photos%'
OR task_name LIKE '20 Photos%';

-- clean up 2D Floorplan task name with superfluous characters
UPDATE order_tasks
SET task_name = '2D Floorplan'
WHERE task_name LIKE '2D Floorplan%';

-- apply consistent naming scheme to virtual staging services
UPDATE order_tasks
SET task_name = 'Virtual Staging'
WHERE task_name LIKE '%Staging%'
OR task_name LIKE '%Staged%';

-- apply consistent naming scheme to 8.5 x 11 brochure design fees
--- NOTE: Confirmed 8x11 brochures were actually 8.5x11 with business owner
UPDATE order_tasks
SET task_name = '8.5x11 Design Fee'
WHERE task_name LIKE '8.5x11%'
OR task_name LIKE '8x11%';

-- apply consistent naming scheme to social media upgrades
UPDATE order_tasks
SET task_name = 'Social Media Upgrade'
WHERE task_name = 'Delivery Site to Marketing Kit Upgrade';

-- apply consistent naming scheme to drone photos & exteriors
UPDATE order_tasks
SET task_name = 'Drone Photos & Exteriors'
WHERE task_name IN (
    'Drone and Exteriors Only',
    'Drones and Ground Photography ',
    'Exterior Only Daytime Photos',
    'Exteriors, Drone and Neighborhood'
);

-- apply consistent naming scheme to refresh packages that were similar to 30 photo packages per business owner
UPDATE order_tasks
SET task_name = '30 Photos'
WHERE task_name LIKE 'Refresh%';

-- apply consistent naming scheme to trip charges
UPDATE order_tasks
SET task_name = 'Trip Charge'
WHERE task_name ILIKE '%Trip Charge%';

/* Lastly, order tasks without task_category values are viewed and each of the uncategorized tasks is assigned a 
task_category.
*/

-- view existing task_category values for reference
SELECT DISTINCT task_category
FROM order_tasks
ORDER BY task_category;

-- view order tasks with no task_category value
SELECT DISTINCT task_name 
FROM order_tasks
WHERE task_category IS NULL
ORDER BY task_name;

-- assign categories to tasks
UPDATE order_tasks
SET task_category = CASE 
    WHEN task_name = '11x17 Design Fee' THEN 'Prints and Design'
    WHEN task_name = '20 Photos' THEN 'Residential Photography'
    WHEN task_name = '30 Photos' THEN 'Residential Photography'
    WHEN task_name = '8.5x11 Design Fee' THEN 'Prints and Design'
    WHEN task_name = 'Custom' THEN 'Custom'
    WHEN task_name = 'Drone Photos & Exteriors' THEN 'Drone'
    WHEN task_name = 'Drone Photos & Video' THEN 'Drone'
    WHEN task_name = 'Interior Only Photos' THEN 'Residential Photography'
    WHEN task_name = 'Prints' THEN 'Prints and Design'
	WHEN task_name = 'Rush Editing' THEN 'Rush & Holiday Fees'
	WHEN task_name = 'Social Reel' THEN 'Video'
    WHEN task_name = 'Trip Charge' THEN 'Trip Charge'
    WHEN task_name = 'Virtual Staging' THEN 'Virtual Staging'
	ELSE task_category
END;