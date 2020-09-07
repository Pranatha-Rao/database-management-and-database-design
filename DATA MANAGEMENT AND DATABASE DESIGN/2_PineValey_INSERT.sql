INSERT INTO CUSTOMER VALUES
(1, 'Contemporary Casuals', 
'1355 S. Himes Blvd.', 
'Gainesville', 'FL', '32601');

INSERT INTO CUSTOMER VALUES
(1, 'Contemporary Casuals', '1355 S. Himes Blvd.', 'Gainesville', 'FL', '32601', 'Commercial');

select * from customer

INSERT INTO CUSTOMER VALUES
(2, 'HMM', '11 Main ST', 'Boston', 'MA', '02771', 'Commercial');

INSERT INTO CUSTOMER VALUES
(3, 'XYZ Inc', '16 John Ave', 'Boston', 'MA', '02771', 'Commercial');

INSERT INTO CUSTOMER VALUES
(4, 'RSE Inc', '45 Park drive', 'Boston', 'MA', '02114', 'Commercial');

INSERT INTO CUSTOMER VALUES
(5, 'WER Inc', '900 Parker hill', 'Boston', 'MA', '02914', 'Commercial');

INSERT INTO CUSTOMER VALUES
(6, 'HJG Inc', '43 Boylston street', 'Boston', 'MA', '02115', 'Commercial');

INSERT INTO PRODUCT VALUES
(2, 'King Chair', 'Natural Oak', '400', '8' );

INSERT INTO PRODUCT VALUES
(3, 'Big Table', 'Natural Oak', '330', '8' );

select * from product

delete from Product where ProductID = 4
INSERT INTO PRODUCT VALUES
(4, 'Small Table', 'Natural Oak', '300', '8' );

INSERT INTO PRODUCT VALUES
(1, 'End table', 'Natural Oak', '300', '8' );

select * from [order]
INSERT INTO [ORDER] VALUES
(1, '01/23/2020', 3);

INSERT INTO [ORDER] VALUES
(2, '01/25/2020', 2);

INSERT INTO [ORDER] VALUES
(3, '02/03/2020', 1);

INSERT INTO ORDERLINE VALUES
(1, 2, '300');

INSERT INTO ORDERLINE VALUES
(2, 3, '500');

INSERT INTO ORDERLINE VALUES
(3, 1, '200');

INSERT INTO [ORDER] VALUES
(1, '01/23/2020', 3);


insert into CustomerMA 
select * from Customer where CustomerState = 'MA'

select *
from dbo.Product
where [ProductStandardPrice] > 275
		  
		  