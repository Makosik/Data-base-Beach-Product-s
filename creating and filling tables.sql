  create table country
 (
	 id int PRIMARY key,
	 country VARCHAR
 );
 
 insert into country VALUES
(1,'Russia'),
(2,'Germany'),
(3,'Italy'),
(4,'France');
 
  create table provider
 (
	 id int PRIMARY key,
	 name VARCHAR
 );
 
 insert into provider VALUES
(1,'Aleksandr'),
(2,'Maksim'),
(3,'Sergei'),
(4,'Liza'),
(5,'Aleksey'),
(6,'Mike'),
(7,'Jin'),
(8,'Luka');
 
 create table creator
 (
	 id int PRIMARY key,
	 name VARCHAR,
	 country_id int REFERENCES country(id)
 );

insert into creator values
(1,'Laete',2),
(2,'Totti',3),
(3,'Lori',1),
(4,'Venera',1),
(5,'Defile',2),
(6,'Savage',3),
(7,'INCITY',4),
(8,'Rossini',4);


create table product
(
	id int PRIMARY key,
	type_of_product VARCHAR,
	name VARCHAR,
	creator_id int REFERENCES creator(id),
	provider_id int REFERENCES provider(id),
	price int,
	release_date date,
	defective int
	);
	
insert into product values
(1,'Пляжный','зонт',1,8,1200,'2022-11-20',2),
(2,'Пляжный','мяч',8,2,1000,'2021-08-12',1),
(3,'Плавательные','очки',7,1,976,'2022-02-22',2),
(4,'Быстросохнущее','полотенце',6,3,1350,'2022-12-20',1),
(5,'Пляжное','полотенце',5,4,900,'2022-01-12',2),
(6,'Питьевая','бутылка',4,5,483,'2022-02-22',1),
(7,'Солнцезащитные','очки',3,6,500,'2022-03-20',2),
(8,'Надувной','круг',2,7,700,'2021-04-12',1),
(9,'Пляжные','тапки',1,8,300,'2022-05-22',1),
(10,'Пляжная','сумка',2,7,1400,'2021-06-20',0),
(11,'Надувной','матрас',3,6,2700,'2022-07-12',0),
(12,'Пляжный','коврик',4,5,879,'2022-08-22',0),
(13,'Пляжный','комплект',5,4,3500,'2022-09-20',2),
(14,'Спортивная','кепка',6,3,700,'2021-10-12',3),
(15,'Спортивная','сумка',7,2,1200,'2022-02-22',2),
(16,'Пляжная','обувь',8,1,770,'2022-12-21',0),
(17,'Плавательные','шорты',4,7,1478,'2022-04-29',2);
	
create table sales
(	
	id int PRIMARY key,
	product_id int REFERENCES product(id),
	date date,
	count int
);
 
insert into sales values
(1,4,'2022-12-21',3),
(2,16,'2022-12-22',4),
(3,1,'2022-11-21',9),
(4,2,'2022-05-20',9),
(5,3,'2022-06-12',3),
(6,6,'2022-11-11',4),
(7,11,'2022-07-21',12),
(8,17,'2022-11-05',7),
(9,14,'2022-01-01',3),
(10,13,'2022-10-22',4),
(11,12,'2022-09-01',11),
(12,15,'2022-05-05',7),
(13,10,'2021-12-21',3),
(14,9,'2022-08-22',4),
(15,8,'2021-08-01',4),
(16,7,'2022-12-15',7),
(17,6,'2022-12-11',1),
(18,15,'2022-12-02',4),
(19,13,'2022-12-01',2),
(20,17,'2022-12-09',5),
(21,1,'2022-12-15',3),
(22,12,'2022-09-22',4),
(23,14,'2021-12-01',8),
(24,9,'2022-06-05',7);

select * from country;
select * from provider;
select * from creator;
select * from product;
select * from sales;

 create table relations as select name,
 surname, city, experience, type_item, date_order, costs, closed,payment_method from staff, orders,city,
 items where orders.fk_id_staff = staff.id_staff and items.id_item = orders.fk_id_item and 
 city.id_city = staff.fk_id_city;

SELECT * from relations








