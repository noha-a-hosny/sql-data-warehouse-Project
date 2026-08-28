/*
===============================================================================
DDL Script: Create Bronze Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'bronze' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'bronze' Tables
===============================================================================
*/

use master;

create database datawarehouse;
go
create schema Bronze;
go
create schema sliver;
go
create schema Gold;

if OBJECT_ID ('bronze.crm_cust_info','U')IS NOT NULL
   drop TABLE bronze.crm_cust_info;
GO

create table bronze.crm_cust_info
	(
	cst_id int,
	cst_key nvarchar(50) ,
	cst_firstname nvarchar(50),
	cst_lastname nvarchar(50),
	cst_marital_status nvarchar(50),
	cst_gndr nvarchar(50),
	cst_create_date date
    );
GO
if OBJECT_ID ('bronze.crm_prd_info','U')IS NOT NULL
		drop TABLE bronze.crm_prd_info
		create table bronze.crm_prd_info
		(
		prd_id int,
		prd_key nvarchar(50),
		prd_nm nvarchar(50),
		prd_cost nvarchar(50), 
		prd_line nvarchar(50),
		prd_start_dt date,
		prd_end_dt date
		);
GO
if OBJECT_ID ('bronze.crm_sales_details','U')IS NOT NULL
		drop TABLE bronze.crm_sales_details
		create table bronze.crm_sales_details
		(sls_ord_num nvarchar(50),
		sls_prd_key nvarchar(50),
		sls_cust_id int,
		sls_order_dt int,
		sls_ship_dt int,
		sls_due_dt int,
		sls_sales int,
		sls_quantity int,
		sls_price int
		);
GO
if OBJECT_ID ('bronze.erp_CUST_AZ12','U')IS NOT NULL
		drop TABLE bronze.erp_CUST_AZ12
GO
		create table bronze.erp_CUST_AZ12
		(
		CID nvarchar(50),
		BDATE date,
		GEN nvarchar(50)
		);
GO
if OBJECT_ID ('bronze.erp_LOC_A101','U')IS NOT NULL
		drop TABLE bronze.erp_LOC_A101
GO
		create table bronze.erp_LOC_A101
		(
		CID nvarchar(50),
		CNTRY nvarchar(50)
		);
GO
if OBJECT_ID ('bronze.erp_PX_CAT_G1V2','U')IS NOT NULL
		drop TABLE bronze.erp_PX_CAT_G1V2
GO
        Create table bronze.erp_PX_CAT_G1V2
		(
		ID nvarchar(50),
		CAT nvarchar(50),
		SUBCAT nvarchar(50),
		MAINTENANCE nvarchar(50)
		);
GO
  /*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
===============================================================================
*/
CREATE OR ALTER PROCEDURE Bronze.LOAD_BRONZE AS
BEGIN
        Declare @start_time DATETIME,@end_time DATETIME,@start_batch_time DATETIME,@end_batch_time DATETIME
        BEGIN TRY
		SET @start_batch_time = GETDATE();
        PRINT '===============================';
		PRINT 'Loading Bronze Layer';
		PRINT '===============================';

		PRINT '-------------------------------';
		PRINT 'Loading CRM Tables';
		PRINT '-------------------------------';

		SET @start_time= GETDATE();
		Print'>> Truncating Table: bronze.crm_cust_info';
		Truncate table bronze.crm_cust_info;
		Print'>> Inserting Data into: bronze.crm_cust_info';
		Bulk insert bronze.crm_cust_info
		from 'C:\Users\Noha\Downloads\Data_warehouse\crm\cust_info.csv'
		with
		(
		firstrow=2,
		FIELDTERMINATOR=',',
		TABLOCK
		);
		SET @start_time= GETDATE();
		Print '>> Load Duration:'+ cast(datediff(second,@start_time,@end_time)as nvarchar)+'seconds';
		print '----------------'

		SET @start_time= GETDATE();
		Print'>> Truncating Table: bronze.crm_prd_info';
		TRUNCATE TABLE bronze.crm_prd_info;
		Print'>> Inserting Data into: bronze.crm_prd_info';
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\Noha\Downloads\Data_warehouse\crm\prd_info.CSV'
		With 
		(
		firstrow =2,
		FIELDTERMINATOR=',',
		TABLOCK
		);
		SET @start_time= GETDATE();
		Print '>> Load Duration:'+ cast(datediff(second,@start_time,@end_time)as nvarchar)+'seconds';
		print '----------------'

		SET @start_time= GETDATE();
		Print'>> Truncating Table: bronze.crm_sales_details';
		TRUNCATE TABLE bronze.crm_sales_details;
		Print'>> Inserting Data into: crm_sales_details';
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\Noha\Downloads\Data_warehouse\crm\sales_details.csv'
		WITH
		(
		FIRSTROW =2,
		FIELDTERMINATOR=',',
		TABLOCK
		);
		SET @start_time= GETDATE();
		Print '>> Load Duration:'+ cast(datediff(second,@start_time,@end_time)as nvarchar)+'seconds';
		print '----------------'

		PRINT '-------------------------------';
		PRINT 'Loading ERP Tables';
		PRINT '-------------------------------';

		SET @start_time= GETDATE();
		Print'>> Truncating Table: bronze.erp_CUST_AZ12';
		truncate table bronze.erp_CUST_AZ12;
		Print'>> Inserting Data into: bronze.erp_CUST_AZ12';
		Bulk insert bronze.erp_CUST_AZ12
		from 'C:\Users\Noha\Downloads\Data_warehouse\erp\CUST_AZ12.csv'
		with 
		(
		firstrow =2,
		fieldterminator=',',
		tablock
		);
		SET @start_time= GETDATE();
		Print '>> Load Duration:'+ cast(datediff(second,@start_time,@end_time)as nvarchar)+'seconds';
		print '----------------'

		SET @start_time= GETDATE();
		Print'>> Truncating Table: bronze.erp_LOC_A101';
		Truncate table bronze.erp_LOC_A101;
		Print'>> Inserting Data into: bronze.erp_LOC_A101';
		Bulk insert bronze.erp_LOC_A101
		from 'C:\Users\Noha\Downloads\Data_warehouse\erp\LOC_A101.csv'
		with
		(
		firstrow =2,
		FIELDTERMINATOR=',',
		TABLOCK
		);
		SET @start_time= GETDATE();
		Print '>> Load Duration:'+ cast(datediff(second,@start_time,@end_time)as nvarchar)+'seconds';
		print '----------------'

		SET @start_time= GETDATE();
		Print'>> Truncating Table: bronze.erp_PX_CAT_G1V2';
		TRUNCATE TABLE bronze.erp_PX_CAT_G1V2;
		Print'>> Inserting Data into: bronze.erp_PX_CAT_G1V2';
		BULK INSERT bronze.erp_PX_CAT_G1V2
		FROM 'C:\Users\Noha\Downloads\Data_warehouse\erp\PX_CAT_G1V2.CSV'
		WITH
		( FIRSTROW = 2,
		FIELDTERMINATOR=',',
		TABLOCK
        );
		SET @start_time= GETDATE();
		Print '>> Load Duration:'+ cast(datediff(second,@start_time,@end_time)as nvarchar)+'seconds';
		print '----------------'
		SET @end_batch_time= GETDATE();
		PRINT '=========================================='
		PRINT 'Loading Bronze Layer is Completed';
		PRINT '- Load Total Duration :' + cast(datediff(second,@start_batch_time,@end_batch_time) as nvarchar) +'seconds'
        PRINT '=========================================='
		END TRY
		BEGIN CATCH
		
    PRINT '-------------------------------';
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER';
		PRINT '-------------------------------';
		END CATCH

END

EXEC BRONZE.LOAD_BRONZE;

/* Quality check 
1. Check No. Of rows by quary compared with No of rows in the file after excluded the header
Select *  from bronze.crm_cust_info;
2. check the name colums with origin columns of the source
*/
Select *  from bronze.crm_cust_info;
Select *  from bronze.crm_prd_info;
Select *  from bronze.crm_sales_details;
Select *  from bronze.erp_CUST_AZ12;
Select *  from bronze.erp_LOC_A101;
Select *  from bronze.erp_PX_CAT_G1V2;

