
-- I'm curious how many cheap and expensive meal base on price_range attribute
-- This query will provide price_range and total_restaurant with the same price range

select price_range,count(*) as Total_Restaurant from restaurant 
group by price_range 
order by price_range desc;

-- How is uber determine price range ? I want to see max average for each price range 
-- the price attribute come from each restaurant. if we know the boundaries for each price range, we can fill the null value for each restaurant 

select price_range,max(avg_price) from (select restaurant_id,avg(price) as avg_price from restaurant_menu 
group by restaurant_id) as a
INNER JOIN restaurant as r
ON a.restaurant_id = r.id
GROUP BY price_range;

-- well looks like uber have some propblem with their price range, because the price range is looking like this 
-- $	95.621286
-- NULL	96.714286
-- $$	79.384615
-- $$$	32.012222
-- $$$$	12.912188

-- we will check if our assumption was wrong and the price is not based on average 
-- but base on highest price in menu. 

select price_range, max(price) from restaurant_menu as rm
inner join restaurant as r 
ON r.id = rm.restaurant_id 
GROUP BY price_range ORDER BY max(price) DESC;

-- output
-- $	1099.99
-- $$	368.00
-- NULL	266.39
-- $$$	164.99
-- $$$$	99.99

-- show table before update 
select r.id,r.name,price_range,avg_price from (select restaurant_id as id, avg(price) as avg_price from restaurant_menu group by restaurant_id) as ra
inner join restaurant as r on r.id = ra.id  ORDER BY r.id ; 

-- Ok, now this is really messed up. we have to change all the standard for price range 
-- we will determine for each average price $ <=10 dollar), $$ (<=25 dollar), $$$ (<=50 dollar), $$$ (>50 dollar)

UPDATE restaurant  r
inner join ( select restaurant_id as id, avg(price) as avg_price from restaurant_menu group by restaurant_id )  as ra
on ra.id = r.id
SET price_range = CASE WHEN avg_price <= 10 and avg_price >=0 then'$' WHEN avg_price <= 25 and avg_price > 10 then '$$' 
WHEN avg_price <= 50 and avg_price > 25 then'$$$' ELSE '$$$$' END ;

-- in workbench you need to set SET SQL_SAFE_UPDATES = 0;
-- yeah, i think my code is not very efficient but it did the job

-- show new table after update

select r.id,r.name,price_range,avg_price from (select restaurant_id as id, avg(price) as avg_price from restaurant_menu group by restaurant_id) as ra
inner join restaurant as r on r.id = ra.id  ORDER BY r.id ; 

-- =======================================================================================================================================================
-- There is different price point in menu, but the only difference is on description attribue.
-- SO this query will filter name of the dish of a restaurant with the same name and restaurant but different price point 

ALTER TABLE restaurant
DROP CONSTRAINT CHK_price_range;
select rm1.restaurant_id, rm1.name,rm1.description as description1,rm1.price as price1 ,rm2.description as description2, rm2.price as price2 from restaurant_menu as rm1
inner join restaurant_menu as rm2
ON rm1.restaurant_id = rm2.restaurant_id and rm1.name = rm2.name
where rm1.price != rm2.price 
GROUP BY rm1.restaurant_id,rm1.name;

