/****************************** Project Implementation*************************************/

---------------------------------DDL Statements---------------------------------------
create database VehicleVendingMachine

CREATE TABLE Customer
(
	CustomerID int not null,
	CustomerName nvarchar(100),
	CustomerAddress varchar(250),
	CustomerDateOfBirth date,
	CustomerEmailID varchar(250),
	CustomerPhone bigint
	CONSTRAINT Customer_PK primary key (CustomerID)
);

Create table Vehicle
(
	VehicleID int not null,
	CustomerID int not null,
	VehicleType varchar(100),
	Brand varchar(100),
	Mileage float,
	Color varchar(50),
	ManufacturedYear varchar(10),
	VehicleModel varchar(100),
	Price float,
	FuelType varchar(100)
	CONSTRAINT Vehicle_PK PRIMARY KEY (VehicleID),
	CONSTRAINT Customer_FK FOREIGN KEY (CustomerID) References Customer(CustomerID)
);

Create Table PaymentInfo
(
	PaymentID int not null,
	CustomerID int not null,
	VehicleID int not null,
	ModeOfPayment varchar(100) CHECK (ModeOfPayment IN('Cheque','Internet Banking','Credit/Debit Card')),
	Amount float
	CONSTRAINT Payment_PK PRIMARY KEY (PaymentID),
	CONSTRAINT PayVehicle_FK FOREIGN KEY (VehicleID) References Vehicle(VehicleID),
	CONSTRAINT PayCustomer_FK FOREIGN KEY (CustomerID) References Customer(CustomerID)
);

Create Table CompanyServiceCenter
(
	ServiceCenterID int not null,	
	Brand varchar(100),
	PointOfContact varchar(100),
	[Address] varchar(250),
	VehicleID int not null, 
	CONSTRAINT ServiceCenter_PK PRIMARY KEY (ServiceCenterID),
	CONSTRAINT ServiceVehicle_FK FOREIGN KEY (VehicleID) References Vehicle(VehicleID)
);

Create Table Service
(
	QueryID int not null,	
	VehicleID int not null,
	ServiceCenterID int not null,
	PhoneNumber bigint,
	ComplaintDetails varchar(500),
	[DateTime] datetime,
	RequestType varchar (100), 
	CONSTRAINT Service_PK PRIMARY KEY (QueryID),
	CONSTRAINT Vehicle_FK FOREIGN KEY (VehicleID) References Vehicle(VehicleID),
	CONSTRAINT ServiceCenter_FK FOREIGN KEY (ServiceCenterID) References CompanyServiceCenter(ServiceCenterID)
);

Create Table StoreLocation
(
	StoreID int not null,	
	[Address] varchar(100),
	City varchar(20),
	Franchise bit, 
	[Level] char(20),
	Position int not null,
	CONSTRAINT Store_PK PRIMARY KEY (StoreID),
	CONSTRAINT VehicleStore_FK FOREIGN KEY ([Level],Position) References VehicleLocation([Level],Position)
);

Create Table VehicleLocation
(	
	VehicleID int not null,	
	[Level] char(20),
	Position int not null,
	CONSTRAINT VehicleLocation_PK PRIMARY KEY ([Level],Position),
	CONSTRAINT VehicleLocation_FK FOREIGN KEY (VehicleID) References Vehicle(VehicleID),
);

Create table Finance
(	CustomerID int not null,
	Loan_Options varchar(20),
	Annual_Income float,
	Credit_Score int,
	Rate_of_Interest float,
	Downpayment float,
	Installment int,
	Credit_Score_Encrypted varbinary(128)
	CONSTRAINT Finance_FK foreign key (CustomerID) references Customer (CustomerID)
		);

Create table Delivery
(	DeliveryID int not null,
	VehicleID int not null,
	Delivery_Location varchar(50),
	Delivery_Date date,
	Delivery_Time time,
	Contact_no bigint,

	CONSTRAINT Delivery_PK primary key (DeliveryID),
	CONSTRAINT Delivery_FK foreign key (VehicleID) references Vehicle (VehicleID)
);

Create table Vehicle_Warranty
(	Registration_no int not null,
	VehicleID int not null,
	Date_of_Purchase date,
	Warranty_Period float,
	[Description] varchar(500)

	
	CONSTRAINT VehicleWrnty_PK primary key (Registration_no),
	CONSTRAINT VehicleWrnty_FK foreign key (VehicleID) references Vehicle (VehicleID)
	);

Create table Insurance
(	Insurance_no int not null,
	VehicleID int not null,
	Insurance_Options varchar(200) CHECK (Insurance_Options IN('State Farm','GEICO','Allstate','Progressive Corporation','USAA')),
	Registration_Details varchar(100)

	CONSTRAINT Insurance_PK primary key (Insurance_no),
	CONSTRAINT Insurance_FK foreign key (VehicleID) references Vehicle (VehicleID)
	);


create table Accessories
(	Part_no int not null,
	VehicleID int not null,
	Price float,
	Manufacturer varchar(20),
	[Description] varchar(100)
	
	
	CONSTRAINT Accessories_PK primary key (Part_no),
	CONSTRAINT Accessories_FK foreign key (VehicleID) references Vehicle (VehicleID)
	);

Create table Part_Warranty
(	Part_no int not null,
	VehicleID int not null,
	Date_of_Purchase date,
	Warranty_Period int not null,
	[Description] varchar(200)

	
	CONSTRAINT PartWrnty_FK foreign key (Part_no) references Accessories (Part_no),
	CONSTRAINT PartWarranty_FK foreign key (VehicleID) references Vehicle (VehicleID)
	);



---------------------------Non Clustered Index on Customer Table--------------------
create nonclustered index index_name
on Customer(CustomerName ASC)

---------------------------Non Clustered Index on Insurance Table--------------------
create nonclustered index index_insopt
on Insurance(Insurance_Options)


/********************************DML Statements********************************/
-------------Inserting Data with the help of Import Data Wizard----------------------------
insert into Customer select * from CustomerDetails

insert into Vehicle select * from VehicleDetails

insert into PaymentInfo select * from PaymentDetails

insert into Finance select * from FinanceDetails

insert into Delivery select * from DeliveryDetails

insert into Vehicle_Warranty select * from VehicleWarrantyDetails

insert into Accessories select * from PartDetails

insert into Insurance select * from InsuranceDetails

insert into Part_Warranty select * from PartWarrantyDetails

insert into CompanyServiceCenter select * from CompanyServiceCenterDetails

insert into [Service] select * from ServiceDetails
	
insert into VehicleLocation select * from VehicleLocationDetails

insert into StoreLocation select * from StoreLocationDetails



/********************************Stored Procedures********************************/
------------------Stored Procedure to Check Pending Payment of Customers-----------------------

CREATE PROCEDURE getremainingamount
@customerid int,
@remaining_payment int output
as
BEGIN

WITH 

t1 AS (
Select VehicleID as VehicleID,CustomerID as CustomerID,SUM(Amount) as total_pay
from PaymentInfo
GROUP BY VehicleID ,CustomerID
HAVING CustomerID = @customerid),

t2 AS (

Select t1.VehicleID as vid,t1.CustomerID as cid,t1.total_pay as total_pay,v.VehicleType as vt ,v.VehicleModel as vm,v.Brand as brand,v.Color as color,v.ManufacturedYear as MY,v.Price as Price,v.FuelType as ft
FROM t1
JOIN Vehicle v
ON t1.VehicleID = v.VehicleID AND t1.CustomerID = @customerid)

SELECT @remaining_payment =  (t2.Price-t2.total_pay) 
FROM t2;
END

DECLARE @remp int
EXECUTE getremainingamount 16828,@remaining_payment = @remp OUT
SELECT @remp as RemainingPayment

---------------Stored Procedure to check if vehicle is serviced at service center or vending maching------------
create procedure ServiceCenter @VehicleID int,@message varchar(100) output
as
begin
if not exists (select VehicleID from Vehicle where VehicleID=@VehicleID)
set @message='VehicleID is invalid'
else if exists (select CustomerID,s.ServiceCenterID,Brand,v.VehicleModel from Vehicle v join [Service] s on v.VehicleID=s.VehicleID  
where s.ServiceCenterID IS NOT NULL AND s.VehicleID=@VehicleID)
set @message='Vehicle serviced from Service Center'

else set @message='Vehicle serviced from Vending machine'
end

declare @result varchar(100)
exec ServiceCenter 1327724,@result output
print @result

-----------------Stored Procedure to check for Vehicle Store Pickup or Vehicle Delivery-----------------------
create procedure DeliveryStatus  @CustomerID int, @VehicleID int output, @CustomerName varchar(100) output,
@Delivery_Status varchar(50) output
as
begin
set @VehicleID= (select v.VehicleID from Vehicle v join Customer c on v.CustomerID=c.CustomerID where v.CustomerID=@CustomerID)
set @CustomerName= (select c.CustomerName from Customer c join Vehicle v on v.CustomerID= c.CustomerID where v.CustomerID=@CustomerID)
set @Delivery_Status= (select Case when VehicleID in (Select d.VehicleID from Delivery d) then 'Delivery'
    else 'Pickup' end from Vehicle v join Customer c on v.CustomerID=c.CustomerID where v.CustomerID=@CustomerID )
end

declare @VehicleID int, @CustomerName varchar(50), @Delivery_Status varchar(50)
exec DeliveryStatus 53044, @VehicleID output, @CustomerName output, @Delivery_Status output
select @VehicleID as VehicleID, @CustomerName as Customer_Name, @Delivery_Status as Delivery_Status 


--------------------------------Stored Procedure to retrieve Safety Rating for Vehicles---------------------------------
create procedure VehicleRating @VehicleModel varchar(50),@Rating float output, @VehicleName varchar(50) output
as
begin
set @Rating=(select case when VehicleModel = 'A6 Premium' then 3.5
						 when VehicleModel = 'Acadia Denali Sport Utility' then 5
						 when VehicleModel = 'Beetle 1.8T Dune' then 4
						 when VehicleModel = 'Camaro Z/28' then 3
						 when VehicleModel = 'Colorado Crew Cab' then 5
						 when VehicleModel = 'Durango SXT' then 2.5
						 when VehicleModel = 'F350 Super Duty' then 4.5 
						 when VehicleModel = 'Forte5 LX' then 4
						 when VehicleModel = 'GLK-Class 350' then 5
						 when VehicleModel = 'LX Sport Utility' then  5
						 when VehicleModel = 'Malibu LT Sedan' then 4
						 when VehicleModel = 'Maxima S' then  3.5
						 when VehicleModel = 'RC 350 Coupe 2D' then 3.5
						 when VehicleModel = 'Wrangler Sport' then 3
						 when VehicleModel = 'XE 25t' then 5
						 end from Vehicle where VehicleModel like '%' +@VehicleModel+ '%'
						 )
set @VehicleName= (select VehicleModel from Vehicle where VehicleModel like '%' +@VehicleModel+ '%')
end

declare @VehicleRating float, @VehicleName varchar(50)
exec VehicleRating 'A6', @VehicleRating output, @VehicleName output 
select @VehicleName as Model, @VehicleRating as [Safety Rating]

/********************************User Defined Functions********************************/


---------------Function to return Available cars based on Car type----------------------------------
create function GetVehicle(@Vehicle_Type varchar(200))
returns @Table table (VehicleID int,Brand varchar(50),Mileage float,Color varchar(50),VehicleModel varchar(100),Price float)

As
Begin
 insert into @Table 
 select VehicleID,Brand,Mileage,Color,VehicleModel,Price from Vehicle where VehicleType=@Vehicle_Type
return
End


select * from dbo.GetVehicle('Sedan') order by Price

---------------Function to return Part Details for a Particular Vehicle----------------------------------
create function GetPartDetails(@Part_no int)
returns @Table table (Part_No int,VehicleID int,Vehicle varchar(100),Description varchar(200),WarrantyYears int)
as 
begin
insert into @Table
select a.Part_no,v.VehicleID,v.Brand+' '+v.VehicleModel as Vehicle,a.[Description],w.Warranty_Period from Accessories a join Vehicle v on 
v.VehicleID=a.VehicleID join Part_Warranty w on a.Part_no=w.Part_no where a.Part_no=@Part_no
return 
end

select * from dbo.GetPartDetails(361308)

/********************************Views********************************/

----------------------------------Vehicle Count of each Customer----------------------------
Create VIEW VehicleCountbyCustomer
as
select v.CustomerID,v.VehicleModel, COUNT(v.VehicleModel)  OVER (PARTITION BY v.CustomerID Order by v.VehicleModel desc) as [count] 
from Vehicle v


select *
from VehicleCountbyCustomer

---------------------------Vehicle Warranty End Date of each Vehicle-------------------------

create view WarrantyEnd as
select w.VehicleID, v.ManufacturedYear, w.Date_of_Purchase, (DATEADD(yyyy,Warranty_Period,Date_of_Purchase)) as WarrantyEndDate
from Vehicle v join Vehicle_Warranty w
on v.VehicleID=w.VehicleID


Select * from WarrantyEnd

--------------------------Vehicle Count by Fuel Type-------------------
create view VehicleCountByFuelType as
select FuelType,count(FuelType) as VehicleCount from Vehicle
group by FuelType

select * from VehicleCountByFuelType

/********************************Triggers********************************/

----------------------------Trigger to track payment made by customer----------------------------
create TRIGGER tr_new_payment
ON PaymentInfo
FOR INSERT
AS 
BEGIN

DECLARE @customer_id int, @amount int, @mop varchar(50)
SELECT @customer_id =  CustomerID, @amount = Amount, @mop = ModeOfPayment FROM inserted


INSERT INTO LogInfo
VALUES('customer with id = ' + CAST(@customer_id as nvarchar(5)) + ' has made a payment of ' + CAST(@amount as nvarchar(10)) + ' on ' + cast(getdate() as nvarchar(20)) + ' using ' + @mop) 

END

Create TABLE LogInfo(
id int IDENTITY(1,1) PRIMARY KEY,
[message] varchar(1000)

);


INSERT INTO PaymentInfo 
values(123456789,66671,1321233,'Cheque',5000);

SELECT * from PaymentInfo
select * from LogInfo

------------------------------Trigger to Track Accessory addition for vehicles-------------
create TRIGGER Track_Accessories
ON Accessories
FOR INSERT
AS 
BEGIN

DECLARE @part_no int, @vehicle_id int
SELECT @part_no =  Part_No, @vehicle_id = VehicleID FROM inserted


INSERT INTO Part_Warranty
VALUES(@part_no,@vehicle_id,GETDATE(),2,'Carburetor')


end

select * from Part_Warranty
select * from Accessories

INSERT INTO Accessories values (1112,1290071,50,'Motor Seasons', 'Bumper')

/********************************Column Data Encryption********************************/

-------------------------------Column Data Encryption on Credit Score of Customer-------------------- 
CREATE MASTER KEY ENCRYPTION BY   
PASSWORD = 'INFO6210'  

CREATE CERTIFICATE Customercert 
WITH SUBJECT = 'Customer Credit Score'

CREATE SYMMETRIC KEY Credit_Score_Key
WITH ALGORITHM = AES_256 
ENCRYPTION BY CERTIFICATE Customercert;

OPEN SYMMETRIC KEY Credit_Score_Key  
DECRYPTION BY CERTIFICATE Customercert;  

select * from Finance
-- Encrypt credit score and add in Credit Score Encrypted
UPDATE Finance
SET Credit_Score_Encrypted = EncryptByKey(Key_GUID('Credit_Score_Key'),CONVERT(nvarchar,Credit_Score))

-- Decrypt credit score and show as Decrypted Score
OPEN SYMMETRIC KEY Credit_Score_Key  
DECRYPTION BY CERTIFICATE Customercert;
select CustomerID, Annual_Income,Credit_Score_Encrypted, CONVERT(nvarchar, DecryptByKey(Credit_Score_Encrypted))  as 'Decrypted Credit Score' from Finance;

/********************************Computed Columns********************************/

------------------------Compute Discount and Effective Price Values in Vehicle Table---------------------
Create View DiscountedPrice as
select v.VehicleID, v.VehicleType, concat(v.Brand, v.VehicleModel) as Vehicle, v.Price, v.FuelType,
(case when (v.Price<20000) then '10%'
        when (v.Price>20000 and v.Price<30000) then '15%'
        else '20%'
        end) as Discount,
(case when (v.Price<20000) then (v.Price-(v.Price*10/100))
when (v.Price>20000 and v.Price<30000) then (v.Price-(v.Price*15/100))
else (v.Price-(v.Price*20/100)) end) as Effective_Price
from Vehicle v
select * from DiscountedPrice




