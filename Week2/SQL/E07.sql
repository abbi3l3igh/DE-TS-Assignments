-- Exercise 1 - Simple Subquery
USE retail_db;
GO

SELECT category_name
FROM categories c
JOIN products p ON c.category_id = p.product_category_id
GROUP BY c.category_name
HAVING COUNT(p.product_id) > 5;

-- Exercise 2 - Subquery in WHERE Clause
SELECT * FROM orders
WHERE order_customer_id IN (
	SELECT order_customer_id
	FROM orders 
	GROUP BY order_customer_id 
	HAVING COUNT(*) > 10
)

-- Exercise 3 - Subquery in SELECT Clause
SELECT product_name, CAST(AVG(oi.order_item_subtotal) AS DECIMAL(18, 2))[average_price]
FROM orders o, order_items oi, products p
WHERE FORMAT(order_date, 'yyyy-MM') = '2013-10' AND
		o.order_id = oi.order_item_order_id
GROUP BY product_name;

-- Exercise 4 - Subquery with Aggregate Functions
SELECT * FROM orders WHERE order_id IN (
					SELECT order_item_order_id
					FROM order_items 
					GROUP BY order_item_order_id, order_item_subtotal
					HAVING order_item_subtotal > (SELECT AVG(order_item_subtotal) FROM order_items)
					);

-- Exercise 5 - Basic CTE
WITH number_of_prod AS(
SELECT DISTINCT product_category_id, COUNT(*) [num_products]
FROM products
GROUP BY product_category_id
)
SELECT TOP 3 * FROM number_of_prod ORDER BY num_products DESC;

-- Exercise 6 - nested CTEs
-- TODO: Make nested 
WITH cust_dec AS(
	SELECT order_customer_id
	FROM orders
	WHERE DATEPART(MONTH, order_date) = 12 AND
		order_id IN 
		((SELECT order_item_order_id 
			FROM order_items 
			GROUP BY order_item_order_id, order_item_subtotal 
			HAVING order_item_subtotal > 
				(SELECT AVG(order_item_subtotal) FROM order_items)))
)
SELECT order_customer_id FROM cust_dec;