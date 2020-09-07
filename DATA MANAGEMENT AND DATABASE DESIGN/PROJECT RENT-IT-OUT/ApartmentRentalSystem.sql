create database Demo


CREATE TABLE [dbo].[User](
    [User_Id] [int] NOT NULL,
    [User_Name] [varchar](45) NOT NULL,
    [Date_of_Birth] [varchar](45) NOT NULL,
    [Email_Address] [varchar](45) NULL,
    [Address] [varchar](200) NULL,
    [Contact_Number] [bigint] NOT NULL,
PRIMARY KEY ([User_Id]));



CREATE TABLE [dbo].[Property](
    [Property_Id] [int] NOT NULL,
    [Property_Name] [varchar](45) NULL,
    [Street_Name] [varchar](45) NOT NULL,
    [State_Name] [varchar](45) NULL,
    [City_Name] [varchar](45) NOT NULL,
    [Zipcode] [char](6) NOT NULL,
    [Crime_Rate] [varchar](45) NULL,
PRIMARY KEY ([Property_Id]))





CREATE TABLE [dbo].[Public_Facilities](
    [Facility_Id] [int] NOT NULL,
    [Grocery_store] [varchar](45) NULL,
    [Bank] [varchar](45) NULL,
    [Subway_Station] [varchar](45) NULL,
    [Bus_Stop] [varchar](45) NULL,
    [Hospital] [varchar](45) NULL,
    [Gym_facility] [varchar](45) NULL,
	PRIMARY KEY (Facility_Id))



CREATE TABLE [dbo].[Unit](
    [Unit_Id] [int] NOT NULL,
    [User_Id] [int] NOT NULL,
    [Property_Id] [int] NOT NULL,
    [Unit_Number] [int] NOT NULL,
    [Unit_Floor_Number] [int] NOT NULL,
    [Unit_Description] [varchar](45) NOT NULL,
    [Carpet_area] [int] NULL,
    [Pets_Allowed] [char](3) NULL,
    [No_of_bedrooms] [varchar](45) NOT NULL,
    [No_of_bathrooms] [varchar](45) NOT NULL,
    [Date_of_Posting] [datetime] NOT NULL,
    [Date_Available_from] [datetime] NOT NULL,
    [Availability] [char](1) NOT NULL,
	PRIMARY KEY (Unit_Id),
	CONSTRAINT [User_Id] FOREIGN KEY ([User_Id]) REFERENCES [User] ([User_Id]),
	CONSTRAINT Property_Id FOREIGN KEY ([Property_Id]) REFERENCES Property ([Property_Id])
) 




CREATE TABLE [dbo].[Lease_Details](
    [Lease_Id] [int] NOT NULL,
    [Unit_Id] [int] NOT NULL,
    [StartDate] [datetime] NOT NULL,
    [EndDate] [datetime] NOT NULL,
    [Term] [int] NOT NULL,
    [Monthly_Rent] [int] NOT NULL,
    [Security_Deposit_Amount] [int] NOT NULL,
    [Pet_Deposit] [int] NULL,
    [Is_sub_leasing_allowed] [char](1) NOT NULL,
    [Required_people_on_lease] [int] NOT NULL,
	PRIMARY KEY (Lease_Id),
  CONSTRAINT Unit_Id FOREIGN KEY (Unit_Id) REFERENCES Unit (Unit_Id)
)


CREATE TABLE [dbo].[Lease_Payment](
    [Lease_Payment_Id] [int] NOT NULL,
    [User_Id] [int] NULL,
    [Lease_Id] [int] NOT NULL,
    [Payment_Type] [varchar](45) NOT NULL,
    [Payment_Date] [datetime] NOT NULL,
    [Payment_Amount] [int] NOT NULL,
    [Late_Fees] [int] NULL,
	PRIMARY KEY (Lease_Payment_Id),
  CONSTRAINT Lease_Id FOREIGN KEY (Lease_Id) REFERENCES Lease_Details (Lease_Id)
)





CREATE TABLE [dbo].[Agent](
    [User_Id] [int] NOT NULL,
    [Broker_Fee] [int] NOT NULL,
    [Office_Address] [varchar](200) NULL,
	PRIMARY KEY ([User_Id]),
  CONSTRAINT [User_Id6] FOREIGN KEY ([User_Id]) REFERENCES [User] ([User_Id]),
)



CREATE TABLE [dbo].[Owner](
    [User_Id] [int] NOT NULL,
    [Price_Expectation] [int] NULL,
	PRIMARY KEY ([User_Id]),
  CONSTRAINT [User_Id5] FOREIGN KEY ([User_Id]) REFERENCES [User] ([User_Id]),
)



CREATE TABLE [dbo].[Client](
    [User_Id] [int] NOT NULL,
    [Client_Wishlist] [varchar](255) NULL,
	 PRIMARY KEY ([User_Id]),
)



CREATE TABLE [dbo].[Appointment_Schedule](
    [Appointment_Id] [int] NOT NULL,
    [Scheduled_Date] [datetime] NOT NULL,
    [User_Id] [int] NOT NULL,
    [Meeting_Notes] [varchar](45) NULL,
	PRIMARY KEY (Appointment_Id),
  CONSTRAINT [User_Id2] FOREIGN KEY ([User_Id]) REFERENCES [User] ([User_Id]),
)



CREATE TABLE [dbo].[Features](
    [Features_Id] [int] NOT NULL,
    [Parking_Facility] [char](1) NULL,
    [Air_Conditioning] [char](1) NULL,
    [Central_Heating] [char](1) NULL,
    [Carpet_floor] [char](1) NULL,
    [Hardwood_floor] [char](1) NULL,
    [InUnit_Fireplace] [char](1) NULL,
    [InUnit_Garden] [char](1) NULL,
    [InUnit_Laundary] [char](1) NULL,
    [Ceiling_Fan] [char](1) NULL,
    [Pets_Allowed] [char](1) NULL,
    [Walkin_Closet] [char](1) NULL,
	PRIMARY KEY (Features_Id),
  )


CREATE TABLE [dbo].[Has_Features](
    [Unit_Id] [int] NOT NULL,
    [Features_Id] [int] NOT NULL,
	PRIMARY KEY (Unit_Id,Features_Id),
	CONSTRAINT Unit_Id_FK FOREIGN KEY (Unit_Id) REFERENCES Unit (Unit_Id),
	CONSTRAINT Features_Id_FK FOREIGN KEY (Features_Id) REFERENCES Features (Features_Id),
	)

CREATE TABLE [dbo].[Apartment](
    [Unit_Id] [int] NOT NULL,
    [Has_in_unit_laundry] [char](1) NULL,
PRIMARY KEY (Unit_Id),
  
)


CREATE TABLE [dbo].[House](
    [Unit_Id] [int] NOT NULL,
    [Backyard] [char](1) NULL,
    [Parking] [char](1) NULL,
	 PRIMARY KEY (Unit_Id))



CREATE TABLE [dbo].[Has_Zipcode](
    [Property_Id] [int] NOT NULL,
    [Facility_Id] [int] NOT NULL,
	[Zipcode] [int] NOT NULL,
	Primary Key (Property_Id,Facility_Id),
	CONSTRAINT Property_Id_FK FOREIGN KEY ([Property_Id]) REFERENCES Property ([Property_Id]),
	CONSTRAINT Facility_Id_FK FOREIGN KEY (Facility_Id) REFERENCES Public_Facilities (Facility_Id),
	)












select * from [User];
select * from Unit;
select * from Property;
select * from Lease_Payment;
select * from Lease_Details;
select * from Public_Facilities;
select * from Appointment_Schedule;
select * from Features;
select * from Apartment
select * from Agent
select * from House
select * from Has_Zipcode
select * from Has_Features
select * from [Owner]


