create database Market_Place;
use Market_place;

#--Table 1
#Products_v2
create table products_v2
(product_id int PRIMARY KEY,
Category varchar(100) NULL,
Sub_category varchar(100),
Brand varchar(50) NULL,
Supplier_ID int,
Cost_price decimal(10,2),
MRP decimal(10,2),
weight_kg decimal(10,2) NULL,
Launch_date date);

SET SQL_SAFE_UPDATES = 0;

#--Table 2
Create table payment_fees_v2
(payment_method varchar(100) Primary key,
fee_percentage decimal(10,2),
settlement_days int  NULL);

#--Table 3
Create table orders_v2
(order_id int PRIMARY KEY,
order_date date,
customer_id int,
product_id int,
quantity int,
selling_price decimal(10,2),
order_status varchar(100) NULL,
payment_method varchar(100),
order_channel varchar(100) NULL,
warehouse_id int);

#--Table 4
Create table discounts_v2
(discount_id int primary key,
order_id int,
discount_amount int,
discount_type varchar(100)  NULL,
coupon_code varchar(100)  NULL,
is_stackable varchar(100)  NULL);

#--Table 5
Create table logistics_cost_v2
(logistics_id int primary key,
order_id int,
shipping_cost int,
reverse_shipping_cost int  NULL,
delivery_days int NULL,
delivery_status varchar(100) NULL);

#--Table 6
Create table returns_v2
(return_id int primary key,
order_id int,
return_flag varchar(100),
return_reason varchar(100) NULL,
return_initiated_date date,
refund_mode varchar(100) NULL,
refund_status varchar(100) NULL,
customer_fault_flag varchar(10) NULL);

CREATE TABLE products_v2_backup AS SELECT * FROM products_v2;
CREATE TABLE orders_v2_backup AS SELECT * FROM orders_v2;
CREATE TABLE discounts_v2_backup AS SELECT * FROM discounts_v2;
CREATE TABLE returns_v2_backup AS SELECT * FROM returns_v2;
CREATE TABLE logistics_cost_v2_backup AS SELECT * FROM logistics_cost_v2;
CREATE TABLE payment_fees_v2_backup AS SELECT * FROM payment_fees_v2;

#Replacing empty strings into Unknown
Update products_v2
set category= 'UNKNOWN'
where category='';

Update products_v2
set brand='UNKNOWN'
where brand='';

#Checking Duplicates
SELECT product_id, COUNT(*)
FROM products_v2
GROUP BY product_id
HAVING COUNT(*) > 1;

#Logic error

SELECT COUNT(*)
FROM products_v2
WHERE cost_price <= 0
OR cost_price > mrp;

Delete from discounts_v2
where order_id in 
	(select order_id
     from orders_v2
     where product_id in
       (select product_id
        from products_v2
          where cost_price <=0
          or cost_price>mrp));

delete from returns_v2
      where order_id in
      (select order_id
     from orders_v2
     where product_id in
       (select product_id
        from products_v2
          where cost_price <=0
          or cost_price>mrp));
          
	
 delete from logistics_cost_v2
    where order_id in
      (select order_id
     from orders_v2
     where product_id in
       (select product_id
        from products_v2
          where cost_price <=0
          or cost_price>mrp));

delete from orders_v2          
  where product_id in
       (select product_id
        from products_v2
          where cost_price <=0
          or cost_price>mrp);        
          
 delete from products_v2 
 where cost_price <=0
          or cost_price>mrp; 

SELECT order_id, COUNT(*)
FROM orders_v2
GROUP BY order_id
HAVING COUNT(*) > 1;

SELECT *
FROM orders_v2
WHERE product_id IS NULL;

SELECT count(*)
FROM orders_v2
WHERE product_id NOT IN (
    SELECT product_id
    FROM products_v2);
    
 SET SQL_SAFE_UPDATES = 0;

DELETE FROM discounts_v2
WHERE order_id NOT IN (
    SELECT order_id FROM orders_v2
    WHERE product_id IN (SELECT product_id FROM products_v2)
);

DELETE FROM returns_v2
WHERE order_id NOT IN (
    SELECT order_id FROM orders_v2
    WHERE product_id IN (SELECT product_id FROM products_v2)
);

DELETE FROM logistics_cost_v2
WHERE order_id NOT IN (
    SELECT order_id FROM orders_v2
    WHERE product_id IN (SELECT product_id FROM products_v2)
);

SET SQL_SAFE_UPDATES = 1;

SET SQL_SAFE_UPDATES = 0;

DELETE FROM orders_v2
WHERE product_id NOT IN (
    SELECT product_id FROM products_v2
);

SET SQL_SAFE_UPDATES = 1;

update orders_v2
set order_status= 'UNKNOWN'
where order_status='unknown';

update orders_v2
set payment_method= 'UNKNOWN'
where payment_method='INVALID';

SELECT order_id, COUNT(*)
FROM orders_v2
GROUP BY order_id
HAVING COUNT(*) > 1;

SELECT *
FROM orders_v2
WHERE product_id IS NULL;

SELECT *
FROM orders_v2
WHERE quantity <= 0
OR quantity IS NULL;

DELETE FROM discounts_v2
WHERE order_id IN (
    SELECT order_id
    FROM orders_v2
    WHERE quantity <= 0
    OR quantity IS NULL
);

DELETE FROM returns_v2
WHERE order_id IN (
    SELECT order_id
    FROM orders_v2
    WHERE quantity <= 0
    OR quantity IS NULL
);

DELETE FROM logistics_cost_v2
WHERE order_id IN (
    SELECT order_id
    FROM orders_v2
    WHERE quantity <= 0
    OR quantity IS NULL
);

DELETE FROM orders_v2
WHERE quantity <= 0
OR quantity IS NULL;

SELECT *
FROM orders_v2
WHERE selling_price <= 0
OR selling_price IS NULL;

DELETE FROM discounts_v2
WHERE order_id IN (
    SELECT order_id
    FROM orders_v2
    WHERE selling_price <= 0
    OR selling_price IS NULL
);

DELETE FROM returns_v2
WHERE order_id IN (
    SELECT order_id
    FROM orders_v2
    WHERE selling_price <= 0
    OR selling_price IS NULL
);

DELETE FROM logistics_cost_v2
WHERE order_id IN (
    SELECT order_id
    FROM orders_v2
    WHERE selling_price <= 0
    OR selling_price IS NULL
);

DELETE FROM orders_v2
WHERE selling_price <= 0
OR selling_price IS NULL;

UPDATE orders_v2
SET order_channel = 'UNKNOWN'
WHERE order_channel IS NULL
OR order_channel = '';

INSERT INTO payment_fees_v2
(payment_method, fee_percentage, settlement_days)
VALUES ('UNKNOWN',0,0);

SELECT *
FROM orders_v2
WHERE payment_method NOT IN (
    SELECT payment_method
    FROM payment_fees_v2
);

SELECT discount_id, COUNT(*)
FROM discounts_v2
GROUP BY discount_id
HAVING COUNT(*) > 1;

SELECT *
FROM discounts_v2
WHERE order_id NOT IN (
    SELECT order_id
    FROM orders_v2
);

SELECT *
FROM discounts_v2
WHERE discount_amount < 0;

UPDATE discounts_v2
SET discount_type = 'UNKNOWN'
WHERE discount_type IS NULL
OR discount_type = '';

UPDATE discounts_v2
SET coupon_code = 'UNKNOWN'
WHERE coupon_code IS NULL
OR coupon_code = '';

UPDATE discounts_v2
SET is_stackable = 'UNKNOWN'
WHERE is_stackable IS NULL
OR is_stackable = '';

SELECT logistics_id, COUNT(*)
FROM logistics_cost_v2
GROUP BY logistics_id
HAVING COUNT(*) > 1;

SELECT *
FROM logistics_cost_v2
WHERE order_id NOT IN (
    SELECT order_id
    FROM orders_v2
);

SELECT *
FROM logistics_cost_v2
WHERE shipping_cost < 0;

UPDATE logistics_cost_v2
SET shipping_cost = 0
WHERE shipping_cost < 0;

SELECT *
FROM logistics_cost_v2
WHERE reverse_shipping_cost < 0;

SELECT *
FROM logistics_cost_v2
WHERE delivery_days < 0;

UPDATE logistics_cost_v2
SET delivery_status = 'UNKNOWN'
WHERE delivery_status IS NULL
OR delivery_status = '';

SELECT return_id, COUNT(*)
FROM returns_v2
GROUP BY return_id
HAVING COUNT(*) > 1;

SELECT *
FROM returns_v2
WHERE order_id NOT IN (
    SELECT order_id
    FROM orders_v2
);

UPDATE returns_v2
SET return_reason = 'Unknown'
WHERE return_reason IS NULL
OR return_reason = '';

UPDATE returns_v2
SET return_reason = 'UNKNOWN'
WHERE return_reason = 'Unknown';

UPDATE returns_v2
SET refund_mode = 'UNKNOWN'
WHERE refund_mode IS NULL
OR refund_mode = '';

UPDATE returns_v2
SET refund_status = 'UNKNOWN'
WHERE refund_status IS NULL
OR refund_status = '';

SELECT *
FROM returns_v2
WHERE return_initiated_date > CURDATE();

SELECT count(*)
FROM returns_v2 r
JOIN orders_v2 o
ON r.order_id = o.order_id
WHERE r.return_initiated_date < o.order_date;

SELECT 
o.order_id,
o.order_date,
r.return_initiated_date
FROM returns_v2 r
JOIN orders_v2 o
ON r.order_id = o.order_id
WHERE r.return_initiated_date < o.order_date
LIMIT 20;

SET SQL_SAFE_UPDATES = 0;

DELETE FROM returns_v2
WHERE return_initiated_date < (
    SELECT order_date 
    FROM orders_v2 
    WHERE orders_v2.order_id = returns_v2.order_id
);

SET SQL_SAFE_UPDATES = 1;

SELECT *
FROM orders_v2
WHERE order_date > CURDATE();

SELECT *
FROM returns_v2
WHERE return_initiated_date > CURDATE();

SELECT *
FROM orders_v2 o
JOIN products_v2 p
ON o.product_id = p.product_id
WHERE o.order_date < p.launch_date;

#Foreign Key constraints

ALTER TABLE orders_v2
ADD CONSTRAINT fk_orders_product
FOREIGN KEY (product_id)
REFERENCES products_v2(product_id);

ALTER TABLE orders_v2
ADD CONSTRAINT fk_orders_payment
FOREIGN KEY (payment_method)
REFERENCES payment_fees_v2(payment_method);

ALTER TABLE discounts_v2
ADD CONSTRAINT fk_discounts_order
FOREIGN KEY (order_id)
REFERENCES orders_v2(order_id);

ALTER TABLE logistics_cost_v2
ADD CONSTRAINT fk_logistics_order
FOREIGN KEY (order_id)
REFERENCES orders_v2(order_id);

ALTER TABLE returns_v2
ADD CONSTRAINT fk_returns_order
FOREIGN KEY (order_id)
REFERENCES orders_v2(order_id);

SET SQL_SAFE_UPDATES = 1;

#Task 1
#--Revenue vs Profit Reality

Select 
sum(o.selling_price*o.quantity) as Total_Revenue,
sum(p.cost_price*o.quantity) as Total_Cost,
sum(o.selling_price*o.quantity)-sum(p.cost_price*o.quantity) as Total_Profit
from orders_v2 o
inner join products_v2 p
on p.product_id=o.product_id
where o.order_status in ('Delivered', 'shipped');

SELECT DISTINCT order_status
FROM orders_v2;

#Task 2
#--Category-wise Sales & Profit
Select p.category, sum(o.selling_price*o.quantity) as Total_Revenue, 
sum(p.cost_price*o.quantity) as Total_Cost, 
sum(o.selling_price*o.quantity)-sum(p.cost_price*o.quantity) as Total_Profit, 
(((sum(o.selling_price*o.quantity)-sum(p.cost_price*o.quantity))/sum(o.selling_price*o.quantity))*100) 
as Profit_Margin_Percentage
from ORDERS_V2 o
inner JOIN products_v2 p
on p.product_id=o.product_id
where o.order_status in ('Delivered', 'shipped')
GROUP BY CATEGORY
order by Total_Profit desc;

#Task 3
#--Loss-Making Products
select p.product_id, p.category, p.sub_category, p.brand, sum(o.quantity) as total_quantity,
sum(o.selling_price*o.quantity)-sum(p.cost_price*o.quantity)-sum(ifnull(d.total_discount_amount,0)) as Total_Net_Profit
from products_v2 p
inner join orders_v2 o on p.product_id=o.product_id
Left join (select order_id, sum(discount_amount) as Total_discount_Amount from discounts_v2
		    group by order_id) d
on o.order_id=d.order_id
where o.order_status in ('Delivered', 'shipped') and 
o.order_id NOT IN (Select order_id from returns_v2 where refund_status='Processed')
group by p.product_id, p.category, p.sub_category, p.brand
having Total_Net_profit<0
order by Total_Net_Profit ASC;

#Task 4
#--Discount Usage Overview
select count(distinct d.order_id) as Total_Discounted_orders, 
	   sum(d.discount_amount)as total_discount_amount
from discounts_v2 d
inner join orders_v2 o on o.order_id=d.order_id
where o.order_status in ('Delivered', 'Shipped');

#discount percentage(overall)
select Round(((sum(d.Total_discount_amount_per_order))/ (sum(o.selling_price*o.quantity)))*100,2) as discount_percentage
 from orders_v2 o
 left join (select order_id, sum(discount_amount) as Total_discount_amount_per_order
 from discounts_v2
 group by order_id) d
 on o.order_id=d.order_id
where order_status in ('Delivered', 'Shipped');

select Round((count(distinct d.order_id)) / (count(distinct o.order_id))*100,2) as discount_orders_percentage
from orders_v2 o
 left join (select order_id, sum(discount_amount) as Total_discount_amount_per_order
 from discounts_v2
 group by order_id) d
 on o.order_id=d.order_id
where order_status in ('Delivered', 'Shipped');

#Task 5
#--Payment Method Popularity
select payment_method, count(order_id) as Total_number_of_Orders, 
sum(selling_price*quantity) as Total_sales_value
from orders_v2 
where order_status in ('Delivered', 'Shipped')
group by payment_method
order by Total_number_of_Orders desc;

select count(order_id) from orders_v2 where order_status in ('Delivered', 'Shipped');

#Task 6
#--Discount vs Profit Gap

select
case when d.Total_discount_amount is NUll then "Non-discounted_orders"
	else "Discounted_orders"
    end as Order_type,
count(o.order_id) as Total_orders,
avg((o.selling_price*o.quantity)-(p.cost_price*o.quantity)-ifnull(d.total_discount_amount,0)) as Average_Profit
from orders_v2 o
inner join products_v2 p on p.product_id=o.product_id
left join (select order_id, sum(discount_amount) as Total_discount_amount
 from discounts_v2
 group by order_id)d on d.order_id=o.order_id
where order_status in ('Delivered', 'Shipped')
group by order_type;

#Task 7
#--Return Impact on Revenue

Select count(distinct r.order_id) as Total_returned_orders, 
sum(o.selling_price*o.quantity) as Total_Revenue_lost, 
sum((o.selling_price*o.quantity)-(p.cost_price*o.quantity)) as Total_Profit_lost
from Orders_v2 o
inner join products_v2 p on p.product_id=o.product_id
inner join (select distinct order_id 
from returns_v2
where refund_status='Processed') r on r.order_id=o.order_id
where o.order_status in ('Delivered', 'Shipped');

#Task 8
#--Return Reason Analysis

select r.return_reason,
count(distinct r.order_id) as Count_of_Returns, 
sum(o.selling_price*o.quantity) as Revenue_lost, 
sum((o.selling_price*o.quantity)-(p.cost_price*o.quantity)) as Total_Profit_lost
from Orders_v2 o
inner join products_v2 p on p.product_id=o.product_id
inner join (select distinct order_id, return_reason
from returns_v2
where refund_status='Processed') r on r.order_id=o.order_id
where o.order_status in ('Delivered', 'Shipped')
group by return_reason
order by Revenue_lost desc;

#Task 9
#--Logistics Cost Burden (With product category)
SELECT 
    o.order_id,
    SUM(o.selling_price * o.quantity) as Order_Value,
    l.total_logistics_cost,                               
    ROUND((l.total_logistics_cost /                       
     SUM(o.selling_price * o.quantity)) * 100, 2) as Logistics_Percentage
FROM orders_v2 o
INNER JOIN (
    SELECT order_id,                                      
    SUM(shipping_cost + IFNULL(reverse_shipping_cost,0))            
    as total_logistics_cost                               
    FROM logistics_cost_v2                                
    GROUP BY order_id                                     
) l ON l.order_id = o.order_id                           
where o.order_status in ('DELIVERED','SHIPPED')
GROUP BY o.order_id, l.total_logistics_cost  
HAVING Logistics_Percentage > 20
ORDER BY Logistics_Percentage DESC;

select distinct order_status from orders_v2;

#Task10
#--Payment Fee Leakage

Select o.payment_method, 
round(sum((o.selling_price * o.quantity)*((fee_percentage)/100)),2)as Total_payment_gateway_fee,
sum((o.selling_price*o.quantity)-(p.cost_price*o.quantity)) as Total_Net_Profit,
round(sum((o.selling_price*o.quantity)-(p.cost_price*o.quantity)-((o.selling_price * o.quantity)*((fee_percentage)/100))),2)
as Total_Net_Profit_including_fee_percentage
from  orders_v2 o
inner join products_v2 p on p.product_id=o.product_id
inner join payment_fees_v2 f on f.payment_method=o.payment_method
where order_status in ('DELIVERED','SHIPPED')
group by o.payment_method
order by Total_payment_gateway_fee desc;

#Task 11
#--Revenue Leakage Breakdown
Select o.order_id, 
sum(o.selling_price*o.quantity) as Total_Revenue, 
IFNULL(d.Total_discount_amount,0) AS Total_discount_amount, 
CASE 
WHEN r.order_id IS NOT NULL
THEN sum(o.selling_price * o.quantity)
ELSE 0
END AS Total_return_amount,
ifnull(l.total_logistics_cost,0) as Total_logistics_cost, 
round(sum((o.selling_price * o.quantity)*((fee_percentage)/100)),2)as Total_payment_gateway_fee
from orders_v2 o
left join (select order_id, sum(ifnull(discount_amount,0)) as Total_discount_Amount 
		from discounts_v2
		group by order_id) d on o.order_id=d.order_id
left join (select distinct order_id
from returns_v2
where refund_status='Processed') r on r.order_id=o.order_id
left JOIN (
    SELECT order_id,                                      
    SUM(shipping_cost + IFNULL(reverse_shipping_cost,0))            
    as total_logistics_cost                               
    FROM logistics_cost_v2                                
    GROUP BY order_id                                     
) l ON l.order_id = o.order_id    
inner join payment_fees_v2 f on f.payment_method=o.payment_method
where o.order_status in ('Delivered', 'shipped')
group by d.Total_discount_amount, l.total_logistics_cost ,o.order_id, r.order_id
order by Total_revenue desc;

#Summary to determine the factor that causes the highest leakage overall

WITH s as (Select o.order_id, 
sum(o.selling_price*o.quantity) as Total_Revenue, 
IFNULL(d.Total_discount_amount,0) AS Total_discount_amount, 
CASE 
WHEN r.order_id IS NOT NULL
THEN sum(o.selling_price * o.quantity)
ELSE 0
END AS Total_return_amount,
ifnull(l.total_logistics_cost,0) as Total_logistics_cost, 
round(sum((o.selling_price * o.quantity)*((fee_percentage)/100)),2)as Total_payment_gateway_fee
from orders_v2 o
left join (select order_id, sum(ifnull(discount_amount,0)) as Total_discount_Amount 
		from discounts_v2
		group by order_id) d on o.order_id=d.order_id
left join (select distinct order_id
from returns_v2
where refund_status='Processed') r on r.order_id=o.order_id
left JOIN (
    SELECT order_id,                                      
    SUM(shipping_cost + IFNULL(reverse_shipping_cost,0))            
    as total_logistics_cost                               
    FROM logistics_cost_v2                                
    GROUP BY order_id                                     
) l ON l.order_id = o.order_id    
inner join payment_fees_v2 f on f.payment_method=o.payment_method
where o.order_status in ('Delivered', 'shipped')
group by d.Total_discount_amount, l.total_logistics_cost ,o.order_id, r.order_id
order by Total_revenue desc)
Select sum(s.Total_discount_amount) as Total_discount_Leakage, 
sum(s.Total_return_amount) as Total_return_leakage,
sum(s.Total_logistics_cost) as Total_logistics_leakage,
sum(s.Total_payment_gateway_fee) as Total_payment_gateway_fee_leakage
from s;

#Task 12
#Product Profit Ranking
Select s.product_id, s.category, s.sub_category,s.brand,
sum(s.Total_revenue-
(s.Total_cost
+ 
s.Total_discount_amount
+
s.Total_return_amount
+
s.Total_logistics_cost
+
s.Total_payment_gateway_fee)) 
as Net_Profit_Contribution,
DENSE_RANK() OVER (ORDER BY 
sum(s.Total_revenue-(s.Total_cost+ s.Total_discount_amount+s.Total_return_amount+s.Total_logistics_cost+s.Total_payment_gateway_fee))  DESC) 
AS Product_Rank
from (Select p.product_id, p.category, p.sub_category,p.brand, o.order_id, 
sum(p.cost_price*o.quantity) as Total_cost,
sum(o.selling_price*o.quantity) as Total_Revenue, 
IFNULL(d.Total_discount_amount,0) AS Total_discount_amount, 
CASE 
WHEN r.order_id IS NOT NULL
THEN sum(o.selling_price * o.quantity)
ELSE 0
END AS Total_return_amount,
ifnull(l.total_logistics_cost,0) as Total_logistics_cost, 
round(sum((o.selling_price * o.quantity)*((fee_percentage)/100)),2)as Total_payment_gateway_fee
from orders_v2 o
left join (select order_id, sum(ifnull(discount_amount,0)) as Total_discount_Amount 
		from discounts_v2
		group by order_id) d on o.order_id=d.order_id
left join (select distinct order_id
from returns_v2
where refund_status='Processed') r on r.order_id=o.order_id
inner join products_v2 p on p.product_id=o.product_id
left JOIN (
    SELECT order_id,                                      
    SUM(shipping_cost + IFNULL(reverse_shipping_cost,0))            
    as total_logistics_cost                               
    FROM logistics_cost_v2                                
    GROUP BY order_id                                     
) l ON l.order_id = o.order_id    
inner join payment_fees_v2 f on f.payment_method=o.payment_method
where o.order_status in ('Delivered', 'shipped')
group by p.product_id, p.category, p.sub_category,p.brand,
d.Total_discount_amount, l.total_logistics_cost ,o.order_id, r.order_id)s
group by s.product_id, s.category, s.sub_category,s.brand
order by Net_Profit_Contribution desc;

#Task 13
#Category Margin Stability

With s as (Select p.product_id, p.category, p.sub_category,p.brand, o.order_id, 
sum(p.cost_price*o.quantity) as Total_cost,
sum(o.selling_price*o.quantity) as Total_Revenue, 
IFNULL(d.Total_discount_amount,0) AS Total_discount_amount, 
CASE 
WHEN r.order_id IS NOT NULL
THEN sum(o.selling_price * o.quantity)
ELSE 0
END AS Total_return_amount,
ifnull(l.total_logistics_cost,0) as Total_logistics_cost, 
round(sum((o.selling_price * o.quantity)*((fee_percentage)/100)),2)as Total_payment_gateway_fee
from orders_v2 o
left join (select order_id, sum(ifnull(discount_amount,0)) as Total_discount_Amount 
		from discounts_v2
		group by order_id) d on o.order_id=d.order_id
left join (select distinct order_id
from returns_v2
where refund_status='Processed') r on r.order_id=o.order_id
inner join products_v2 p on p.product_id=o.product_id
left JOIN (
    SELECT order_id,                                      
    SUM(shipping_cost + IFNULL(reverse_shipping_cost,0))            
    as total_logistics_cost                               
    FROM logistics_cost_v2                                
    GROUP BY order_id                                     
) l ON l.order_id = o.order_id    
inner join payment_fees_v2 f on f.payment_method=o.payment_method
where o.order_status in ('Delivered', 'shipped')
group by p.product_id, p.category, p.sub_category,p.brand,
d.Total_discount_amount, l.total_logistics_cost ,o.order_id, r.order_id)
Select s.category, round(stddev(((s.Total_revenue-(
s.Total_cost
+ 
s.Total_discount_amount
+
s.Total_return_amount
+
s.Total_logistics_cost
+
s.Total_payment_gateway_fee
)
)
/
(s.Total_revenue))
*100
),2) 
as Margin_variation
from s
group by s.category
order by Margin_variation desc;


#Task 14
#High-Risk Customers
#Subquery
select round(avg(Customer_Return_Rate),2) AS Marketplace_average
from (Select round((count(distinct r.order_id)/count(distinct o.order_id))*100,2) as Customer_Return_Rate
from orders_v2 o
LEFT join (select distinct order_id 
from returns_v2
where refund_status='Processed')r on r.order_id=o.order_id
WHERE o.order_status IN ('Delivered','Shipped')
group by o.customer_id)m;

#Task 14
#High-Risk Customers
Select o.customer_id, 
round((count(distinct r.order_id)/count(distinct o.order_id))*100,2) as Customer_Return_Rate
from orders_v2 o
LEFT join (select distinct order_id 
from returns_v2
where refund_status='Processed')r on r.order_id=o.order_id
WHERE o.order_status IN ('Delivered','Shipped') 
group by o.customer_id
Having Customer_return_rate>
(select round(avg(Customer_Return_Rate),2) AS Marketplace_average
from (Select round((count(distinct r.order_id)/count(distinct o.order_id))*100,2) as Customer_Return_Rate
from orders_v2 o
LEFT join (select distinct order_id 
from returns_v2
where refund_status='Processed')r on r.order_id=o.order_id
WHERE o.order_status IN ('Delivered','Shipped')
group by o.customer_id)m)
order by Customer_return_rate desc;

#Task 15
#--Executive Profitability Summary
With s as (Select o.order_id, 
sum(o.selling_price*o.quantity) as Total_Revenue, 
SUM(p.cost_price*o.quantity) as Total_Cost,
IFNULL(d.Total_discount_amount,0) AS Total_discount_amount, 
CASE 
WHEN r.order_id IS NOT NULL
THEN sum(o.selling_price * o.quantity)
ELSE 0
END AS Total_return_amount,
ifnull(l.total_logistics_cost,0) as Total_logistics_cost, 
round(sum((o.selling_price * o.quantity)*((fee_percentage)/100)),2)as Total_payment_gateway_fee
from orders_v2 o
INNER JOIN products_v2 p on p.product_id=o.product_id
left join (select order_id, sum(ifnull(discount_amount,0)) as Total_discount_Amount 
		from discounts_v2
		group by order_id) d on o.order_id=d.order_id
left join (select distinct order_id
from returns_v2
where refund_status='Processed') r on r.order_id=o.order_id
left JOIN (
    SELECT order_id,                                      
    SUM(shipping_cost + IFNULL(reverse_shipping_cost,0))            
    as total_logistics_cost                               
    FROM logistics_cost_v2                                
    GROUP BY order_id                                     
) l ON l.order_id = o.order_id    
inner join payment_fees_v2 f on f.payment_method=o.payment_method
where o.order_status in ('Delivered', 'shipped')
group by d.Total_discount_amount, l.total_logistics_cost ,o.order_id, r.order_id)

Select sum(s.Total_revenue) as Total_Sales,
sum(s.Total_revenue-s.Total_cost) as Total_Profit,
sum(s.Total_revenue-(s.Total_cost
+ s.Total_discount_amount
+s.Total_return_amount
+s.Total_logistics_cost
+s.Total_payment_gateway_fee)) 
as Net_Profit,
sum(s.Total_discount_amount) as Total_discounts, 
sum(s.Total_return_amount) as Total_returns_loss,
sum(s.Total_logistics_cost) as Total_logistics_cost,
sum(s.Total_payment_gateway_fee) as Total_payment_fees
from s
Order by Total_Sales desc;


  

