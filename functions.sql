create or replace function show_information() returns table (id integer, product_name varchar(255),
						product_type varchar(255), release_date date, product_price integer, creator varchar(255), 
						provider varchar(255), country varchar(255)) as $$
begin
return query
SELECT product.id, product.type_of_product, product.name, product.release_date, 
product.price, creator.name,provider.name, country.country from product, creator,
provider, country where (product.provider_id=provider.id and product.creator_id=creator.id
						 and creator.country_id=country.id);
return;
end; $$ language 'plpgsql';

select * from show_information();
 
 
create or replace function sort_by_date() returns table (id integer, product_name varchar(255), price integer,
														 release_date date) as $$
begin
return query
select product.id, product.name, product.price, product.release_date from product order by product.release_date;
end; $$ language 'plpgsql';

 select * from sort_by_date();
 
 create or replace function sort_by_name() returns table (id integer, product_name varchar(255), price integer, release_date date) as $$
begin
return query
select product.id, product.name, product.price, product.release_date from product order by product.name;
end; $$ language 'plpgsql';

select * from sort_by_name();

create or replace function sort_by_price() returns table (id integer, product_name varchar(255), price integer, release_date date) as $$
begin
return query
select product.id, product.name, product.price, product.release_date from product order by product.price;
end; $$ language 'plpgsql';

select * from sort_by_price();

create or replace function max_price() returns table (id integer, product_name varchar(255),
													  product_type varchar(255), product_price integer) as $$
begin
return query
select product.id, product.name, product.type_of_product, product.price 
from product where product.price=(select max(product.price) from product);
end; $$ language 'plpgsql';

select * from max_price();

create or replace function min_price() returns table (id integer, product_name varchar(255), product_type varchar(255), product_price integer) as $$
begin
return query
select product.id, product.name, product.type_of_product, product.price from product where 
product.price=(select min(product.price) from product);
end; $$ language 'plpgsql';

select * from min_price();

create or replace function avg_price() returns float as $$
begin
return (select avg(product.price) as price from product);
end; $$ language 'plpgsql';

select * from avg_price();


create or replace function search_price_type(integer,integer,varchar(50))
returns table (id integer, type varchar (50), name varchar(50), price integer) as $$
begin
return query
select product.id, product.type_of_product, product.name, product.price  from product
 where (product.price between $1 and $2) and (product.type_of_product=$3);
end; $$ language 'plpgsql';

select * from search_price_type(300,900,'Пляжный');


create or replace function search_price(integer,integer)
returns table (id integer,type varchar (50), product varchar(50), price integer) as $$
begin
return query
select product.id,product.type_of_product, product.name, product.price from product
 where (product.price between $1 and $2);
end; $$ language 'plpgsql';

select * from search_price(300,900);


create or replace function search_creator(varchar(255))
returns table (product_name varchar(255), type_of_product varchar(255), provider_name varchar(255),
			   creator_name varchar(255), price integer)
as $$ begin return query
select product.name, product.type_of_product, provider.name, creator.name, product.price from product
inner join provider on product.provider_id=provider.id
inner join creator on product.creator_id=creator.id
where creator.name=$1
order by product.price;
end; $$ language 'plpgsql';

select * from search_creator('Laete');


create or replace function search_minprice_type(INTEGER)
returns float4 as $$
declare a float4;
begin select
 (select count(product.id) from product  
     where product.price<$1)*100::float4/(select count(product.id) from product )::float4 into a; return a;end;
$$ language 'plpgsql';

select * from search_minprice_type(1000);


create or replace function rel_date(date) returns table (id integer, product_name varchar(255), release_date date) as $$
begin
return query
select product.id, product.name, product.release_date from product where product.release_date=$1;
end; $$ language 'plpgsql';

select * from rel_date('2022-11-20');


create or replace function search_date_creator(date,date,varchar(50)) returns table 
(id integer, name varchar(50), price integer, creator varchar (50)) as $$
begin
return query
select product.id, product.name, product.price, creator.name  from product
inner join creator on creator.id=product.creator_id
inner join sales on sales.id = product.id
 where (sales.date between $1 and $2) and (creator.name=$3);
end; $$ language 'plpgsql';

select * from search_date_creator('2021-12-21','2022-12-21','Venera');


create or replace function search_date(date,date) returns table 
(id integer, name varchar(50), price integer, creator varchar (50)) as $$
begin
return query
select product.id, product.name, product.price, creator.name  from product
inner join creator on creator.id=product.creator_id
inner join sales on sales.id = product.id
 where (sales.date between $1 and $2);
end; $$ language 'plpgsql';

select * from search_date('2021-12-21','2022-12-21');


create or replace function sales_share(date, date)
returns float4
as $$
declare a float4;
begin select
(select count(sales.id) from sales where sales.date>=$1 and sales.date<=$2)*100::float4/(select count(sales.id) from sales)::float4 into a;
return a; end; $$ language 'plpgsql';


 select * from sales_share('2022-06-22','2022-12-22');
 
 
 create or replace function defected_country_provider(varchar(50), varchar(50))
    returns integer
as
$$
declare
    count integer;
begin
    select count(product.name)
    into count
    from product
			inner join creator on creator.id=product.creator_id
             inner join country on creator.country_id = country.id
             inner join provider on provider.id = product.provider_id
    where
      country.country = $1
      and provider.name = $2;
    return count;
end;
$$ language plpgsql;
drop function defected_country_provider(varchar(50), varchar(50));
select * from defected_country_provider('France','Maksim');


create or replace function product_price_percent (integer, integer)
returns float4
as $$
declare a float4;
begin select
 (select count(product.price) from product where product.price>=$1 and product.price<=$2)*100::float4/(select count(product.price) from product)::float4
into a;
return a; end; $$ language 'plpgsql';

select * from product_price_percent(500,1000);


create or replace function search_provider_avg_country(varchar(255), varchar(255))
returns table (id integer, product_name varchar(255), provider varchar(255), price integer,creator varchar(255),country varchar(255), avg_c integer)
language 'plpgsql'
as $$
declare avg_country integer;
begin
select avg(product.price) into avg_country from product
join creator on creator.id=product.creator_id
join country on country.id=creator.country_id
where country.country=$2;
return query
select product.id, product.name, provider.name, product.price, creator.name, country.country, avg_country from product
inner join creator on creator.id=product.creator_id
inner join country on country.id=creator.country_id
inner join provider on provider.id=product.provider_id
where (provider.name=$1 and (product.price > avg_country));
end; $$;


select * from search_provider_avg_country('Jin','Russia');

create or replace function search_provider_after(varchar(255), integer)
returns table (product_name varchar(255), type_of_product varchar(255), provider_name varchar(255), creator_name varchar(255), price integer)
as $$ begin return query
select product.name, product.type_of_product, provider.name, creator.name, product.price from product
inner join provider on product.provider_id=provider.id
inner join creator on product.creator_id=creator.id
where product.price>=$2 and provider.name=$1
order by product.price;
end; $$ language 'plpgsql';
drop FUNCTION search_provider_before(varchar(255), integer);
select * from search_provider_after('Maksim',1000);


create or replace function avg_interval(date,date) returns float4 as $$
begin
return (
select avg(price) from product
inner join sales on sales.product_id=product.id
where sales.date between $1 and $2);
end; $$ language 'plpgsql';

select * from avg_interval('2022-06-20','2022-12-20');


create or replace function after_avg_creator(varchar(255))
returns table (id integer, name_of_product varchar(255),creator varchar(255), price integer, avg integer)
language 'plpgsql' as $$
declare
avg_c integer;
begin
select avg(product.price) into avg_c from product
join creator on creator.id = product.creator_id
where creator.name = $1;
return query
select product.id, product.name, creator.name, product.price, avg_c from product
join creator on creator.id = product.creator_id
where product.price > avg_c;
end $$;

select * from after_avg_creator('Savage');



create or replace function search_count_month()
returns integer as $$
declare a integer;
begin select
 sum(sales.count) from sales where (sales.date between now()- interval'1 month' and now())
 into a; return a;end;
$$ language 'plpgsql';

select * from search_count_month();


create or replace function search_count_kvartal()
returns integer as $$
declare a integer;
begin select
 sum(sales.count) from sales where (sales.date between now()- interval'3 month' and now())
 into a; return a;end;
$$ language 'plpgsql';

select * from search_count_kvartal();

create or replace function search_count_year()
returns integer as $$
declare a integer;
begin select
 sum(sales.count) from sales where (sales.date between now()- interval'12 month' and now())
 into a; return a;end;
$$ language 'plpgsql';

select * from search_count_year();



create or replace function search_count_month_min_price() 
returns table (id integer, product_name varchar(255), product_type varchar(255), product_price integer) as $$
begin
return query
select product.id, product.name, product.type_of_product, product.price from product
inner join sales on sales.product_id=product.id
where (product.price=(select min(product.price) from product where (product.release_date between now()- interval'1 month' and now())));
end; $$ language 'plpgsql';

select * from search_count_month_min_price();


create or replace function search_count_kvartal_min_price() 
returns table (id integer, product_name varchar(255), product_type varchar(255), product_price integer) as $$
begin
return query
select product.id, product.name, product.type_of_product, product.price from product
inner join sales on sales.product_id=product.id
where (product.price=(select min(product.price) from product where (product.release_date between now()- interval'3 month' and now())));
end; $$ language 'plpgsql';

select * from search_count_kvartal_min_price();
drop FUNCTION search_count_kvartal_min_price();


create or replace function search_count_year_min_price() 
returns table (id integer, product_name varchar(255), product_type varchar(255), product_price integer, date date) as $$
begin
return query
select product.id, product.name, product.type_of_product, product.price, sales.date from product
inner join sales on sales.product_id=product.id
where (product.price=(select min(product.price) from product where (sales.date between now()- interval'12 months' and now())));
end; $$ language 'plpgsql';
select * from search_count_year_min_price();

drop FUNCTION search_count_year_min_price();



create or replace function search_count_month_max_price() 
returns table (id integer, product_name varchar(255), product_type varchar(255), product_price integer) as $$
begin
return query
select product.id, product.name, product.type_of_product, product.price from product
inner join sales on sales.product_id=product.id
where (product.price=(select max(product.price) from product where (sales.date between now()- interval'1 month' and now())));
end; $$ language 'plpgsql';

select * from search_count_month_max_price();


create or replace function search_count_kvartal_max_price() 
returns table (id integer, product_name varchar(255), product_type varchar(255), product_price integer, date date) as $$
begin
return query
select product.id, product.name, product.type_of_product, product.price, sales.date from product
inner join sales on sales.product_id=product.id
where (product.price=(select max(product.price) from product where (sales.date between now()- interval'3 month' and now())));
end; $$ language 'plpgsql';

select * from search_count_kvartal_max_price();
drop FUNCTION search_count_kvartal_max_price();

create or replace function search_count_year_max_price() 
returns table (id integer, product_name varchar(255), product_type varchar(255), product_price integer, date date) as $$
begin
return query
select product.id, product.name, product.type_of_product, product.price, sales.date from product
inner join sales on sales.product_id=product.id
where (product.price=(select max(product.price) from product where (sales.date between now()- interval'12 months' and now())));
end; $$ language 'plpgsql';
select * from search_count_year_max_price();


create or replace function search_month_avg_price() 
returns float as $$
begin
return (select avg(product.price) as price from product
		inner join sales on sales.product_id=product.id
		where (sales.date between now()- interval'1 month' and now()) );
end; $$ language 'plpgsql';

select * from search_month_avg_price();


create or replace function search_kvartal_avg_price() 
returns float as $$
begin
return (select avg(product.price) as price from product
		inner join sales on sales.product_id=product.id
		where (sales.date between now()- interval'3 months' and now()) );
end; $$ language 'plpgsql';

select * from search_kvartal_avg_price();


create or replace function search_year_avg_price() 
returns float as $$
begin
return (select avg(product.price) as price from product
		inner join sales on sales.product_id=product.id
		where (sales.date between now()- interval'12 months' and now()) );
end; $$ language 'plpgsql';
select * from search_year_avg_price();


create or replace function most_popular_products()
returns table (product_name varchar(255), type_of_product varchar(255), provider_name varchar(255), creator_name varchar(255), price integer, count integer)
as $$ begin return query
select product.name, product.type_of_product, provider.name, creator.name, product.price ,sales.count from product
inner join provider on product.provider_id=provider.id
inner join creator on product.creator_id=creator.id
inner join sales on sales.product_id=product.id
where sales.count=(select max(sales.count) from sales)
order by product.price;
end; $$ language 'plpgsql';

select * from most_popular_products();


