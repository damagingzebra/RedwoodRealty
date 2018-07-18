-- RedwoodDM database developed and written by Brian Corcoran and Max Mershon
-- Originally Written: July 2018
-----------------------------------------------------------
--
-- Select Fact and Dim data from Redwood OLTP
--
-- DimAgent
SELECT a.AgentID, a.FirstName, a.LastName, a.Title, a.HireDate, a.LicenseDate, ls.StatusText
FROM Redwood.dbo.CustAgentList AS cal
INNER JOIN Redwood.dbo.Agent AS a
ON a.AgentID = cal.AgentID
INNER JOIN Redwood.dbo.LicenseStatus AS ls
ON ls.LicenseStatusID = a.LicenseStatusID

-- DimProperty
SELECT p.PropertyID, pt.Type, pt.Zone, p.Bedrooms, p.Bathrooms, p.Stories, p.SqFt, p.LotSize, p.YearBuilt, p.City, p.State, p.Zipcode
FROM Redwood.dbo.CustAgentList AS cal
INNER JOIN Redwood.dbo.Listing AS l
ON l.ListingID = cal.ListingID
INNER JOIN Redwood.dbo.Property AS p
ON p.PropertyID = l.PropertyID
INNER JOIN Redwood.dbo.PropertyType AS pt
ON pt.PropertyTypeID = p.PropertyTypeID
WHERE cal.ContactReason = 'Buy'

-- DimCustomer
SELECT c.CustomerID, ct.Description AS Type, c.City, c.State, c.Zipcode
FROM Redwood.dbo.CustAgentList AS cal
INNER JOIN Redwood.dbo.Customer AS c
ON cal.CustomerID = c.CustomerID
INNER JOIN Redwood.dbo.CustomerType AS ct
ON ct.CustomerTypeID = c.CustomerTypeID
WHERE cal.ContactReason = 'Buy'

-- DimDate
-- Provided by Professor Amy

-- FactBid
WITH cte AS
(
	SELECT ListingID, CommissionRate
	FROM Redwood.dbo.CustAgentList
	WHERE ContactReason = 'Sell'
)
	SELECT cal.CustomerID, cal.AgentID AS BidAgentID, l.ListingAgentID, l.PropertyID, cal.ContactDate AS BidDate, l.BeginListDate, cal.BidPrice, l.AskingPrice AS ListingPrice, cte.CommissionRate
	FROM Redwood.dbo.CustAgentList AS cal
	INNER JOIN Redwood.dbo.Listing AS l
	ON l.ListingID = cal.ListingID
	INNER JOIN cte
	on cal.ListingID = cte.ListingID
	WHERE cal.ContactReason = 'Buy'


