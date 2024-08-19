/* 
Photography Business Analysis: Data Import
Author: Oliverius, Miranda
*/
 

-- create temporary tables for importing source data from CSV files
CREATE TEMPORARY TABLE temp_clients(
    client_id               char(6),
    client_name             varchar(75),
    phone                   char(12),
    email                   varchar(50),
    sign_up_date            date         
);

CREATE TEMPORARY TABLE temp_project_sites(
    site_id                 char(7),
    address                 varchar(47),
    address_2               varchar(47),
    city                    varchar(28),
    state                   char(2),
    zip                     char(5),
    longitude               numeric(8,5),
    latitude                numeric(8,5),
    client_id               char(6)
);

CREATE TEMPORARY TABLE temp_orders(
	order_id                varchar(9),
    order_create_date       timestamp,
    order_status            varchar(15),
    site_id                 char(7)
);

CREATE TEMPORARY TABLE temp_order_tasks(
    site_id                 char(7),
    order_id                varchar(9),
    order_status            varchar(15),
    order_create_date       timestamp,
    task_category           varchar(100),
    task_name               varchar(200),
    task_status             varchar(15),
    task_complete_date      timestamp
);

CREATE TEMPORARY TABLE temp_paid_invoices(
    order_id                varchar(9),
    photo_qty               integer,
    payment_method          varchar(5),
    invoice_date            date,
    payment_date            date,
    amount                  numeric(8,2)
);

CREATE TEMPORARY TABLE temp_unpaid_invoices(
    order_id                varchar(9),
    invoice_date            date,
    photo_qty               integer,
    amount                  numeric(8,2)
);

-- import data from CSV files
COPY temp_clients
FROM 'C:\Users\Public\1_datasets\anonymized_clients.csv'
WITH (FORMAT CSV, HEADER);

COPY temp_project_sites
FROM 'C:\Users\Public\1_datasets\anonymized_project_sites.csv'
WITH (FORMAT CSV, HEADER);

COPY temp_order_tasks
FROM 'C:\Users\Public\1_datasets\order_tasks.csv'
WITH (FORMAT CSV, HEADER);

COPY temp_paid_invoices
FROM 'C:\Users\Public\1_datasets\paid_invoices.csv'
WITH (FORMAT CSV, HEADER);

COPY temp_unpaid_invoices
FROM 'C:\Users\Public\1_datasets\unpaid_invoices.csv'
WITH (FORMAT CSV, HEADER);

COPY temp_order_tasks
FROM 'C:\Users\Public\1_datasets\custom_order_tasks.csv'
WITH (FORMAT CSV, HEADER);

-- copy data from temp_order_tasks to temp_orders
INSERT INTO temp_orders
SELECT order_id, order_create_date, order_status, site_id
FROM temp_order_tasks;

-- copy relevant columns to clients table
INSERT INTO clients
SELECT client_id, client_name, sign_up_date
FROM temp_clients;

-- copy relevant columns to contact_info table
INSERT INTO contact_info
SELECT client_id, phone, email
FROM temp_clients;

-- import distinct rows to project_sites table
INSERT INTO project_sites
SELECT DISTINCT *
FROM temp_project_sites;

-- import distinct rows to orders table
INSERT INTO orders
SELECT DISTINCT *
FROM temp_orders;

-- import relevant columns to order_tasks table
INSERT INTO order_tasks
SELECT order_id, task_category, task_name, task_status, task_complete_date
FROM temp_order_tasks;

-- add status column and values to temp_paid_invoices table
ALTER TABLE temp_paid_invoices
ADD COLUMN status varchar(6);

-- set status to "Paid" for temp_paid_invoices table
UPDATE temp_paid_invoices
SET status = 'Paid';

-- import all columns to invoices table for paid invoices
INSERT INTO invoices
SELECT *
FROM temp_paid_invoices;

-- add status column to temp_unpaid_invoices table
ALTER TABLE temp_unpaid_invoices
ADD COLUMN status varchar(6);

-- set status to "Unpaid" for temp_unpaid_invoices table
UPDATE temp_unpaid_invoices
SET status = 'Unpaid';

-- import reordered columns to invoices table for unpaid invoices
INSERT INTO invoices(order_id, photo_qty, invoice_date, amount, status)
SELECT order_id, photo_qty, invoice_date, amount, status
FROM temp_unpaid_invoices;