-- RedwoodDM database developed and written by Brian Corcoran and Max Mershon
-- Originally Written: July 2018
-----------------------------------------------------------
--
-- Select Fact and Dim data from Redwood OLTP
--
-- DimAgent
SELECT a.AgentID, a.FirstName, a.LastName, a.Title, a.HireDate, a.LicenseDate, ls.StatusText
FROM Redwood.dbo.CustAgentList AS cal
LEFT OUTER JOIN Redwood.dbo.Agent AS a
ON a.AgentID = cal.AgentID
LEFT OUTER JOIN Redwood.dbo.LicenseStatus AS ls
ON ls.LicenseStatusID = a.LicenseStatusID
GROUP BY a.AgentID, a.FirstName, a.LastName, a.Title, a.HireDate, a.LicenseDate, ls.StatusText


-- DimProperty
SELECT p.PropertyID, pt.Type, pt.Zone, p.Bedrooms, p.Bathrooms, p.Stories, p.SqFt, p.LotSize, p.YearBuilt, p.City, p.State, p.Zipcode
FROM Redwood.dbo.CustAgentList AS cal
LEFT OUTER JOIN Redwood.dbo.Listing AS l
ON l.ListingID = cal.ListingID
LEFT OUTER JOIN Redwood.dbo.Property AS p
ON p.PropertyID = l.PropertyID
LEFT OUTER JOIN Redwood.dbo.PropertyType AS pt
ON pt.PropertyTypeID = p.PropertyTypeID
WHERE cal.ContactReason = 'Buy'
GROUP BY p.PropertyID, pt.Type, pt.Zone, p.Bedrooms, p.Bathrooms, p.Stories, p.SqFt, p.LotSize, p.YearBuilt, p.City, p.State, p.Zipcode


-- DimCustomer
SELECT c.CustomerID, ct.Description AS Type, c.City, c.State, c.Zipcode
FROM Redwood.dbo.CustAgentList AS cal
LEFT OUTER JOIN Redwood.dbo.Customer AS c
ON cal.CustomerID = c.CustomerID
LEFT OUTER JOIN Redwood.dbo.CustomerType AS ct
ON ct.CustomerTypeID = c.CustomerTypeID
WHERE cal.ContactReason = 'Buy'
GROUP BY c.CustomerID, ct.Description, c.City, c.State, c.Zipcode


-- DimDate
-- Provided by Professor Amy

-- FactBid
WITH cte AS
(
	SELECT ListingID, CommissionRate
	FROM Redwood.dbo.CustAgentList
	WHERE ContactReason = 'Sell'
)
	SELECT dc.Customer_SK, da.Agent_SK AS BidAgent_SK, da2.Agent_SK AS ListingAgent_SK, dp.Property_SK, dt.Date_SK AS BidDate, dt2.Date_SK AS ListingDate, cal.BidPrice, l.AskingPrice AS ListingPrice, cte.CommissionRate
	FROM Redwood.dbo.CustAgentList AS cal
	INNER JOIN Redwood.dbo.Listing AS l
	ON l.ListingID = cal.ListingID
	INNER JOIN cte
	ON cal.ListingID = cte.ListingID
	INNER JOIN RedwoodDM.dbo.DimCustomer as dc
	ON dc.Customer_AK = cal.CustomerID
	INNER JOIN RedwoodDM.dbo.DimAgent as da
	ON da.Agent_AK = cal.AgentID
	INNER JOIN RedwoodDM.dbo.DimAgent as da2
	ON da2.Agent_AK = l.ListingAgentID
	INNER JOIN RedwoodDM.dbo.DimProperty as dp
	ON dp.Property_AK = l.PropertyID
	INNER JOIN RedwoodDM.dbo.DimDate AS dt
	ON dt.Date = cal.ContactDate
	INNER JOIN RedwoodDM.dbo.DimDate AS dt2
	ON dt2.Date = l.BeginListDate
	WHERE cal.ContactReason = 'Buy'
