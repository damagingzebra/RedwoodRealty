-- RedwoodDM database developed and written by Brian Corcoran and Max Mershon
-- Originally Written: July 2018
-----------------------------------------------------------
IF NOT EXISTS(SELECT * FROM sys.databases
 WHERE name = N'RedwoodDM')
 CREATE DATABASE RedwoodDM
GO
USE RedwoodDM

--
-- Delete existing tables
--
IF EXISTS(
 SELECT *
 FROM sys.tables
 WHERE name = N'FactBids'
       )
 DROP TABLE FactBids;
--
IF EXISTS(
 SELECT *
 FROM sys.tables
 WHERE name = N'DimAgent'
       )
 DROP TABLE DimBidAgent;
--
IF EXISTS(
 SELECT *
 FROM sys.tables
 WHERE name = N'DimDate'
       )
 DROP TABLE DimDate;
--
IF EXISTS(
 SELECT *
 FROM sys.tables
 WHERE name = N'DimProperty'
       )
 DROP TABLE DimProperty;
--
IF EXISTS(
 SELECT *
 FROM sys.tables
 WHERE name = N'DimCustomer'
       )
 DROP TABLE DimCustomer;
--
	
--
-- Create tables
--
CREATE TABLE DimCustomer
 (Customer_SK INT NOT NULL IDENTITY(1,1) CONSTRAINT pk_customer_sk PRIMARY KEY,
  Customer_AK INT NOT NULL,
  Type    NVARCHAR(25) NOT NULL,
  City    NVARCHAR(50) NOT NULL,
  State   NVARCHAR(20) NOT NULL,
  ZipCode NVARCHAR(10) NOT NULL
 );
--
CREATE TABLE DimProperty
 (Property_SK  INT NOT NULL IDENTITY(1,1) CONSTRAINT pk_property_sk PRIMARY KEY,
  Property_AK INT NOT NULL,
  Type NVARCHAR(30) NOT NULL,
  Zone NVARCHAR(4) NOT NULL,
  Bedrooms INT NOT NULL,
  Bathrooms INT NOT NULL,
  Stories INT NOT NULL,
  SqFt INT NOT NULL,
  LotSize NUMERIC(4,2) NOT NULL,
  YearBuilt NUMERIC(4) NOT NULL,
  City    NVARCHAR(25) NOT NULL,
  State   NVARCHAR(25) NOT NULL,
  ZipCode NVARCHAR(10) NOT NULL
 );
--
CREATE TABLE DimDate
 (Date_SK   INT NOT NULL CONSTRAINT pk_date_sk PRIMARY KEY,
  Date      Date NOT NULL,
  DateName  NVARCHAR(25) NOT NULL,
  Year      INT NOT NULL,
  YearName  NVARCHAR(25) NOT NULL,
  Quarter   INT NOT NULL,
  QuarterName  NVARCHAR(25) NOT NULL,
  Month     INT NOT NULL,
  MonthName  NVARCHAR(25) NOT NULL
 );
--
CREATE TABLE DimAgent
 (Agent_SK   INT NOT NULL IDENTITY(1,1) CONSTRAINT pk_agent_sk PRIMARY KEY,
  Agent_AK INT NOT NULL,
  FirstName NVARCHAR(30) NOT NULL,
  LastName  NVARCHAR(30) NOT NULL,
  Title  NVARCHAR(20) NOT NULL,
  HireDate DATE NOT NULL,
  LicenseDate DATE NOT NULL,
  LicenseStatus  NVARCHAR(25) NOT NULL
);
--
CREATE TABLE FactBids
 (BidDate INT NOT NULL CONSTRAINT fk_bid_date_sk FOREIGN KEY REFERENCES DimDate(Date_SK),
  BidAgent_SK INT NOT NULL CONSTRAINT fk_bid_agent_sk FOREIGN KEY REFERENCES DimAgent(Agent_SK),
  ListingAgent_SK INT NOT NULL CONSTRAINT fk_listing_agent_sk FOREIGN KEY REFERENCES DimAgent(Agent_SK),
  ListingDate INT NOT NULL CONSTRAINT fk_listing_date_sk FOREIGN KEY REFERENCES DimDate(Date_SK),
  Property_SK INT NOT NULL CONSTRAINT fk_property_sk FOREIGN KEY REFERENCES DimProperty(Property_SK),
  Customer_SK INT NOT NULL CONSTRAINT fk_customer_sk FOREIGN KEY REFERENCES DimCustomer(Customer_SK),
  ListingPrice DECIMAL(10,2) NOT NULL,
  BidPrice DECIMAL(10,2) NOT NULL,
  CommissionRate NUMERIC(4,4) NOT NULL,
  CONSTRAINT pk_FactBids PRIMARY KEY(BidDate, BidAgent_SK, Property_SK, Customer_SK)
 );

GO
