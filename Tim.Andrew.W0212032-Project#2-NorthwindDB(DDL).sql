/*
Tim Andrew
DBAS 1100-702
Project 2 - Data Migration (DDL)
April 18th, 2016


NOTE TO GEOFF:
*OLD* DATABASE USERNAME FOR THIS SCRIPT IS: NW_orig
*NEW* DATABASE USERNAME FOR THIS SCRIPT IS: NW_new
*/
 
--BEGIN SCRIPT:

------------------------------------------------------------------------------------------------------BEGIN TABLE DROP STATEMENTS
-- Drop all Northwind tables (14)
  DROP TABLE ORDER_DETAILS PURGE;
  DROP TABLE ORDERS PURGE;
  DROP TABLE PRODUCTSWAREHOUSE PURGE;
  DROP TABLE WAREHOUSE PURGE;
  DROP TABLE PRODUCTS PURGE;
  DROP TABLE SUPPLIERS PURGE;
  DROP TABLE CATEGORIES PURGE;
  DROP TABLE CUSTOMERS PURGE;
  DROP TABLE EMPLOYEETERRITORIES PURGE;
  DROP TABLE TERRITORIES PURGE;
  DROP TABLE REGION PURGE;
  DROP TABLE EMPLOYEES PURGE;
  DROP TABLE SHIPPERS PURGE;
  DROP TABLE COUNTRY PURGE;
------------------------------------------------------------------------------------------------------END TABLE DROP STATEMENTS




------------------------------------------------------------------------------------------------------BEGIN TABLE CREATION STATEMENTS
--Create all Northwind tables (14)
  CREATE TABLE Employees (
    EmployeeID number NOT NULL,
    LastName varchar (20) NOT NULL ,
    FirstName varchar (10) NOT NULL ,
    Title varchar (30) NULL ,
    TitleOfCourtesy varchar (25) NULL ,
    TOCAndFullName varChar (57) NULL,
    BirthDate date NULL ,
    HireDate date NULL ,
    Address varchar (60) NULL ,
    City varchar (15) NULL ,
    Region varchar (15) NULL ,
    PostalCode varchar (10) NULL ,
    HomePhone varchar (24) NULL ,
    Extension varchar (4) NULL ,
    Notes varchar(500) NULL ,
    ReportsTo number NULL,
    CountryID number NULL
  );
  
  CREATE TABLE Categories (
    CategoryID number NOT NULL ,
    CategoryName varchar(15) NOT NULL ,
    Description varchar(255) NULL
  );
  
  CREATE TABLE Customers (
    CustomerID number NOT NULL ,
    CompanyName varchar (40) NOT NULL ,
    CompanyAlphaCode varchar (5) NOT NULL ,
    ContactName varchar (30) NULL ,
    ContactTitle varchar (30) NULL ,
    Address varchar (60) NULL ,
    City varchar (15) NULL ,
    Region varchar (15) NULL ,
    PostalCode varchar (10) NULL ,
    Phone varchar (24) NULL ,
    Fax varchar (24) NULL ,
    CountryID number NULL
  );
  
  CREATE TABLE Shippers (
    ShipperID number NOT NULL ,
    CompanyName varchar (40) NOT NULL ,
    Phone varchar (24) NULL
  );
  
  CREATE TABLE Suppliers (
    SupplierID number NOT NULL ,
    CompanyName varchar (40) NOT NULL ,
    ContactName varchar (30) NULL ,
    ContactTitle varchar (30) NULL ,
    Address varchar (60) NULL ,
    City varchar (15) NULL ,
    Region varchar (15) NULL ,
    PostalCode varchar (10) NULL ,
    Phone varchar (24) NULL ,
    Fax varchar (24) NULL ,
    HomePage varchar(2000) NULL ,
    CountryID number NULL
  );
  
  CREATE TABLE Orders (
    OrderID number NOT NULL ,
    CustomerID number NULL ,
    EmployeeID number NULL ,
    OrderDate date NULL ,
    RequiredDate date NULL ,
    ShippedDate date NULL ,
    ShipVia number NULL ,
    Freight number NULL,
    ShipName varchar (40) NULL ,
    ShipAddress varchar (60) NULL ,
    ShipCity varchar (15) NULL ,
    ShipRegion varchar (15) NULL ,
    ShipPostalCode varchar (10) NULL ,
    CountryID number null
  );
  
  CREATE TABLE Products (
    ProductID number  NOT NULL ,
    ProductName varchar (40) NOT NULL ,
    SupplierID number NULL ,
    CategoryID number NULL ,
    QuantityPerUnit varchar (20) NULL ,
    UnitPrice number NULL ,
    Discontinued number NOT NULL
  );
  
  CREATE TABLE Order_Details (
    OrderID number NOT NULL ,
    ProductID number NOT NULL ,
    UnitPrice number NOT NULL ,
    Quantity number NOT NULL ,
    Discount number NOT NULL
  );
    
  CREATE TABLE Region ( 
    RegionID number NOT NULL ,
    RegionDescription varchar (50) NOT NULL 
  );
  
  CREATE TABLE Territories ( 
    TerritoryID number NOT NULL ,
    TerritoryDescription varchar (50) NOT NULL ,
    RegionID number NOT NULL
  );
  
  CREATE TABLE EmployeeTerritories (
    EmployeeID number NOT NULL,
    TerritoryID INTEGER NOT NULL 
  );
  
  CREATE TABLE ProductsWarehouse (
    WarehouseID number NOT NULL ,
    ProductID number NOT NULL ,
    UnitsInStock number NULL ,
    UnitsOnOrder number NULL ,
    ReorderLevel number NULL
  );
  CREATE TABLE Warehouse (
    WarehouseID number NOT NULL ,
    WarehouseName varchar (30) NULL ,
    Address varchar (60) NULL
  );
  
  CREATE TABLE Country (
    CountryID number NOT NULL,
    CountryName varchar (15) NULL
  );
------------------------------------------------------------------------------------------------------END TABLE CREATION STATEMENTS




------------------------------------------------------------------------------------------------------BEGIN ALTER TABLE STATEMENTS
--Add all Key and Check Constraints (14)
  ALTER TABLE Employees
    ADD (
      CONSTRAINT PK_Employees PRIMARY KEY (EmployeeID),
      CONSTRAINT FK_Employees_Employees FOREIGN KEY (ReportsTo) 
        REFERENCES Employees (EmployeeID)
      );

  ALTER TABLE Categories
    ADD (
      CONSTRAINT PK_Categories PRIMARY KEY (CategoryID)
    );

  ALTER TABLE Country
    ADD (
      CONSTRAINT PK_Country PRIMARY KEY (CountryID)
    );
  
  ALTER TABLE Customers
    ADD (
      CONSTRAINT PK_Customers PRIMARY KEY (CustomerID),
      CONSTRAINT FK_Customers_Country FOREIGN KEY (CountryID)
        REFERENCES Country (CountryID)
    );

  ALTER TABLE Shippers
    ADD (
      CONSTRAINT PK_Shippers PRIMARY KEY (ShipperID)
    );

  ALTER TABLE Suppliers
    ADD (
      CONSTRAINT PK_Suppliers PRIMARY KEY (SupplierID) ,
      CONSTRAINT FK_Suppliers_Country FOREIGN KEY (CountryID)
        REFERENCES Country (CountryID)
    );

  ALTER TABLE Orders
    ADD (
      CONSTRAINT PK_Orders PRIMARY KEY (OrderID),
      CONSTRAINT FK_Orders_Customers FOREIGN KEY (CustomerID) 
        REFERENCES Customers (CustomerID),
      CONSTRAINT FK_Orders_Employees FOREIGN KEY (EmployeeID)
        REFERENCES Employees(EmployeeID),
      CONSTRAINT FK_Orders_Shippers FOREIGN KEY (ShipVia) 
        REFERENCES Shippers (ShipperID),
      CONSTRAINT FK_Orders_Country FOREIGN KEY (CountryID)
        REFERENCES Country (CountryID)
    );

  ALTER TABLE Products
    ADD (
      CONSTRAINT PK_Products PRIMARY KEY (ProductID),
      CONSTRAINT FK_Products_Categories FOREIGN KEY (CategoryID)
        REFERENCES Categories (CategoryID),
      CONSTRAINT FK_Products_Suppliers FOREIGN KEY (SupplierID)
        REFERENCES Suppliers (SupplierID),
      CONSTRAINT CK_Products_UnitPrice CHECK (UnitPrice >= 0),
      CONSTRAINT CK_Discontinued CHECK (Discontinued IN (0,1))
    );

  ALTER TABLE Warehouse
    ADD (
      CONSTRAINT PK_Warehouse_Warehouse PRIMARY KEY (WarehouseID)
    );

  ALTER TABLE ProductsWarehouse
    ADD (
      CONSTRAINT PK_ProductsWarehouse PRIMARY KEY (WarehouseID, ProductID),
      CONSTRAINT FK_ProductsWarehouse_Warehouse FOREIGN KEY (WarehouseID)
        REFERENCES Warehouse (WarehouseID),
      CONSTRAINT FK_ProductsWarehouse_Product FOREIGN KEY (ProductID)
        REFERENCES Products (ProductID)--,
      --CONSTRAINT CK_ReorderLevel CHECK (ReorderLevel >= 0),
      --CONSTRAINT CK_UnitsInStock CHECK (UnitsInStock >= 0),
      --CONSTRAINT CK_UnitsOnOrder CHECK (UnitsOnOrder >= 0)      
  );

  ALTER TABLE Order_Details
    ADD (
      CONSTRAINT PK_Order_Details PRIMARY KEY (OrderID,	ProductID),
      CONSTRAINT FK_Order_Details_Orders FOREIGN KEY (OrderID)
        REFERENCES Orders (OrderID),
      CONSTRAINT FK_Order_Details_Products FOREIGN KEY (ProductID)
        REFERENCES Products (ProductID),
      CONSTRAINT CK_Discount CHECK (Discount >= 0 and (Discount <= 1)),
      CONSTRAINT CK_Quantity CHECK (Quantity > 0),
      CONSTRAINT CK_UnitPrice CHECK (UnitPrice >= 0)
    );
 
  ALTER TABLE Region
    ADD CONSTRAINT PK_Region PRIMARY KEY (RegionID);

  ALTER TABLE Territories
    ADD (
      CONSTRAINT PK_Territories PRIMARY KEY (TerritoryID),
      CONSTRAINT FK_Territories_Region FOREIGN KEY (RegionID)
        REFERENCES Region (RegionID)
        );

  ALTER TABLE EmployeeTerritories
    ADD (
    CONSTRAINT PK_EmployeeTerritories PRIMARY KEY(EmployeeID,TerritoryID),
    CONSTRAINT FK_EmplTerritories_Employees FOREIGN KEY (EmployeeID)
      REFERENCES Employees (EmployeeID),
    CONSTRAINT FK_EmplTerritories_Territories FOREIGN KEY (TerritoryID)
      REFERENCES Territories (TerritoryID)
      );
------------------------------------------------------------------------------------------------------END ALTER TABLE STATEMENTS

--End Script
