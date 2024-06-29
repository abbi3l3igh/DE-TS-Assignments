RESTORE DATABASE hr_db
FROM DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\hr_db.bak'
WITH RECOVERY;

USE hr_db;
GO

SELECT * FROM countries;

-- Exercise 1
WITH employee_avg_wadge AS (
	SELECT
	employee_id,
	department_id, 
	salary, 
	CAST(AVG(salary) OVER (PARTITION BY department_id) AS DECIMAL(18, 2)) avg_dept_salary
	FROM employees
)
SELECT eaw.employee_id, department_name, eaw.salary, eaw.avg_dept_salary
FROM employee_avg_wadge eaw, departments d
WHERE eaw.salary > eaw.avg_dept_salary AND eaw.department_id = d.department_id
ORDER BY eaw.department_id ASC, eaw.salary DESC;

-- Exercise 2
	-- TODO: FIX CUM SAL Col
		-- Figure out what he wants
WITH employee_avg_wadge AS (
	SELECT
	employee_id,
	department_id, 
	salary, 
	CAST(SUM(salary) OVER (PARTITION BY department_id) AS DECIMAL(18, 2)) cum_salary_expense
	FROM employees
)
SELECT eaw.employee_id, department_name, eaw.salary, eaw.cum_salary_expense
FROM employee_avg_wadge eaw, departments d
WHERE eaw.department_id IN (60, 100)
	AND eaw.department_id = d.department_id
ORDER BY eaw.department_id DESC, eaw.salary ASC;

-- Exercise 3
WITH nq AS (
	SELECT 
	employee_id,
	first_name,
	last_name,
	department_id,
	salary,
	dense_rank() OVER(
		PARTITION BY department_id
		ORDER BY salary DESC
		) employee_rank
FROM employees
) 
SELECT nq.employee_id, nq.department_id, d.department_id, nq.salary, nq.employee_rank
FROM nq , departments d
WHERE nq.employee_rank <= 3 AND nq.department_id = d.department_id

-- Exercise 4
-- TODO: fix grouping of sums and ranking
USE retail_db;
GO
WITH nq AS (
	SELECT 
		order_item_product_id,
		CAST(SUM(order_item_subtotal) AS DECIMAL(18, 2))[revenue]
	FROM order_items oi, orders o
	WHERE oi.order_item_order_id = o.order_id AND
		FORMAT(o.order_date, 'yyyy-MM') = '2014-01'
		AND (o.order_status LIKE 'COMPLETE%' OR order_status LIKE 'CLOSED%')
	GROUP BY order_item_product_id, order_item_subtotal
	--ORDER BY revenue DESC

) 
SELECT TOP 3 nq.order_item_product_id [product_id], p.product_name, nq.revenue, rank() OVER(PARTITION BY product_id ORDER BY revenue) [product_rank]
FROM nq , products p
WHERE nq.order_item_product_id = p.product_id
ORDER BY nq.revenue DESC

-- Exercise 5
WITH nq AS (
	SELECT 
	product_id,
	product_category_id,
	product_name,
	department_id,
	dense_rank() OVER(
		PARTITION BY department_id
		ORDER BY salary DESC
		) employee_rank
FROM products
) 
SELECT nq.employee_id, nq.department_id, d.department_id, nq.salary, nq.employee_rank
FROM nq , departments d
WHERE nq.employee_rank <= 3 AND nq.department_id = d.department_id