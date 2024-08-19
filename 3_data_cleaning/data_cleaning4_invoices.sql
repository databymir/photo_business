/* 
Photography Business Analysis: Data Cleaning - Invoices Table
Author: Oliverius, Miranda
*/
 

/* When reviewing this table, there were two order IDs that showed up multiple times. This occurs if an 
adjustment is made to an order after a payment is made. The client portal report includes the total number 
of photos delivered each time that an order number is included in the invoices report. 

This means that the photo quantity is duplicated and will throw off calculations of total photos delivered or 
average photos per order. To remedy this, only one record should include the photo quantity value. 
The cleaning code updates the number of photos so that subsequent records of each order show zero as the
photo_qty
*/


-- view orders that show up multiple times in the invoices table
SELECT *
FROM invoices
WHERE order_id IN (
    SELECT order_id
    FROM invoices
    GROUP BY order_id
    HAVING COUNT(order_id) > 1
)
ORDER BY order_id;

-- update number of photos to be zero for second record of Order #897352 to remove duplicate photo_qty value
UPDATE invoices
SET photo_qty = 0
WHERE order_id = '897352'
AND payment_method = 'Acct';

-- update number of photos to be zero for second record of Order #970467 to remove duplicate photo_qty value
UPDATE invoices
SET photo_qty = 0
WHERE order_id = '970467'
AND payment_method = 'Cash'; 