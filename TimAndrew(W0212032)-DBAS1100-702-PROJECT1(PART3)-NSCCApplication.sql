--------------------------------------------
-- Author:      Tim Andrew                --
-- Student ID:  W0212032 @nscc.ca         --
-- Class:       DBAS 1100-702             --
-- Project#:    1 (part 3)                --
-- Date:        February 29th, 2016       --
--------------------------------------------
-- This script will Create 15 Tables and  --
-- one sequence.  It will also allow for  --
-- the removal of the tables and          --
-- sequence. (Project 2/3)                --
--                                        --
-- This script will then populate the     --
-- tables with data. (Project 3/3)        --
-- (Part 3/3 starts on line 225)          --
--------------------------------------------

------[[[[[[[ START OF PROJECT PART 2/3 OF SCRIPT ]]]]]]]-------


-------[[[[[[[ DROP SEQUENCES ]]]]]]]-------

--Drop sequences:
DROP SEQUENCE Student_Student_ID_Seq;
DROP SEQUENCE Program_ID_seq;
DROP SEQUENCE SchoolHistory_ID_seq;


-------[[[[[[[ DROP TABLES ]]]]]]]------- 

--Drop Tables:
DROP TABLE "NSCounty";
DROP TABLE "Address";
DROP TABLE "Country";
DROP TABLE "Citizenship";
DROP TABLE "Program";
DROP TABLE "CreditCard";
DROP TABLE "Fee";
DROP TABLE "PrimaryLanguage";
DROP Table "PreviousStudent";
DROP TABLE "Consent";
DROP TABLE "SchoolHistory";
DROP TABLE "Health";
DROP TABLE "DisabilityDoc";
DROP TABLE "SelfIdentify";
DROP TABLE "Student";


-------[[[[[[[ CREATE SEQUENCES ]]]]]]]-------

--Create sequence "Student_Student_ID_seq":
CREATE SEQUENCE Student_Student_ID_seq 
  START WITH 1 
  INCREMENT BY 1 
  NOMAXVALUE 
  NOCACHE;
  
--Create sequence "Program_ID_seq":
CREATE SEQUENCE Program_ID_seq 
  START WITH 1 
  INCREMENT BY 1 
  NOMAXVALUE 
  NOCACHE;

--Create sequence "SchoolHistory_ID_seq":
CREATE SEQUENCE SchoolHistory_ID_seq 
  START WITH 1 
  INCREMENT BY 1 
  NOMAXVALUE 
  NOCACHE;
  
-------[[[[[[[ CREATE TABLES ]]]]]]]-------

--Create Table "Student":
CREATE TABLE "Student"
(
Student_ID INT PRIMARY KEY,
Student_FirstName VARCHAR(15) NOT NULL,
Student_PreferredFirstName VARCHAR(15) NOT NULL,
Student_MiddleName VARCHAR(15),
Student_LastName VARCHAR(25) NOT NULL,
Student_PrevLastName VARCHAR(25),
Student_SIN INTEGER NOT NULL,
Student_DOB DATE NOT NULL,
Student_Gender CHAR(1) NOT NULL CHECK(Student_Gender IN ('0','1')),
Student_HomePHone INTEGER,
Student_WorkPhone INTEGER,
Student_CellPhone INTEGER,
Student_Email VARCHAR(100),
Student_PrimaryEnglish CHAR(1) NOT NULL CHECK(Student_PrimaryEnglish IN ('0','1')),
Student_ApplicationDate DATE NOT NULL,
Student_Signature BLOB --BLOB is MS ACCESS/VISIO 2010 Equivalent of ATTACHMENT (for signature file)
);

--Create Table "Address":
CREATE TABLE "Address"
(
Address_Student_ID INT PRIMARY KEY REFERENCES "Student"(Student_ID),
Address_Apartment VARCHAR(5),
Address_Mailing VARCHAR(255) NOT NULL,
Address_City VARCHAR(25) NOT NULL,
Address_Province VARCHAR(20) NOT NULL,
Address_Country VARCHAR(15) NOT NULL,
Address_PostalCode VARCHAR(7) NOT NULL
);

--Create Table "NSCounty":
CREATE TABLE "NSCounty"
(
NSCounty_Address_Student_ID INT PRIMARY KEY REFERENCES "Address"(Address_Student_ID),
NSCounty_Name VARCHAR(20) NOT NULL
);

--Create Table "Citizenship":
CREATE TABLE "Citizenship"
(
Citizenship_Student_ID INT PRIMARY KEY REFERENCES "Student"(Student_ID),
Citizenship_Canadian CHAR(1) CHECK (Citizenship_Canadian IN ('0','1')),
Citizenship_Immigrant CHAR(1) CHECK (Citizenship_Immigrant IN ('0','1')),
Citizenship_Refugee CHAR(1) CHECK (Citizenship_Refugee IN ('0','1')),
Citizenship_Other CHAR(1) CHECK (Citizenship_Other IN ('0','1'))
);

--Create Table "Country":
CREATE TABLE "Country"
(
Country_Citizenship_Student_ID INT PRIMARY KEY REFERENCES "Citizenship"(Citizenship_Student_ID),
Country_CItizenship VARCHAR(50) NOT NULL
);

--Create Table "Program":
CREATE TABLE "Program"
(
Program_ID INT PRIMARY KEY,
Program_Student_ID INT REFERENCES "Student"(Student_ID),
Program_Choice VARCHAR(50) NOT NULL,
Program_Campus VARCHAR(50) NOT NULL
);

--Create Table "Fee":
CREATE TABLE "Fee"
(
Fee_Student_ID INT PRIMARY KEY REFERENCES "Student"(Student_ID),
Fee_CreditCardORCheque CHAR(1) NOT NULL CHECK(Fee_CreditCardORCheque IN ('0','1')),
Fee_Office_Receipt INTEGER,
Fee_Office_Date DATE
);

--Create Table "CreditCard":
CREATE TABLE "CreditCard"
(
CreditCard_Fee_Student_ID INT PRIMARY KEY REFERENCES "Fee"(Fee_Student_ID),
CreditCard_Type VARCHAR(15) NOT NULL,
CreditCard_HolderName VARCHAR(50) NOT NULL,
CreditCard_Number INTEGER NOT NULL,
CreditCard_Expiry DATE NOT NULL
);

--Create Table "PrimaryLanguage":
CREATE TABLE "PrimaryLanguage"
(
PrimaryLanguage_Student_ID INT PRIMARY KEY REFERENCES "Student"(Student_ID),
PrimaryLanguage_FirstLanguage VARCHAR(25) NOT NULL
);

--Create Table "PreviousStudent":
CREATE TABLE "PreviousStudent"
(
PreviousStudent_Student_ID INT PRIMARY KEY REFERENCES "Student"(Student_ID),
PreviousStudent_ID INT NOT NULL
);

--Create Table "Consent":
CREATE TABLE "Consent"
(
Consent_Student_ID INT PRIMARY KEY REFERENCES "Student"(Student_ID),
Consent_Permission CHAR(1) NOT NULL CHECK(Consent_Permission IN ('0','1')),
Consent_Name VARCHAR(50) NOT NULL,
Consent_Relationship VARCHAR(25)
);

--Create Table "SchoolHistory":
CREATE TABLE "SchoolHistory"
(
SchoolHistory_ID INT PRIMARY KEY,
Student_ID INT REFERENCES "Student"(Student_ID),
SchoolHistory_Name VARCHAR(50) NOT NULL,
SchoolHistory_Location VARCHAR(255) NOT NULL,
SchoolHistory_GradeCompleted INTEGER NOT NULL,
SchoolHistory_DateCompleted DATE NOT NULL
);

--Create Table "Health":
CREATE TABLE "Health"
(
Health_Student_ID INT PRIMARY KEY REFERENCES "Student"(Student_ID),
Health_Criminal CHAR(1) NOT NULL CHECK(Health_Criminal IN ('0','1')),
Health_ChildAbuse CHAR(1) NOT NULL CHECK(Health_ChildAbuse IN ('0','1')),
Health_Discipline CHAR(1) NOT NULL CHECK(Health_Discipline IN ('0','1'))
);

--Create Table "SelfIdentify":
CREATE TABLE "SelfIdentify"
(
SelfIdentify_Student_ID INT PRIMARY KEY REFERENCES "Student"(Student_ID),
SelfIdentify_Aboriginal CHAR(1) NOT NULL CHECK(SelfIdentify_Aboriginal IN ('0','1')),
SelfIdentify_African CHAR(1) NOT NULL CHECK(SelfIdentify_African IN ('0','1')),
SelfIDentify_Disibility CHAR(1) NOT NULL CHECK(SelfIdentify_Disibility IN ('0','1'))
);

--Create Table "DisabilityDoc":
CREATE TABLE "DisabilityDoc"
(
DisabilityDoc_SelfId_S_ID INT PRIMARY KEY REFERENCES "SelfIdentify"(SelfIdentify_Student_ID),
DisabilityDoc_Enclosed CHAR(1) NOT NULL CHECK(DisabilityDoc_Enclosed IN ('0','1')),
DisabilityDoc_Forward CHAR(1) CHECK(DisabilityDoc_Forward IN ('0','1')),
DisabilityDoc_OnFile CHAR(1) CHECK(DisabilityDoc_OnFile IN ('0','1'))
);


------[[[[[[[ END OF PROJECT PART 2/3 OF SCRIPT ]]]]]]]-------




------[[[[[[[ START OF PROJECT PART 3/3 OF SCRIPT ]]]]]]]-------
--Entry One:
INSERT INTO "Student" VALUES(Student_Student_ID_seq.NEXTVAL, 'Tim', 'Tim', 'G', 'Andrew', null, '12345678', To_DATE('04/02/1976','MM-DD-YYYY'), '0', '9025552525', null, null, 'tim@tim.com', '0', To_DATE('01/01/2015','MM-DD-YYYY'), null);
INSERT INTO "Address" VALUES(Student_Student_ID_seq.CURRVAL, null, '150 Nice St.', 'Halifax', 'Nova Scotia', 'Canada', 'A1A 1A1');
INSERT INTO "NSCounty" VALUES(Student_Student_ID_seq.CURRVAL, 'Halifax');
INSERT INTO "Citizenship" VALUES(Student_Student_ID_seq.CURRVAL, '1', null, null, null);
INSERT INTO "Program" VALUES(Program_ID_seq.NEXTVAL, Student_Student_ID_seq.CURRVAL, 'Information Technology', 'IT Campus');
INSERT INTO "Program" VALUES(Program_ID_seq.NEXTVAL, Student_Student_ID_seq.CURRVAL, 'Electrician', 'Truro Campus');
INSERT INTO "Fee" VALUES(Student_Student_ID_seq.CURRVAL, '1', null, null);
INSERT INTO "CreditCard" VALUES(Student_Student_ID_seq.CURRVAL, 'Visa', 'Tim Andrew', 1234567890, To_DATE('01/01/2019','MM-DD-YYYY'));
INSERT INTO "SchoolHistory" VALUES(SchoolHistory_ID_seq.NEXTVAL, Student_Student_ID_seq.CURRVAL, 'Sir John A. MacDonald', 'Hubley', '12', To_DATE('07/01/1997','MM-DD-YYYY'));
INSERT INTO "Health" VALUES(Student_Student_ID_seq.CURRVAL, '0', '0', '0');
INSERT INTO "SelfIdentify" VALUES(Student_Student_ID_seq.CURRVAL, '0', '0', '1');
INSERT INTO "DisabilityDoc" VALUES(Student_Student_ID_seq.CURRVAL, '1', '0', '0');


--Entry Two:
INSERT INTO "Student" VALUES(Student_Student_ID_seq.NEXTVAL, 'John', 'Johnny', null, 'O''connor', null, '4562345', To_DATE('12/01/1986','MM-DD-YYYY'), '0', '8185546527', null, null, 'Johnny@John.com', '0', To_DATE('02/10/2015','MM-DD-YYYY'), null);
INSERT INTO "Address" VALUES(Student_Student_ID_seq.CURRVAL, null, '344 Future St.', 'Beverly Hills', 'California', 'USA', '90210');
INSERT INTO "Citizenship" VALUES(Student_Student_ID_seq.CURRVAL, null, '1', null, null);
INSERT INTO "Country" VALUES(Student_Student_ID_seq.CURRVAL, 'United States');
INSERT INTO "Consent" VALUES(Student_Student_ID_seq.CURRVAL, '1', 't-eight hundred', 'gaurdian');
INSERT INTO "Program" VALUES(Program_ID_seq.NEXTVAL, Student_Student_ID_seq.CURRVAL, 'Computer Electronics Technician', 'IT Campus');
INSERT INTO "Program" VALUES(Program_ID_seq.NEXTVAL, Student_Student_ID_seq.CURRVAL, 'Dentistry', 'IT Campus');
INSERT INTO "Fee" VALUES(Student_Student_ID_seq.CURRVAL, '0', null, null);
INSERT INTO "SchoolHistory" VALUES(SchoolHistory_ID_seq.NEXTVAL, Student_Student_ID_seq.CURRVAL, 'Beverly High', 'Beverly Hills', '11', To_DATE('07/01/2007','MM-DD-YYYY'));
INSERT INTO "Health" VALUES(Student_Student_ID_seq.CURRVAL, '1', '0', '1');
INSERT INTO "SelfIdentify" VALUES(Student_Student_ID_seq.CURRVAL, '0', '0', '0');

--Entry Three:
INSERT INTO "Student" VALUES(Student_Student_ID_seq.NEXTVAL, 'Kim', 'Kim', null, 'Wilde', null, '23445657', To_DATE('09/09/1960','MM-DD-YYYY'), '1', '9878273642', null, null, 'kim@kimwilde.com', '0', To_DATE('04/09/2015','MM-DD-YYYY'), null);
INSERT INTO "Address" VALUES(Student_Student_ID_seq.CURRVAL, null, '344 Main St.', 'London', 'London', 'England', 'BPX134');
INSERT INTO "Citizenship" VALUES(Student_Student_ID_seq.CURRVAL, null, '1', null, null);
INSERT INTO "Country" VALUES(Student_Student_ID_seq.CURRVAL, 'England');
INSERT INTO "Program" VALUES(Program_ID_seq.NEXTVAL, Student_Student_ID_seq.CURRVAL, 'Dentistry', 'IT Campus');
INSERT INTO "Program" VALUES(Program_ID_seq.NEXTVAL, Student_Student_ID_seq.CURRVAL, 'Social Services', 'Waterfront Campus');
INSERT INTO "Fee" VALUES(Student_Student_ID_seq.CURRVAL, '1', null, null);
INSERT INTO "CreditCard" VALUES(Student_Student_ID_seq.CURRVAL, 'Mastercard', 'Kim Wilde', 8764560873, To_DATE('03/03/2020','MM-DD-YYYY'));
INSERT INTO "SchoolHistory" VALUES(SchoolHistory_ID_seq.NEXTVAL, Student_Student_ID_seq.CURRVAL, 'London High', 'London', '12', To_DATE('07/01/1979','MM-DD-YYYY'));
INSERT INTO "SchoolHistory" VALUES(SchoolHistory_ID_seq.NEXTVAL, Student_Student_ID_seq.CURRVAL, 'School Of Rock', 'London', '4', To_DATE('07/01/1979','MM-DD-YYYY'));
INSERT INTO "Health" VALUES(Student_Student_ID_seq.CURRVAL, '0', '0', '0');
INSERT INTO "SelfIdentify" VALUES(Student_Student_ID_seq.CURRVAL, '0', '0', '0');

--Entry Four:
INSERT INTO "Student" VALUES(Student_Student_ID_seq.NEXTVAL, 'Jenna', 'Jen', null, 'Penski', null, '23445657', To_DATE('07/25/1993','MM-DD-YYYY'), '1', '9878273642', null, null, 'jenna@hotmail.com', '0', To_DATE('04/09/2015','MM-DD-YYYY'), null);
INSERT INTO "Address" VALUES(Student_Student_ID_seq.CURRVAL, '#5', '344 Main St.', 'Truro', 'Nova Scotia', 'Canada', 'BPX134');
INSERT INTO "NSCounty" VALUES(Student_Student_ID_seq.CURRVAL, 'Turo');
INSERT INTO "Citizenship" VALUES(Student_Student_ID_seq.CURRVAL, '1', null, '1', null);
INSERT INTO "Program" VALUES(Program_ID_seq.NEXTVAL, Student_Student_ID_seq.CURRVAL, 'Aircraft Maintence', 'Waterfront Campus');
INSERT INTO "Program" VALUES(Program_ID_seq.NEXTVAL, Student_Student_ID_seq.CURRVAL, 'Business Administration', 'Waterfront Campus');
INSERT INTO "Fee" VALUES(Student_Student_ID_seq.CURRVAL, '1', null, null);
INSERT INTO "CreditCard" VALUES(Student_Student_ID_seq.CURRVAL, 'Visa', 'Jen Penski', 0976548763, To_DATE('04/01/2018','MM-DD-YYYY'));
INSERT INTO "SchoolHistory" VALUES(SchoolHistory_ID_seq.NEXTVAL, Student_Student_ID_seq.CURRVAL, 'Turo High', 'Truo', '12', To_DATE('07/01/2009','MM-DD-YYYY'));
INSERT INTO "Health" VALUES(Student_Student_ID_seq.CURRVAL, '0', '0', '0');
INSERT INTO "SelfIdentify" VALUES(Student_Student_ID_seq.CURRVAL, '0', '1', '0');


--Entry Five:
INSERT INTO "Student" VALUES(Student_Student_ID_seq.NEXTVAL, 'David', 'Dave', 'Peter', 'Smith', null, '12345678', To_DATE('10/02/1986','MM-DD-YYYY'), '0', '9025552525', '902123456', '9023412350', 'Dave@gmail.com', '0', To_DATE('12/01/2014','MM-DD-YYYY'), null);
INSERT INTO "Address" VALUES(Student_Student_ID_seq.CURRVAL, '#456', '394 Cool St.', 'Halifax', 'Nova Scotia', 'Canada', 'B3B 1B3');
INSERT INTO "NSCounty" VALUES(Student_Student_ID_seq.CURRVAL, 'Halifax');
INSERT INTO "Citizenship" VALUES(Student_Student_ID_seq.CURRVAL, '1', null, null, null);
INSERT INTO "Program" VALUES(Program_ID_seq.NEXTVAL, Student_Student_ID_seq.CURRVAL, 'Information Technology', 'IT Campus');
INSERT INTO "Program" VALUES(Program_ID_seq.NEXTVAL, Student_Student_ID_seq.CURRVAL, 'Social Services', 'Waterfront Campus');
INSERT INTO "Fee" VALUES(Student_Student_ID_seq.CURRVAL, '1', null, null);
INSERT INTO "CreditCard" VALUES(Student_Student_ID_seq.CURRVAL, 'Mastercard', 'David P Smith', 8375087365, To_DATE('02/01/2017','MM-DD-YYYY'));
INSERT INTO "SchoolHistory" VALUES(SchoolHistory_ID_seq.NEXTVAL, Student_Student_ID_seq.CURRVAL, 'Halifax West', 'Halifax', '12', To_DATE('07/01/1997','MM-DD-YYYY'));
INSERT INTO "SchoolHistory" VALUES(SchoolHistory_ID_seq.NEXTVAL, Student_Student_ID_seq.CURRVAL, 'SMU', 'Halifax', '4', To_DATE('07/01/2001','MM-DD-YYYY'));
INSERT INTO "Health" VALUES(Student_Student_ID_seq.CURRVAL, '0', '0', '0');
INSERT INTO "SelfIdentify" VALUES(Student_Student_ID_seq.CURRVAL, '0', '0', '0');

--Entry six:
INSERT INTO "Student" VALUES(Student_Student_ID_seq.NEXTVAL, 'Pauline', 'Paula', 'Jennifer', 'Davidson', 'Nickerson', '839098987', To_DATE('11/24/1982','MM-DD-YYYY'), '1', '9023452323', null, null, 'paula@gmail.com', '0', To_DATE('12/09/2014','MM-DD-YYYY'), null);
INSERT INTO "Address" VALUES(Student_Student_ID_seq.CURRVAL, '#234A', '2342 King St.', 'Glasgow', 'Glasgow', 'Scotland', 'SzN134');
INSERT INTO "Citizenship" VALUES(Student_Student_ID_seq.CURRVAL, null, '1', null, null);
INSERT INTO "Country" VALUES(Student_Student_ID_seq.CURRVAL, 'Scotland');
INSERT INTO "Program" VALUES(Program_ID_seq.NEXTVAL, Student_Student_ID_seq.CURRVAL, 'Dentistry', 'IT Campus');
INSERT INTO "Program" VALUES(Program_ID_seq.NEXTVAL, Student_Student_ID_seq.CURRVAL, 'Social Services', 'Waterfront Campus');
INSERT INTO "Fee" VALUES(Student_Student_ID_seq.CURRVAL, '1', null, null);
INSERT INTO "CreditCard" VALUES(Student_Student_ID_seq.CURRVAL, 'Visa', 'Pauline J Davidson', 2345678534, To_DATE('03/03/2017','MM-DD-YYYY'));
INSERT INTO "SchoolHistory" VALUES(SchoolHistory_ID_seq.NEXTVAL, Student_Student_ID_seq.CURRVAL, 'Glasgow High School', 'Glasgow', '12', To_DATE('07/01/2002','MM-DD-YYYY'));
INSERT INTO "SchoolHistory" VALUES(SchoolHistory_ID_seq.NEXTVAL, Student_Student_ID_seq.CURRVAL, 'SMU', 'Halifax', '4', To_DATE('07/01/2006','MM-DD-YYYY'));
INSERT INTO "Health" VALUES(Student_Student_ID_seq.CURRVAL, '0', '0', '0');
INSERT INTO "SelfIdentify" VALUES(Student_Student_ID_seq.CURRVAL, '0', '0', '0');

--Entry Seven:
INSERT INTO "Student" VALUES(Student_Student_ID_seq.NEXTVAL, 'Shannon', 'Shan', null, 'Smith', null, '443332223', To_DATE('12/13/1987','MM-DD-YYYY'), '1', '9092324343', null, null, 'shannon.s@gmail.com', '1', To_DATE('09/15/2014','MM-DD-YYYY'), null);
INSERT INTO "PrimaryLanguage" VALUES(Student_Student_ID_seq.CURRVAL,'Mic Mac');
INSERT INTO "Address" VALUES(Student_Student_ID_seq.CURRVAL, '#3', '394 Band St.', 'Tatagamoshi', 'Nova Scotia', 'Canada', 'E0G 1Z0');
INSERT INTO "NSCounty" VALUES(Student_Student_ID_seq.CURRVAL, 'Tatagamoshi');
INSERT INTO "Citizenship" VALUES(Student_Student_ID_seq.CURRVAL, '1', null, null, null);
INSERT INTO "Program" VALUES(Program_ID_seq.NEXTVAL, Student_Student_ID_seq.CURRVAL, 'Oceans Technology', 'Waterfront Campus');
INSERT INTO "Program" VALUES(Program_ID_seq.NEXTVAL, Student_Student_ID_seq.CURRVAL, 'Social Services', 'Waterfront Campus');
INSERT INTO "Fee" VALUES(Student_Student_ID_seq.CURRVAL, '1', null, null);
INSERT INTO "CreditCard" VALUES(Student_Student_ID_seq.CURRVAL, 'Mastercard', 'Shannon Smith', 2345684354, To_DATE('09/01/2016','MM-DD-YYYY'));
INSERT INTO "SchoolHistory" VALUES(SchoolHistory_ID_seq.NEXTVAL, Student_Student_ID_seq.CURRVAL, 'Central High', 'Halifax', '12', To_DATE('07/01/2005','MM-DD-YYYY'));
INSERT INTO "Health" VALUES(Student_Student_ID_seq.CURRVAL, '0', '0', '1');
INSERT INTO "SelfIdentify" VALUES(Student_Student_ID_seq.CURRVAL, '1', '0', '0');
INSERT INTO "PreviousStudent" VALUES(Student_Student_ID_seq.CURRVAL, '0231032');


--Entry Eight:
INSERT INTO "Student" VALUES(Student_Student_ID_seq.NEXTVAL, 'James', 'Jim', 'p', 'Anderson', null, '345765432', To_DATE('02/04/1978','MM-DD-YYYY'), '0', '9024459090', null, '90233431212', 'jim@jim.com', '0', To_DATE('03/01/2014','MM-DD-YYYY'), null);
INSERT INTO "Address" VALUES(Student_Student_ID_seq.CURRVAL, '#45', '348 Main St.', 'Halifax', 'Nova Scotia', 'Canada', 'A1A 1A1');
INSERT INTO "NSCounty" VALUES(Student_Student_ID_seq.CURRVAL, 'Halifax');
INSERT INTO "Citizenship" VALUES(Student_Student_ID_seq.CURRVAL, '1', null, null, null);
INSERT INTO "Program" VALUES(Program_ID_seq.NEXTVAL, Student_Student_ID_seq.CURRVAL, 'Screen Arts', 'Waterfront Campus');
INSERT INTO "Program" VALUES(Program_ID_seq.NEXTVAL, Student_Student_ID_seq.CURRVAL, 'Electrician', 'Truro Campus');
INSERT INTO "Fee" VALUES(Student_Student_ID_seq.CURRVAL, '1', null, null);
INSERT INTO "CreditCard" VALUES(Student_Student_ID_seq.CURRVAL, 'Visa', 'Jim Anderson', 9384757392, To_DATE('10/01/2015','MM-DD-YYYY'));
INSERT INTO "SchoolHistory" VALUES(SchoolHistory_ID_seq.NEXTVAL, Student_Student_ID_seq.CURRVAL, 'CP Allen', 'Halifax', '12', To_DATE('07/01/1999','MM-DD-YYYY'));
INSERT INTO "Health" VALUES(Student_Student_ID_seq.CURRVAL, '0', '0', '0');
INSERT INTO "SelfIdentify" VALUES(Student_Student_ID_seq.CURRVAL, '0', '0', '1');
INSERT INTO "DisabilityDoc" VALUES(Student_Student_ID_seq.CURRVAL, '0', '1', '0');


--Entry Nine:
INSERT INTO "Student" VALUES(Student_Student_ID_seq.NEXTVAL, 'Peter', 'Pete', null, 'O''Toole', null, '234567898', To_DATE('04/25/1996','MM-DD-YYYY'), '0', '2728405982', null, null, 'Peter@otoole.com', '0', To_DATE('09/14/2015','MM-DD-YYYY'), null);
INSERT INTO "Address" VALUES(Student_Student_ID_seq.CURRVAL, null, '678 Tomorrow St.', 'Tokyo', 'Tokyo', 'Japan', '2345678');
INSERT INTO "Citizenship" VALUES(Student_Student_ID_seq.CURRVAL, null, '1', null, null);
INSERT INTO "Country" VALUES(Student_Student_ID_seq.CURRVAL, 'Tokyo');
INSERT INTO "Consent" VALUES(Student_Student_ID_seq.CURRVAL, '1', 'Jan Wontu', 'Father');
INSERT INTO "Program" VALUES(Program_ID_seq.NEXTVAL, Student_Student_ID_seq.CURRVAL, 'Computer Electronics Technician', 'IT Campus');
INSERT INTO "Program" VALUES(Program_ID_seq.NEXTVAL, Student_Student_ID_seq.CURRVAL, 'Dentistry', 'IT Campus');
INSERT INTO "Fee" VALUES(Student_Student_ID_seq.CURRVAL, '0', null, null);
INSERT INTO "SchoolHistory" VALUES(SchoolHistory_ID_seq.NEXTVAL, Student_Student_ID_seq.CURRVAL, 'Tokyo High', 'Tokyo', '11', To_DATE('07/01/2014','MM-DD-YYYY'));
INSERT INTO "Health" VALUES(Student_Student_ID_seq.CURRVAL, '0', '0', '0');
INSERT INTO "SelfIdentify" VALUES(Student_Student_ID_seq.CURRVAL, '0', '0', '0');

--Entry Ten:
INSERT INTO "Student" VALUES(Student_Student_ID_seq.NEXTVAL, 'Alexis', 'Alex', null, 'Wicker', null, '234678432', To_DATE('10/29/1979','MM-DD-YYYY'), '1', '9840283560', null, null, 'alexis@email.com', '0', To_DATE('12/09/2015','MM-DD-YYYY'), null);
INSERT INTO "Address" VALUES(Student_Student_ID_seq.CURRVAL, null, '3423 Queen St.', 'Helsinki', 'Helsinki', 'Finland', '9s0 a9s');
INSERT INTO "Citizenship" VALUES(Student_Student_ID_seq.CURRVAL, null, '1', null, null);
INSERT INTO "Country" VALUES(Student_Student_ID_seq.CURRVAL, 'Finland');
INSERT INTO "Program" VALUES(Program_ID_seq.NEXTVAL, Student_Student_ID_seq.CURRVAL, 'Recording Arts', 'Waterfront Campus');
INSERT INTO "Program" VALUES(Program_ID_seq.NEXTVAL, Student_Student_ID_seq.CURRVAL, 'Social Services', 'Waterfront Campus');
INSERT INTO "Fee" VALUES(Student_Student_ID_seq.CURRVAL, '1', null, null);
INSERT INTO "CreditCard" VALUES(Student_Student_ID_seq.CURRVAL, 'Mastercard', 'Alexis Wicker', 2347890567, To_DATE('02/01/2016','MM-DD-YYYY'));
INSERT INTO "SchoolHistory" VALUES(SchoolHistory_ID_seq.NEXTVAL, Student_Student_ID_seq.CURRVAL, 'Helsinki High', 'Helsinki', '12', To_DATE('07/01/1999','MM-DD-YYYY'));
INSERT INTO "SchoolHistory" VALUES(SchoolHistory_ID_seq.NEXTVAL, Student_Student_ID_seq.CURRVAL, 'Music University', 'Helsinki', '4', To_DATE('07/01/2004','MM-DD-YYYY'));
INSERT INTO "Health" VALUES(Student_Student_ID_seq.CURRVAL, '0', '0', '0');
INSERT INTO "SelfIdentify" VALUES(Student_Student_ID_seq.CURRVAL, '0', '0', '0');

--Entry Eleven:
INSERT INTO "Student" VALUES(Student_Student_ID_seq.NEXTVAL, 'Donna', 'Donna', null, 'Summer', null, '876345098', To_DATE('09/05/1973','MM-DD-YYYY'), '1', '90233332345', null, null, 'Donna@hotmail.com', '0', To_DATE('10/09/2014','MM-DD-YYYY'), null);
INSERT INTO "Address" VALUES(Student_Student_ID_seq.CURRVAL, '#345', '7890 Corner St.', 'Lunenburg', 'Nova Scotia', 'Canada', 'Z09 4xP');
INSERT INTO "NSCounty" VALUES(Student_Student_ID_seq.CURRVAL, 'Lunenburg');
INSERT INTO "Citizenship" VALUES(Student_Student_ID_seq.CURRVAL, '1', '1', null, null);
INSERT INTO "Program" VALUES(Program_ID_seq.NEXTVAL, Student_Student_ID_seq.CURRVAL, 'Social Service', 'Waterfront Campus');
INSERT INTO "Program" VALUES(Program_ID_seq.NEXTVAL, Student_Student_ID_seq.CURRVAL, 'Public Relations', 'Waterfront Campus');
INSERT INTO "Fee" VALUES(Student_Student_ID_seq.CURRVAL, '1', null, null);
INSERT INTO "CreditCard" VALUES(Student_Student_ID_seq.CURRVAL, 'Mastercard', 'Donna Summer', 0976548763, To_DATE('09/01/2017','MM-DD-YYYY'));
INSERT INTO "SchoolHistory" VALUES(SchoolHistory_ID_seq.NEXTVAL, Student_Student_ID_seq.CURRVAL, 'Lunenburg High', 'Lunenburg', '12', To_DATE('07/01/2009','MM-DD-YYYY'));
INSERT INTO "Health" VALUES(Student_Student_ID_seq.CURRVAL, '0', '0', '0');
INSERT INTO "SelfIdentify" VALUES(Student_Student_ID_seq.CURRVAL, '0', '1', '0');

------[[[[[[[ END OF PROJECT PART 3/3 OF SCRIPT ]]]]]]]-------