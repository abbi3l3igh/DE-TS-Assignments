-- Set up DB
USE retail_db;
GO

SELECT * FROM customers;
SELECT * FROM categories;
SELECT * FROM departments;
SELECT * FROM order_items;
SELECT * FROM orders;
SELECT * FROM products;

-- Exercise 1 - Customer Order Count
SELECT customer_id, customer_fname, customer_lname,
(SELECT count(1) AS customer_order_count FROM orders o WHERE c.customer_id = o.order_customer_id ) AS customer_order_count
FROM customers c, orders o
WHERE (order_date >= DATEFROMPARTS(2014,01,01) AND DATEFROMPARTS(2014,02,02) > order_date) 
GROUP BY customer_id, customer_fname, customer_lname
ORDER BY customer_id asc;

-- Exercise 2 - Dormant Customers
SELECT DISTINCT c.*
FROM customers c, orders o
WHERE c.customer_id = o.order_customer_id AND FORMAT(o.order_date, 'yyyy-MM-dd') NOT LIKE '2014-01%'
ORDER BY customer_id asc;

-- Exercise 3 - Revenue Per Customer 
	-- TODO: If there are no orders placed by customer, then the corresponding revenue for a give customer should be 0.
SELECT c.customer_id, c.customer_fname [customer_first_name], customer_lname [customer_last_name], 
				SUM(order_item_subtotal) [customer_revenue]
FROM customers c, orders o, order_items oi
WHERE c.customer_id = o.order_customer_id 
	AND oi.order_item_order_id = o.order_id
	AND (o.order_status like 'COMPLETE%' OR o.order_status like 'CLOSED%')
	AND FORMAT(o.order_date, 'yyyy-MM-dd') LIKE '2014-01%'
GROUP BY customer_id, c.customer_fname, customer_lname
ORDER BY customer_revenue desc, customer_id asc;

-- Exercise 4 - Revenue Per Category
SELECT c.*, SUM(order_item_subtotal) category_revenue
FROM orders o, order_items oi, products p, categories c
WHERE oi.order_item_order_id = o.order_id 
	AND oi.order_item_product_id = p.product_id
	AND p.product_category_id = c.category_id
	AND (o.order_status like 'COMPLETE%' OR o.order_status like 'CLOSED%')
	AND FORMAT(o.order_date, 'yyyy-MM-dd') LIKE '2014-01%'
GROUP BY c.category_id, c.category_department_id, c.category_name
ORDER BY category_id asc;

SELECT * FROM products
WHERE product_category_id = 1;

-- Exercise 5 - Product Count Per Department
SELECT d.*, COUNT(product_id) product_count
FROM products p, categories c, departments d
WHERE p.product_category_id = c.category_id
	AND c.category_department_id = d.department_id
GROUP BY d.department_id, d.department_name
ORDER BY department_id asc;

SELECT * FROM categories
WHERE category_department_id = 1;