/* 
Photography Business Analysis: Database Creation
Author: Oliverius, Miranda
*/
 

-- create database
CREATE DATABASE photo_business;

-- create table: clients
CREATE TABLE clients(
    client_id               char(6) CONSTRAINT client_key PRIMARY KEY,
    client_name             varchar(75) NOT NULL,
    sign_up_date            date NOT NULL
);

-- create table: contact_info
CREATE TABLE contact_info(
    client_id               char(6) REFERENCES clients(client_id),
    phone                   char(12),
    email                   varchar(50) NOT NULL
);

-- create table: project_sites
CREATE TABLE project_sites(
    site_id                 char(7) CONSTRAINT site_key PRIMARY KEY,
    address                 varchar(47) NOT NULL,
    address_2               varchar(47),
    city                    varchar(28) NOT NULL,
    state                   char(2) NOT NULL,
    zip                     char(5) NOT NULL,
    longitude               numeric(8,5),
    latitude                numeric(8,5),
    client_id               char(6) REFERENCES clients(client_id)
);

-- create table: orders
CREATE TABLE orders(
    order_id                varchar(9) CONSTRAINT order_key PRIMARY KEY,
    order_create_date       timestamp,
    order_status            varchar(15),
    site_id                 char(7) REFERENCES project_sites(site_id) ON DELETE CASCADE
);

-- create table: order_tasks
CREATE TABLE order_tasks(
    order_id                varchar(9) REFERENCES orders(order_id) ON DELETE CASCADE,
    task_category           varchar(100),
    task_name               varchar(200),
    task_status             varchar(15),
    task_complete_date      timestamp
);

-- create table: invoices
CREATE TABLE invoices(
    order_id                varchar(9) REFERENCES orders(order_id),
    photo_qty               integer,
    payment_method          varchar(5),
    invoice_date            date NOT NULL,
    payment_date            date,
    amount                  numeric(8,2) NOT NULL,
    status                  varchar(6) NOT NULL
);