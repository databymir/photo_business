# Photography Business Analysis
**This project seeks to create a relational database for a real estate photography business and utilize this database to gather business intelligence insights. Prior to the creation of this database, the business' data was only accessible through a set of reports from the online platform used to book appointments and deliver files (hereafter referred to as the “client portal”). This system is not intended for business analytics, preventing the owner from answering questions about business performance or leveraging data analytics insights to improve business processes. The creation of a relational database will provide the platform for answering business questions and making data-driven decisions.**
* Designed a relational database with constraints for a real estate photography business using PostgreSQL and pgAdmin 
* Leveraged Python to anonymize Personally Identifiable Information (PII) using the Faker and Pandas packages
* Imported business data utilizing temporary tables to facilitate preliminary data preprocessing
* Utilized SQL queries for data cleaning and analysis, showcasing a variety of SQL features such as subqueries, joins, aggregation, casting, aliasing, ordering, grouping, and case statements
* Connected PostgreSQL database to Tableau
* Leveraged custom calculated fields, Level of Detail (LOD) calculations, table calculations, and custom parameters for an interactive and insightful end-user experience
* Utilized custom parameters and calculated fields to make it so that the granularity of a KPI line graph would change based on the selection of a relative date range (For example, "Last Year" displays a line graph by quarter, whereas "Last 90 Days" displays a line graph by month)
* Created an interactive dashboard to communicate KPIs and suggest follow-up opportunities with clients who have only booked one photoshoot
* Crafted a Tableau story to communicate key insights and introduce the new sales dashboard to the business owner

Note:   The HTML rendering of the summary notebook can be viewed [here](insert-link-here),  
        the Tableau dashboard can be viewed [here](https://public.tableau.com/app/profile/miranda.oliverius/viz/PhotographyBusinessDashboardStory/Dashboard),  
        and the Tableau story can be viewed [here](https://public.tableau.com/app/profile/miranda.oliverius/viz/PhotographyBusinessDashboardStory/Story).

## Table of Contents
* [Authors](#authors)
* [Installation](#installation)
* [Data](#data)
* [Code](#code)
* [License](#license)

## Authors 
[@databymir] (https://github.com/databymir)

## Installation
### Codes and Resources Used
* Python Version: 3.12.3
* Jupyter Notebook Version: 7.0.6
* pgAdmin Version: 8.7
* PostgreSQL Version: 16.3

### Python Packages Used
#### Data Manipulation
* NumPy Version: 1.26.2
* Pandas Version: 2.1.4

#### Data Anonymization
* Faker Version: 26.0.0

## Data
### Database Creation
This portion of the project seeks to create a relational database using PostgreSQL and pgAdmin. The file “database_creation.sql” contains the SQL code utilized to create the database and "data_dictionary.pdf" details the tables, fields, descriptions, data types, and constraints utilized in the initial database creation process. Lastly, "erd.png" is the Entity-Relationship Diagram (ERD) providing a graphical representation of the database.

### PII Anonymization
For the purposes of publishing this project, Personally Identifiable Information (PII) must be anonymized. The original source data will not be published on public platforms, but the code in "anonymizer.ipynb" allows insight into the process utilized for anonymization. After completing this process, the anonymized data will be included with the other dataset files.

### Source Data
Six CSV files will be imported to populate the database with data from the business’ inception through July 31, 2024. These sources are described below, while "data_import_mapping.pdf" summarizes the database tables and fields that each column of source data is imported to.

1. Client Portal exported data
    - Five of the six CSV files were exported from the business’ client portal:
        * anonymized_clients.csv
        * anonymized_project_sites.csv
        * order_tasks.csv
        * paid_invoices.csv
        * unpaid_invoices.csv
    - Those with “anonymized” indicated in the file name were anonymized to protect PII using the anonymization process from the “anonymization.ipynb” file.
2. Manually generated data
    - One of the six CSV files was manually generated as part of this project: 
        * custom_order_tasks.csv
    - Upon exporting the five Client Portal reports, I determined that a small number of orders were generated as “site-only” projects by the business owner. These projects are predominantly custom projects for commercial clients and the owner was creating them in an expedited process that does not mirror the usual ordering process. 
    - In the client portal, this generates invoice data but does not create any order tasks or a typical order ID. 
    - All such projects have been marked with an order ID that starts with “S-”.
    - To create order tasks for these projects, project information was manually entered into the file “custom_order_tasks.csv.” The fields are the same as the Order Tasks report from the portal, but "Custom” is entered as the task category and task name.

### Data Preprocessing and Data Import
This portion of the project seeks to import the business’ data into the newly created database. Due to the limitations of the business’ client portal, the source data is not ready to be directly imported into the database and a series of temporary tables are utilized to facilitate the import process.

First, some of the CSV files contain information for multiple tables or have columns in a different order than the destination tables. Temporary tables provide a method for properly directing the data from each source to the correct fields in the destination table(s). 

Second, the client portal lacks reports listing the project sites and orders as unique records. The project sites report lists sites more than once if multiple orders have been created for a project site. Similarly, the order tasks report lists orders more than once if multiple order tasks are associated with an order. Temporary tables provide a method for isolating distinct records before inserting the data into the destination tables.

The file “data_import.sql” contains the SQL code utilized to import the data and the “Data Source” section below demonstrates how the source data’s columns are related to the SQL database’s tables and fields.

### Data Cleaning
This portion of the project seeks to clean the imported data in preparation for data analysis. 

All database tables were reviewed, identifying four tables that require cleaning:
1.	Project Sites   “data_cleaning1_project_sites.sql”
2.	Orders          “data_cleaning2_orders.sql”
3.	Order Tasks     “data_cleaning3_order_tasks.sql”
4.	Invoices        “data_cleaning4_invoices.sql”

### Data Analysis: SQL
This portion of the project seeks to utilize SQL queries to answer business questions and provide meaningful information for decision-making and analysis. 

The “analysis_queries.sql” file contains the SQL code for the following fifteen queries and the "analysis_results.xlsx" file contains the results of each query:
1.	How many project sites did we shoot during 2023 (Full Year) vs. 2024 (YTD)?
2.	How many orders have been submitted each month?
3.	What is the average order value?
4.	What is the average number of photos delivered per order?
5.	What are the top 5 most common task categories (with ties)?
6.	What are top 10 most commonly ordered services (with ties)?
7.	What are the 3 most frequent cities for our clients photoshoots (with ties)?
8.	What are the 3 least frequent cities for our clients' photoshoots (with ties)?
9.	What is the maximum number of project sites visited in a single day?
10.	What is the maximum number of cities visited in a single day?
11.	Who are our top 5 clients (based on total number of orders)?
12.	Who are our top 5 clients (based on gross sales)?
13.	For clients who have only booked one photoshoot, who has booked during 2024 and might return for future photoshoots if we reach out?
14.	What is the average number of days between invoice creation and payment (overall)?
15.	What is the average number of days between invoice creation and payment (by client)?

### Data Analysis: Tableau
This portion of the project seeks to utilize Tableau to create an interactive sales dashboard and Tableau story to present analytical insights to the business owner. The public version of this Tableau file utilizes anonymized names and the data through 7/31/2024. As a result, all date parameters for things such as "Last Year" utilize a hard-coded 7/31/2024 date for the "current" date. The "tableau_dashboard_and_story.twbx" file contains the entire Tableau workbook, packaged with the source data.

## Code
├── photo_business_analysis_sql_insights.ipynb

├── 1_datasets

├────── anonymized_clients.csv

├────── anonymized_project_sites.csv

├────── custom_order_tasks.csv

├────── order_tasks.csv

├────── paid_invoices.csv

├────── unpaid_invoices.csv

├── 2_database_creation_and_import

├────── anonymizer.ipynb

├────── data_dictionary.pdf

├────── erd.png

├────── database_creation.sql

├────── data_import_mapping.pdf

├────── data_import.sql

├── 3_data_cleaning

├────── data_cleaning1_project_sites.sql

├────── data_cleaning2_orders.sql

├────── data_cleaning3_order_tasks.sql

├────── data_cleaning4_invoices.sql

├── 4_data_analysis

├────── analysis_queries.sql

├────── analysis_results.xlsx

├────── tableau_dashboard_and_story.twbx

├── LICENSE

├── README.md

└── .gitignore

## License
For this github repository, the License used is [MIT License](https://opensource.org/license/mit/)
