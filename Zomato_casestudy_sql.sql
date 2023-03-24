-- Creating Database
Create Database Zomato;

-- Selecting the Database
Use Zomato;

-- Reading Tables
Select * from users ;
Select * from restaurants;
Select * from menu;
Select * from order_details;
Select * from orders;
Select * from food;
Select * from delivery_partner;

-- Counts of rows
Select COUNT(*) from order_details;

-- Finding the null values
Select * from orders where restaurant_rating IS NULL;

-- Find numbers of orders placed by each customers
Select b.name, count(*) as '#order' from orders as a 
join users b 
on a.user_id = b.user_id
group by b.user_id;


-- Find restaurant with most number of menu items
Select r_name, count(*) as 'menu_items' from restaurants as a 
join menu b 
on a.r_id = b.r_id
group by b.r_id;

-- Find number of votes and average rating for all the restaurants
Select r_name,COUNT(*) AS 'num_votes',ROUND(AVG(restaurant_rating),2) AS 'rating' 
from orders as a 
JOIN restaurants b
ON a.r_id = b.r_id
Where restaurant_rating IS NOT NULL
Group by a.r_id;

-- Find the food that is been sold at most number of restaurants
Select f_name,COUNT(*) from menu a
JOIN food b
ON a.f_id = b.f_id
Group by a.f_id
Order by  COUNT(*) Desc Limit 1;

-- Find restaurant with maximum revenue in given month
 -- > May
-- Select MONTHNAME(DATE(date)),date from orders
Select r_name,SUM(amount) AS 'revenue' from orders t1
JOIN restaurants t2
ON t1.r_id = t2.r_id
Where MONTHNAME(DATE(date)) = 'May'
Group by t1.r_id
Order by revenue Desc Limit 1;

-- Find restaurants with sales greater then 1500
Select r_name,SUM(amount) AS 'revenue' from orders a
JOIN restaurants b
ON a.r_id = b.r_id
Group by a.r_id
Having revenue > 1500;

-- Find customers who have never ordered
Select user_id, name from users
EXCEPT
Select a.user_id, name from orders a
JOIN users b 
on a.user_id = b.user_id

-- Show order detail of a perticular customer in a given date range
Select a.order_id,f_name,date from orders a
JOIN order_details b
ON a.order_id = b.order_id
JOIN food c
ON b.f_id = c.f_id
Where user_id = 5 AND date BETWEEN '2022-05-15' AND '2022-07-15';

-- Customer favorite food 
Select a.user_id,c.f_id,COUNT(*) from users a
JOIN orders b
ON a.user_id = b.user_id
JOIN order_details c
ON b.order_id = c.order_id
Group by a.user_id,c.f_id
Order by COUNT(*) DESC;

-- Find the most costly restaurants
-- (Avg price/ Dish)
Select r_name,SUM(price)/COUNT(*) AS 'Avg_price' from menu a
JOIN restaurants b
ON a.r_id = b.r_id
Group by a.r_id
Order by Avg_price ASC Limit 1;

-- Finding Delivery partners compunsation 
-- (# deliveries* 100 +1000*avg_rating)
Select partner_name,COUNT(*) * 100  + AVG(delivery_rating)*1000 AS 'salary'
from orders a
JOIN delivery_partner b
ON a.partner_id = b.partner_id
Group by a.partner_id
Order by salary DESC;

-- Find coorelation between delivery_time and total_rating
Select CORR(delivery_time,delivery_rating) AS 'corr'
from orders;

-- Find all the veg restaurants
Select r_name from menu a
JOIN food b
ON a.f_id = b.f_id
JOIN restaurants c
ON a.r_id = c.r_id
Group BY a.r_id
Having MIN(type) = 'Veg' AND MAX(type) = 'Veg';

-- Find Minimum and Maximum value for all customers
Select name,MIN(amount),MAX(amount),AVG(amount) from orders a
JOIN users b
ON a.user_id = b.user_id
Group by a.user_id