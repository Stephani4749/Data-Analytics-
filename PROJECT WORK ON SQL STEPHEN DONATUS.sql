-- calling out the database

Use AdventureWorks2019;

--Retrieve a list of customers and their orders, including CustomerID, CompanyName, 
--OrderDate, and TotalDue

SELECT * FROM Sales.Customer;-- CustomerID
SELECT * FROM sales.SalesOrderHeader;----OrderDate, and TotalDue
SELECT * FROM PERSON.Person;-- company name


SELECT SC.CustomerID,Soh.OrderDate,Soh.TotalDue, CONCAT (PP.FirstName,' ',PP.LastName,' ','.',PP.MiddleName) AS CUSTOMER_NAMES
FROM SALES.Customer AS Sc
INNER JOIN SALES.SalesOrderHeader AS Soh
ON SC.CustomerID = Soh.CustomerID
INNER JOIN PERSON.Person AS pp
ON PP.BusinessEntityID = SC.PersonID
ORDER BY CONCAT (PP.FirstName,PP.LastName,PP.MiddleName);

--Fetch product names and their categories, displaying ProductName, 
--CategoryName, and ListPrice.

SELECT * FROM PRODUCTION.ProductCategory;--categories
SELECT * FROM PRODUCTION.Product;--ProductName, ListPrice
SELECT * FROM PRODUCTION.ProductSubcategory;

SELECT PD.Name,PC.ProductCategoryID,PD.ListPrice
FROM PRODUCTION.Product AS Pd
INNER JOIN PRODUCTION.ProductSubcategory AS Ps
ON Pd.ProductSubcategoryID = Ps.ProductSubcategoryID
INNER JOIN PRODUCTION.ProductCategory AS Pc
ON PC.ProductCategoryID = Ps.ProductCategoryID
ORDER BY PD.ListPrice DESC;

--List all employees and their department names, showing EmployeeID, 
--FullName, and DepartmentName.


SELECT * FROM HumanResources.Department;--department names
SELECT * FROM HumanResources.EmployeeDepartmentHistory;
SELECT * FROM PERSON.Person;
SELECT * FROM HumanResources.Employee;

SELECT HRD.Name,HE.BusinessEntityID AS EMPLOYEEID, CONCAT(PP.FIRSTNAME,' ',PP.LastName) AS FULL_NAME
FROM HumanResources.Employee AS He
JOIN HumanResources.EmployeeDepartmentHistory AS Hed
ON He.BusinessEntityID =Hed.BusinessEntityID
INNER JOIN HumanResources.Department AS Hrd
ON Hrd.DepartmentID = Hed.DepartmentID
INNER JOIN PERSON.Person AS Pp
ON He.BusinessEntityID = PP.BusinessEntityID
WHERE Hed.EndDate IS NULL
ORDER BY FULL_NAME;

--Get all vendors and their associated purchase orders, including VendorName,
--OrderDate, and TotalDue.

SELECT * FROM Purchasing.PurchaseOrderHeader;
SELECT * FROM PURCHASING.Vendor;

SELECT PV.Name AS VENDOR_NAME, Poh.OrderDate, Poh.TotalDue
FROM PURCHASING.Vendor AS Pv
INNER JOIN Purchasing.PurchaseOrderHeader AS Poh
ON PV.BusinessEntityID = Poh.VendorID
ORDER BY Poh.OrderDate DESC;

--Display a list of sales representatives and their sales orders, showing EmployeeID, 
--FullName, SalesOrderID, and TotalDue.

SELECT * FROM SALES.SalesOrderHeader;
SELECT * FROM SALES.SalesPerson;
SELECT * FROM PERSON.Person;

SELECT CONCAT (PP.FirstName,' ',PP.LastName) AS FULL_NAME,SAS.SalesOrderID,SAS.TotalDue, 
He.BusinessEntityID AS EMPLOYEEID
FROM PERSON.Person AS PP
INNER JOIN SALES.SalesPerson AS Sp
ON PP.BusinessEntityID = SP.BusinessEntityID
INNER JOIN SALES.SalesOrderHeader AS SAS
ON SP.BusinessEntityID = SAS.SalesPersonID
INNER JOIN HumanResources.Employee AS He
ON PP.BusinessEntityID = He.BusinessEntityID
ORDER BY SAS.TotalDue DESC;

--Retrieve the top 5 customers who placed the most orders, 
--including CustomerID and OrderCount.

SELECT * FROM SALES.SalesOrderHeader;

SELECT TOP 5 
    CustomerID, 
    COUNT(SalesOrderID) AS Order_Count
FROM Sales.SalesOrderHeader as Soh
GROUP BY CustomerID
ORDER BY Order_Count DESC;

--  Get all employees along with their managers' names

SELECT * FROM HumanResources.Employee;
SELECT * FROM HumanResources.EmployeeDepartmentHistory;
SELECT * FROM PERSON.Person;
SELECT * FROM HUMANRESOURCES.Department;


SELECT  DISTINCT( CONCAT (PP.FirstName,' ',PP.LastName)) AS FULL_NAME, HE.JobTitle
FROM HumanResources.Employee AS He
INNER JOIN HumanResources.EmployeeDepartmentHistory AS Heh
ON HE.BusinessEntityID = Heh.BusinessEntityID
INNER JOIN HUMANRESOURCES.Department AS Hrd
ON HRD.DepartmentID = HEH.DepartmentID
LEFT JOIN HumanResources.Employee 
ON HEH.BusinessEntityID =He.BusinessEntityID
LEFT JOIN PERSON.Person AS PP 
ON PP.BusinessEntityID = HE.BusinessEntityID
WHERE HEH.EndDate IS NULL AND HE.JobTitle LIKE '%MANAGER%'
ORDER BY FULL_NAME ASC;

--Display a list of products that have been ordered, showing ProductID, ProductName, 
--and TotalQuantityOrdered.

SELECT * FROM PRODUCTION.Product;
SELECT * FROM SALES.SalesOrderDetail;
 
 SELECT PROP.ProductID, PROP.Name AS PRODUCT_NAME, SAS.OrderQty AS TOTAL_QUANTIY_ORDERED
 FROM PRODUCTION.Product AS PROP
 INNER JOIN SALES.SalesOrderDetail AS SAS
 ON PROP.ProductID = SAS.ProductID
 ORDER BY TOTAL_QUANTIY_ORDERED DESC;
 
 SELECT PROP.ProductID, PROP.Name AS PRODUCT_NAME, SUM (SAS.OrderQty) AS TOTAL_QUANTIY_ORDERED
 FROM PRODUCTION.Product AS PROP
 INNER JOIN SALES.SalesOrderDetail AS SAS
 ON PROP.ProductID = SAS.ProductID
 GROUP BY PROP.ProductID,PROP.Name
 ORDER BY TOTAL_QUANTIY_ORDERED DESC;
 
 --List all orders with their shipping addresses, showing SalesOrderID, 
 --ShipToAddress, and City.

 SELECT * FROM  SALES.SalesOrderHeader;
  SELECT * FROM  PERSON.Address;

  SELECT sas.ShipToAddressID, sas.SalesOrderID, pa.City
  FROM sales.SalesOrderHeader as sas
  inner join person.Address Pa
  on sas.BillToAddressID = Pa.AddressID
  order by Pa.City asc;

 --Get the top 10 selling products by total quantity sold

SELECT * FROM sales.SalesOrderDetail;

Select top 10 sas.ProductID, SUM (orderQty) as total_Quantity
from sales.SalesOrderDetail as sas
group by sas.ProductID
order by total_Quantity Desc;

--sub queries based on sales performance analysis using adventureWorks 
--1) Top 5 Best-Selling Products Based on Total Sales Amount

SELECT * FROM SALES.SalesOrderDetail;
--INNER QUERY
SELECT SAS.PRODUCTID,SUM (SAS.LineTotal) AS Total_Sales_Amount
FROM SALES.SalesOrderDetail AS SAS
GROUP BY SAS.ProductID
--OUTER QUERY
SELECT TOP 5 SAS.PRODUCTID
FROM SALES.SalesOrderDetail AS SAS
GROUP BY SAS.ProductID
ORDER BY SAS.ProductID;
-- SUBQUERIES
SELECT TOP 5 PRODUCTID,Total_Sales_Amount
FROM (
	SELECT SAS.PRODUCTID, SUM (SAS.LineTotal) AS Total_Sales_Amount
FROM SALES.SalesOrderDetail AS SAS
GROUP BY SAS.PRODUCTID
) AS TOP_5_BEST_SELLING_PRODUCT
ORDER BY Total_Sales_Amount DESC;
GO

-- 2) Customers Who Purchased More Than the Average Order Quantity

SELECT * FROM SALES.SalesOrderDetail;
--INNER QUERY
SELECT SALESORDERID, AVG (ORDERQTY) AS AVG_ORDERQTY
FROM SALES.SalesOrderDetail AS SAS
GROUP BY SALESORDERID
ORDER BY AVG_ORDERQTY DESC;

-- OUTER QUERY
SELECT SALESORDERID, SUM(ORDERQTY) AS TOTAL_ORDERQTY
FROM SALES.SalesOrderDetail AS SAS
GROUP BY SalesOrderID

SELECT SALESORDERID, SUM(ORDERQTY) AS TOTAL_ORDERQTY
FROM SALES.SalesOrderDetail AS SAS
GROUP BY SalesOrderID
HAVING SUM(ORDERQTY) >
(
SELECT AVG (TOTAL_ORDERQTY)
FROM (SELECT SALESORDERID, SUM(ORDERQTY) AS TOTAL_ORDERQTY
FROM SALES.SalesOrderDetail AS SAS
GROUP BY SALESORDERID 
			) AS SUBQUERY
);
GO
 
 -- 3)  Employees with Above-Average Sales Performance

 SELECT * FROM SALES.SalesOrderHeader;

 --OUTER QUERY
 SELECT SOH.SalesPersonID,  AVG(SOH.TotalDue) AS AVG_TOTAL_SALES
 FROM SALES.SalesOrderHeader  AS SOH
 GROUP BY SOH.SalesPersonID
 ORDER BY AVG_TOTAL_SALES DESC;

 --INNER QUERY
 SELECT SOH.SalesPersonID, SUM (SOH.TotalDue) AS TOTAL_SALES
 FROM SALES.SalesOrderHeader  AS SOH
 GROUP BY SOH.SalesPersonID;
 -- SUBQUERY
 SELECT SOH.SalesPersonID, SUM (SOH.TotalDue) AS TOTAL_SALES
 FROM SALES.SalesOrderHeader  AS SOH
 GROUP BY SOH.SalesPersonID
 HAVING SUM (SOH.TotalDue) > 
 (
 SELECT AVG (TOTAL_SALES)
 FROM ( SELECT
 SOH.SalesPersonID,  SUM(SOH.TotalDue) AS TOTAL_SALES
 FROM SALES.SalesOrderHeader  AS SOH
 GROUP BY SOH.SalesPersonID
 ) AS SUBQUERY
 );

 GO
 -- 4) Territories Where Total Sales Are Above the Average Sales Per Territory

 SELECT * FROM SALES.SalesOrderHeader;
 --OUTER QUERY

 SELECT SOH.TerritoryID, AVG(SOH.TotalDue) AS AVG_TOTAL_SALES
 FROM SALES.SalesOrderHeader AS SOH
 GROUP BY SOH.TerritoryID
 ORDER BY  AVG_TOTAL_SALES DESC;

 --INNER QUERY

 SELECT SOH.TerritoryID, SUM(SOH.TotalDue) AS TOTAL_SALES
 FROM SALES.SalesOrderHeader AS SOH
 GROUP BY SOH.TerritoryID
 ORDER BY TOTAL_SALES;
 --SUBQUERY
  SELECT SOH.TerritoryID, SUM(SOH.TotalDue) AS TOTAL_SALES
 FROM SALES.SalesOrderHeader AS SOH
 GROUP BY SOH.TerritoryID
HAVING SUM(SOH.TotalDue) > 
  ( SELECT AVG(TOTAL_SALES)
  FROM(
SELECT SOH.TerritoryID, SUM(SOH.TotalDue) AS TOTAL_SALES
 FROM SALES.SalesOrderHeader AS SOH
 GROUP BY SOH.TerritoryID) AS SUBQUERY
 );

 --5) Products That Have a Higher Average Selling Price Than the Overall Average

 SELECT * FROM SALES.SalesOrderDetail;

 --OUTER QUERY
 SELECT SAS.ProductID,SAS.UnitPrice
 FROM SALES.SalesOrderDetail AS SAS
 ORDER BY SAS.ProductID;

 --INNER QUERY
 SELECT SAS.ProductID, AVG(SAS.UnitPrice) AS AVG_SELLING_PRICE
 FROM SALES.SalesOrderDetail AS SAS
 GROUP BY SAS.ProductID
 ORDER BY SAS.ProductID DESC;

 --SUBQUERY
 SELECT SAS.ProductID, AVG(SAS.UnitPrice) AS AVG_SELLING_PRICE
FROM SALES.SalesOrderDetail AS SAS
GROUP BY SAS.ProductID
HAVING AVG(UnitPrice) > (
    SELECT AVG(UnitPrice) 
    FROM sales.SalesOrderDetail)
	ORDER BY AVG_SELLING_PRICE DESC;
