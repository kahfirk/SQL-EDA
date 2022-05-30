-- Creating Uber Database for EDA
CREATE DATABASE uber;
USE uber;

-- Data Definition Language, Creating Restaurant and restaurant-menu table with 
-- database, relation, and attribute constraint.
CREATE TABLE restaurant (
	id INT AUTO_INCREMENT,
    position INT,
    name varchar(255),
    score DECIMAL(2,1),
    ratings INT,
    category varchar(255),
    price_range varchar(4),
    full_address varchar(255),
    zip_code varchar(15),
    lat numeric(11,8),
    lng numeric(12,8),
    PRIMARY KEY(id)
);

ALTER TABLE restaurant
	ADD CONSTRAINT CHK_score CHECK (score>=0 AND score<=5),
	ADD CONSTRAINT CHK_price_range CHECK (price_range in ('$','$$','$$$','$$$$'));

LOAD DATA LOCAL INFILE 'E:/restaurants.csv'
INTO TABLE restaurant 
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(id, position, name, score, ratings, category, price_range, full_address, zip_code, lat, lng);

CREATE TABLE restaurant_menu(
restaurant_id int, 
category varchar (255),
name varchar (255),
description varchar(255),
price Decimal(10,2),
PRIMARY KEY (restaurant_id,name,description),
FOREIGN KEY (restaurant_id) references restaurant(id),
CONSTRAINT CHK_price CHECK (price>0)
);

LOAD DATA LOCAL INFILE 'E:/restaurant-menus.csv'
INTO TABLE restaurant_menu
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(restaurant_id,category,name,description,price);
