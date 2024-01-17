SELECT * FROM Sales.Customer
SELECT * FROM Person.Person
SELECT * FROM HumanResources.EmployeePayHistory
------ 
SELECT * FROM Person.Person
SELECT * FROM Production.Product
SELECT * FROM Sales.SalesOrderDetail

--------------------------------------SubQuery ---------------------------------------

SELECT FirstName, MiddleName,LastName, (SELECT  CAST(AVG(UnitPrice) AS decimal(10,2)) FROM Sales.SalesOrderDetail) AS AvgUnitPrice
FROM Person.Person
WHERE MiddleName IS NOT null

--------------------------------- Partition can be used instead of SubQuery-------------------------------------------

SELECT BusinessEntityID, Rate, COUNT(BusinessEntityID) OVER () AS SumRate FROM HumanResources.EmployeePayHistory

------------------------------------
SELECT Name, ProductNumber, ReorderPoint FROM Production.Product
WHERE ProductID in (
	SELECT ProductID
	FROM Sales.SalesOrderDetail
	WHERE UnitPrice > 700)
	----------------------------------- with all aggregate function group should be used. Multiple Aggregates---------------------------------------
	SELECT  AVG(EmailPromotion) AS EmailPromotion, COUNT(BusinessEntityID) AS BusinessID FROM Person.Person
	WHERE MiddleName IS NOT NULL
	------------------------ DISTINCT Aggregates function-----------------

	SELECT COUNT(DISTINCT Rate) FROM HumanResources.EmployeePayHistory
	WHERE BusinessEntityID = 4  

	------------------------------AVG of 
	SELECT  avg(SafetyStockLevel) as AVG_stock, p.ProductID, p.Name
	FROM Production.Product as p, Sales.SalesOrderDetail as s
	WHERE p.ProductID = s.ProductID
	AND SafetyStockLevel > 100
	GROUP BY p.ProductID, P.Name
	HAVING SafetyStockLevel > 10

	---------------------------------------------Date Function--------------
	SELECT * FROM Sales.SalesOrderDetail
	SELECT DATENAME(WEEKDAY, ModifiedDate) AS Day FROM Sales.SalesOrderDetail
	SELECT DATENAME(MONTH, ModifiedDate) AS Month FROM Sales.SalesOrderDetail
	-----------------------------------------------------------------------------------------
	SELECT SalesOrderID,OrderQty, ProductID, CarrierTrackingNumber FROM Sales.SalesOrderDetail
	WHERE CarrierTrackingNumber = '4911-403C-98'
	ORDER BY ProductID DESC, SalesOrderID

	------------------------- limit Clause DID NOT WORK
	SELECT FirstName, LastName, MiddleName FROM PERSON.Person
	WHERE MiddleName like 'A'
	ORDER BY FirstName DESC
	LIMIT 10
	------------------------------ NESTING Clause-----------------------------

	SELECT Name FROM Production.Product WHERE ProductID IN(
	SELECT SalesOrderDetailID FROM Sales.SalesOrderDetail
	WHERE OrderQty = '1')