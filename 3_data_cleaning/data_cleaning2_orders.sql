/* 
Photography Business Analysis: Data Cleaning - Orders Table
Author: Oliverius, Miranda
*/
 

/*
When reviewing this table, there were two order IDs in the orders table that are not included in the invoices table. 
These two orders were discussed with the business owner to gain insight:

1.	Order #1166963 was created for twilight photography that the business owner did as an unpaid portfolio project
	- Client paid for the daytime photography, which is captured under a different order number.
2.	Order #840450 was a small one-time client and the  project that occurred while the business owner was beginning to 
implement the client portal system. It ultimately was handled outside of this portal and the data is unavailable. 

The cleaning code removes both records from the orders table before removing the related property addresses from the 
project_sites table.
*/


-- view order IDs that show up in the orders table but not in the invoices table
SELECT o.order_id
FROM orders o
LEFT JOIN invoices i
ON o.order_id = i.order_id
WHERE i.order_id IS NULL
ORDER BY o.order_id;

-- delete Orders #1166963 and #840450 from database, to remove unpaid portfolio project and order with missing data
DELETE FROM orders
WHERE order_id IN (
    SELECT o.order_id
    FROM orders o
    LEFT JOIN invoices i
    ON o.order_id = i.order_id
    WHERE i.order_id IS NULL
);

/* view site IDs that show up in the project_sites table but not the orders table

NOTE: There is only one site, the one that was handled outside of the Client Portal. The other address 
(the twilight portfolio project) still included paid work during the daytime, so the project site is 
valid and remains in the dataset.
*/
SELECT ps.site_id
FROM project_sites ps
LEFT JOIN orders o
ON ps.site_id = o.site_id
WHERE o.site_id IS NULL
ORDER BY ps.site_id;

-- delete project site record that was removed as part of the cleaning process for the orders table
DELETE FROM project_sites
WHERE site_id IN(
	SELECT ps.site_id
	FROM project_sites ps
	LEFT JOIN orders o
	ON ps.site_id = o.site_id
	WHERE o.site_id IS NULL
);