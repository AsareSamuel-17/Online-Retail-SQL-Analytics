#Total Number of Customers
SELECT 
	COUNT(*) AS Total_no_Customers
FROM Customers;

# Top 10 customers by spending
SELECT
    c.customer_name,
    SUM(p.price * od.quantity) total_spent
FROM Customers c
JOIN Orders o
ON c.customer_id = o.customer_id
JOIN Order_Details od
ON o.order_id = od.order_id
JOIN Products p
ON od.product_id = p.product_id
GROUP BY c.customer_name
ORDER BY total_spent DESC
LIMIT 10;

#Customers who signed up in 2024.
SELECT *
FROM Customers
WHERE YEAR(signup_date) = 2024;

#Total_Order_date
SELECT
    order_date,
    COUNT(order_id) AS total_orders
FROM Orders
GROUP BY order_date
ORDER BY order_date;


#Orders made in January.
SELECT *
FROM Orders
WHERE order_date >= '2025-01-01'
  AND order_date < '2025-02-01';

#Number of Orders per Month
SELECT
    YEAR(order_date) AS year,
    MONTH(order_date) AS month,
    COUNT(order_id) AS total_orders
FROM Orders
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY year, month;

#Number of Orders per Year
SELECT
    YEAR(order_date) AS year,
    COUNT(order_id) AS total_orders
FROM Orders
GROUP BY YEAR(order_date)
ORDER BY year;

#Average Orders per Day
SELECT
    COUNT(order_id) / COUNT(DISTINCT order_date) AS avg_orders_per_day
FROM Orders;



