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
 DROP TABLE DimAgent;
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
  ZipCode NVARCHAR(10) NOT NULL,
  StartDate	 DATETIME NOT NULL,
  EndDate  DATETIME NULL
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
  City    NVARCHAR(30) NOT NULL,
  State   NVARCHAR(25) NOT NULL,
  ZipCode NVARCHAR(10) NOT NULL
 );
--
CREATE TABLE DimDate
	(Date_SK				INT PRIMARY KEY, 
	Date				DATE,
	FullDate			NCHAR(10),-- Date in MM-dd-yyyy format
	DayOfMonth			INT, -- Field will hold day number of Month
	DayName				NVARCHAR(9), -- Contains name of the day, Sunday, Monday 
	DayOfWeek			INT,-- First Day Sunday=1 and Saturday=7
	DayOfWeekInMonth	INT, -- 1st Monday or 2nd Monday in Month
	DayOfWeekInYear		INT,
	DayOfQuarter		INT,
	DayOfYear			INT,
	WeekOfMonth			INT,-- Week Number of Month 
	WeekOfQuarter		INT, -- Week Number of the Quarter
	WeekOfYear			INT,-- Week Number of the Year
	Month				INT, -- Number of the Month 1 to 12{}
	MonthName			NVARCHAR(9),-- January, February etc
	MonthOfQuarter		INT,-- Month Number belongs to Quarter
	Quarter				NCHAR(2),
	QuarterName			NVARCHAR(9),-- First,Second..
	Year				INT,-- Year value of Date stored in Row
	YearName			CHAR(7), -- CY 2017,CY 2018
	MonthYear			CHAR(10), -- Jan-2018,Feb-2018
	MMYYYY				INT,
	FirstDayOfMonth		DATE,
	LastDayOfMonth		DATE,
	FirstDayOfQuarter	DATE,
	LastDayOfQuarter	DATE,
	FirstDayOfYear		DATE,
	LastDayOfYear		DATE,
	IsHoliday			BIT,-- Flag 1=National Holiday, 0-No National Holiday
	IsWeekday			BIT,-- 0=Week End ,1=Week Day
	Holiday				NVARCHAR(50),--Name of Holiday in US
	Season				NVARCHAR(10)--Name of Season
	);
--
CREATE TABLE DimAgent
 (Agent_SK   INT NOT NULL IDENTITY(1,1) CONSTRAINT pk_agent_sk PRIMARY KEY,
  Agent_AK INT NOT NULL,
  FirstName NVARCHAR(30) NOT NULL,
  LastName  NVARCHAR(30) NOT NULL,
  Title  NVARCHAR(20) NOT NULL,
  HireDate DATETIME NOT NULL,
  LicenseDate DATE NOT NULL,
  LicenseStatus  NVARCHAR(25) NOT NULL,
  StartDate	 DATETIME NOT NULL,
  EndDate  DATETIME NULL
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
