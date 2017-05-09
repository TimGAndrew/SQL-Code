/*
Tim Andrew
DBAS 1100-702
Project 2 - Data Migration (DML)
April 18th, 2016


NOTE TO GEOFF:
*OLD* DATABASE USERNAME FOR THIS SCRIPT IS: NW_orig
*NEW* DATABASE USERNAME FOR THIS SCRIPT IS: NW_new
*/
 
--BEGIN SCRIPT:
------------------------------------------------------------------------------------------------------BEGIN DROP SEQUENCE STATEMENTS
-- DROP ALL NORTHWIND SEQUENCES (2)
DROP SEQUENCE CountryID_seq;
DROP SEQUENCE CustomerID_seq;
------------------------------------------------------------------------------------------------------END DROP SEQUENCE STATEMENTS




------------------------------------------------------------------------------------------------------BEGIN CREATE SEQUENCE STATEMENTS
--Create sequence "CountryID_seq" (Used to add NW_new.Country.CountryID Primary Key):
CREATE SEQUENCE CountryID_seq 
  START WITH 1 
  INCREMENT BY 1 
  NOMAXVALUE 
  NOCACHE;
--Create sequence "CustomerID_Seq" (Used to add NW_new.Customers.CustomerID Primary Key):
CREATE SEQUENCE CustomerID_Seq
  START WITH 1 
  INCREMENT BY 1 
  NOMAXVALUE 
  NOCACHE;
------------------------------------------------------------------------------------------------------END CREATE SEQUENCE STATEMENTS




------------------------------------------------------------------------------------------------------BEGIN DATA INSERT STATEMENTS
    --Region Table:
INSERT INTO NW_new.Region (Select * FROM NW_Orig.Region);

    --Territories table:
INSERT INTO NW_new.Territories (Select * FROM NW_Orig.Territories);

    --Shippers Table:
INSERT INTO NW_new.Shippers (Select * FROM NW_Orig.Shippers);

    --Categories Table:
INSERT INTO NW_new.Categories (Select * FROM NW_Orig.Categories);

    --Warehouse -->Created from Rubric, with random street addresses:
INSERT INTO NW_new.Warehouse VALUES(1, 'Central Warehouse', '123 Main St.');
INSERT INTO NW_new.Warehouse VALUES(2, 'Airport Warehouse', '456 Air St.');
INSERT INTO NW_new.Warehouse VALUES(3, 'Dockside Warehouse', '789 Water St.');

    --Country
INSERT INTO NW_new.Country VALUES(CountryID_seq.NEXTVAL,'Argentina');
INSERT INTO NW_new.Country VALUES(CountryID_seq.NEXTVAL,'Australia');
INSERT INTO NW_new.Country VALUES(CountryID_seq.NEXTVAL,'Austria');
INSERT INTO NW_new.Country VALUES(CountryID_seq.NEXTVAL,'Belgium');
INSERT INTO NW_new.Country VALUES(CountryID_seq.NEXTVAL,'Brazil');
INSERT INTO NW_new.Country VALUES(CountryID_seq.NEXTVAL,'Canada');
INSERT INTO NW_new.Country VALUES(CountryID_seq.NEXTVAL,'Denmark');
INSERT INTO NW_new.Country VALUES(CountryID_seq.NEXTVAL,'Finland');
INSERT INTO NW_new.Country VALUES(CountryID_seq.NEXTVAL,'France');
INSERT INTO NW_new.Country VALUES(CountryID_seq.NEXTVAL,'Germany');
INSERT INTO NW_new.Country VALUES(CountryID_seq.NEXTVAL,'Ireland');
INSERT INTO NW_new.Country VALUES(CountryID_seq.NEXTVAL,'Italy');
INSERT INTO NW_new.Country VALUES(CountryID_seq.NEXTVAL,'Japan');
INSERT INTO NW_new.Country VALUES(CountryID_seq.NEXTVAL,'Mexico');
INSERT INTO NW_new.Country VALUES(CountryID_seq.NEXTVAL,'Netherlands');
INSERT INTO NW_new.Country VALUES(CountryID_seq.NEXTVAL,'Norway');
INSERT INTO NW_new.Country VALUES(CountryID_seq.NEXTVAL,'Poland');
INSERT INTO NW_new.Country VALUES(CountryID_seq.NEXTVAL,'Portugal');
INSERT INTO NW_new.Country VALUES(CountryID_seq.NEXTVAL,'Singapore');
INSERT INTO NW_new.Country VALUES(CountryID_seq.NEXTVAL,'Spain');
INSERT INTO NW_new.Country VALUES(CountryID_seq.NEXTVAL,'Sweden');
INSERT INTO NW_new.Country VALUES(CountryID_seq.NEXTVAL,'Switzerland');
INSERT INTO NW_new.Country VALUES(CountryID_seq.NEXTVAL,'UK');
INSERT INTO NW_new.Country VALUES(CountryID_seq.NEXTVAL,'USA');
INSERT INTO NW_new.Country VALUES(CountryID_seq.NEXTVAL,'Venezuela');
/* P.S: I initially tried to gather Countries dynamically with some variant of:
        SELECT  Country FROM NW_orig.Customers
        UNION
        SELECT Country FROM NW_orig.Employees
        UNION
        SELECT  ShipCountry FROM NW_orig.Orders
        UNION
        SELECT  Country FROM NW_orig.Suppliers
                                                      But it took too long to figure out so i hard coded them from this instead */
/*  I tried to make this work, still no go, i just needed more time that i didnt' have :/
INSERT INTO NW_new.Country (CountryID, CountryName)
SELECT CustomerID_seq.NextVal, (SELECT  Country FROM NW_orig.Customers
        UNION
        SELECT Country FROM NW_orig.Employees
        UNION
        SELECT  ShipCountry FROM NW_orig.Orders
        UNION
        SELECT  Country FROM NW_orig.Suppliers)
FROM NW_orig.Customers,NW_new.Country
WHERE NW_orig.Customers.country = NW_new.Country.CountryName;
*/



    --Employees
INSERT INTO NW_new.Employees (EmployeeID, LastName, FirstName, Title, 
                              TitleOfCourtesy, TOCAndFullName, BirthDate, HireDate,
                              Address, City, Region, PostalCode, HomePhone, Extension,
                              Notes, ReportsTo, CountryID)
SELECT EmployeeID, LastName, FirstName, Title, TitleOfCourtesy, TRIM(TitleOfCourtesy || ' ' || FirstName|| ' ' || LastName) AS "TOCANDFULLNAME",
        BirthDate, HireDate, Address, City,  Region,  PostalCode, HomePhone, Extension,
        Notes, ReportsTo, CountryID
FROM NW_orig.Employees,NW_new.Country
WHERE NW_orig.Employees.country = NW_new.Country.CountryName
ORDER BY EmployeeID ASC;

    --EmployeeTerritories Table:
INSERT INTO NW_new.EmployeeTerritories (Select * FROM NW_Orig.EmployeeTerritories);

    --Suppliers
INSERT INTO NW_new.Suppliers (SupplierID, CompanyName, ContactName, ContactTitle, Address,
                              City, Region, PostalCode, Phone, Fax, HomePage, CountryID)
SELECT SupplierID, CompanyName, ContactName, ContactTitle, Address, City, Region,
        PostalCode, Phone, Fax, HomePage, CountryID
FROM NW_orig.Suppliers,NW_new.Country
WHERE NW_orig.Suppliers.country = NW_new.Country.CountryName
ORDER BY SupplierID ASC;

    --Products
INSERT INTO NW_new.Products (ProductID, ProductName, SupplierID, CategoryID,
                            QuantityPerUnit, UnitPrice, Discontinued)
SELECT ProductID, ProductName, SupplierID, CategoryID, QuantityPerUnit, UnitPrice,
      Discontinued
FROM NW_orig.Products
ORDER BY ProductID ASC;

    --ProductsWarehouse
INSERT INTO NW_new.ProductsWarehouse (WarehouseID, ProductID, UnitsInStock, UnitsOnOrder, ReOrderLevel)
SELECT 1, ProductID, UnitsInStock, UnitsOnOrder, ReOrderLevel FROM NW_Orig.Products;

    --Customers
INSERT INTO NW_new.Customers (CustomerID, CompanyName, CompanyAlphaCode, ContactName,
                              ContactTitle, Address, City, Region, PostalCode, Phone,
                              Fax, CountryID)
SELECT CustomerID_seq.NextVal, CompanyName, CustomerID, ContactName, ContactTitle, Address, City, 
        Region, PostalCode, Phone, Fax, CountryID
FROM NW_orig.Customers,NW_new.Country
WHERE NW_orig.Customers.country = NW_new.Country.CountryName;


    --Orders
INSERT INTO NW_new.Orders (OrderID, CustomerID, EmployeeID, OrderDate, RequiredDate,
                            ShippedDate, ShipVia, Freight, ShipName, ShipAddress,
                           ShipCity, ShipRegion, ShipPostalCode, CountryID)
SELECT OrderID, Customers.CustomerID, EmployeeID, TO_DATE(OrderDate,'MM-DD-YYYY'), 
        TO_DATE(RequiredDate,'MM-DD-YYYY'), TO_DATE(ShippedDate,'MM-DD-YYYY'),
        ShipVia, Freight, ShipName, ShipAddress, ShipCity, ShipRegion, ShipPostalCode,
        Country.CountryID
FROM NW_orig.Orders,NW_new.Country,NW_new.Customers
WHERE NW_orig.Orders.ShipCountry = NW_new.Country.CountryName and NW_orig.Orders.CustomerID = NW_new.Customers.CompanyALphaCode
ORDER BY OrderID ASC;

    --Order_Details Table:
INSERT INTO NW_new.Order_Details (Select * FROM NW_Orig.Order_Details);



------------------------------------------------------------------------------------------------------END DATA INSERT STATEMENTS

--END SCRIPT