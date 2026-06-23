#Show Every Order with Customer Name
SELECT
    o.order_id,
    o.order_date,
    c.customer_id,
    c.customer_name
FROM orders o
INNER JOIN customers c
    ON o.customer_id = c.customer_id;
    

#Show Products Purchased in Each Order
SELECT
    o.order_id,
    o.order_date,
    p.product_id,
    p.product_name,
    od.quantity
FROM Orders o
INNER JOIN Order_Details od
    ON o.order_id = od.order_id
INNER JOIN Products p
    ON od.product_id = p.product_id
ORDER BY o.order_id;


#Calculate Revenue per Order
SELECT
    o.order_id,
    SUM(p.price * od.quantity) AS total_revenue
FROM orders o
INNER JOIN order_details od
    ON o.order_id = od.order_id
INNER JOIN products p
    ON od.product_id = p.product_id
GROUP BY o.order_id
ORDER BY total_revenue DESC;

#Top 10 Orders by Revenue
SELECT
    o.order_id,
    SUM(p.price * od.quantity) AS total_revenue
FROM Orders o
INNER JOIN Order_Details od
    ON o.order_id = od.order_id
INNER JOIN Products p
    ON od.product_id = p.product_id
GROUP BY o.order_id
ORDER BY total_revenue DESC
LIMIT 10;


#Lowest Value Orders
SELECT
    o.order_id,
    SUM(p.price * od.quantity) AS total_revenue
FROM Orders o
INNER JOIN Order_Details od
    ON o.order_id = od.order_id
INNER JOIN Products p
    ON od.product_id = p.product_id
GROUP BY o.order_id
ORDER BY total_revenue ASC
LIMIT 10;


#Average Order Value (AOV) , Average revenue generated per order. Using a SUBQUERY approach
SELECT
    ROUND(AVG(order_revenue), 2)AS average_order_value
FROM (
    SELECT
        o.order_id,
        SUM(p.price * od.quantity) AS order_revenue
    FROM Orders o
    INNER JOIN Order_Details od
        ON o.order_id = od.order_id
    INNER JOIN Products p
        ON od.product_id = p.product_id
    GROUP BY o.order_id
) AS order_totals;


# CTE Approach for the AOV
WITH order_totals AS (
    SELECT
        o.order_id,
        SUM(p.price * od.quantity) AS order_revenue
    FROM Orders o
    JOIN Order_Details od ON o.order_id = od.order_id
    JOIN Products p ON od.product_id = p.product_id
    GROUP BY o.order_id
)
SELECT ROUND(AVG(order_revenue), 2) AS average_order_value
FROM order_totals;




#Revenue by Product Category
SELECT
    p.category,
    SUM(p.price * od.quantity) AS total_revenue
FROM Order_Details od
JOIN Products p
    ON od.product_id = p.product_id
GROUP BY p.category
ORDER BY total_revenue DESC;


#Revenue by Country
SELECT
    c.country,
    SUM(p.price * od.quantity) AS total_revenue
FROM Orders o
JOIN Customers c
    ON o.customer_id = c.customer_id
JOIN Order_Details od
    ON o.order_id = od.order_id
JOIN Products p
    ON od.product_id = p.product_id
GROUP BY c.country
ORDER BY total_revenue DESC;

#Revenue by City
SELECT
    c.city,
    SUM(p.price * od.quantity) AS total_revenue
FROM Orders o
JOIN Customers c
    ON o.customer_id = c.customer_id
JOIN Order_Details od
    ON o.order_id = od.order_id
JOIN Products p
    ON od.product_id = p.product_id
GROUP BY c.city
ORDER BY total_revenue DESC;


#Revenue by Product
SELECT
    p.product_name,
    SUM(p.price * od.quantity) AS total_revenue
FROM Order_Details od
JOIN Products p
    ON od.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_revenue DESC;



#Find high-performing products that bring in significant revenue. Products that generated more than $50,000 revenue
SELECT
    p.product_name,
    SUM(p.price * od.quantity) AS total_revenue
FROM Order_Details od
JOIN Products p
    ON od.product_id = p.product_id
GROUP BY p.product_name
HAVING total_revenue > 50000
ORDER BY total_revenue DESC;

#Customers who spent more than average, Find customers who are high-value spenders compared to the overall customer base.

WITH customer_spending AS (
    SELECT
        o.customer_id,
        SUM(p.price * od.quantity) AS total_spent
    FROM Orders o
    JOIN Order_Details od
        ON o.order_id = od.order_id
    JOIN Products p
        ON od.product_id = p.product_id
    GROUP BY o.customer_id
)
SELECT *
FROM customer_spending
WHERE total_spent > (SELECT AVG(total_spent) FROM customer_spending)
ORDER BY total_spent DESC;
