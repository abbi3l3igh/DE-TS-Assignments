USE retail_db
GO
-- Exercise 1

SELECT * FROM orders;

CREATE PARTITION FUNCTION date_part (datetime)
AS RANGE Right 
FOR VALUES ('2013-08-01','2013-09-01','2013-10-01', '2013-11-01', '2013-12-01',
			'2014-01-01', '2014-02-01', '2014-03-01', '2014-04-01', '2014-05-01', '2014-06-01', '2014-07-01');
GO

CREATE PARTITION SCHEME date_part_scheme
AS PARTITION date_part
ALL TO ('PRIMARY');
GO

CREATE TABLE order_part (
	order_id INT NOT NULL, 
	order_date DATETIME NOT NULL,
	order_customer_id INT NOT NULL,
	order_status VARCHAR(45) NOT NULL,
	PRIMARY KEY (order_id, order_date)
)  
ON date_part_scheme (order_date) ;  
GO

-- Exercise 2
-- TODO COME BACK
INSERT INTO order_part
SELECT * FROM orders;

-- Total entries in order Part
SELECT COUNT(1) [orders]
FROM order_part;

SELECT COUNT(1) OVER (PARTITION BY order_date
	ORDER BY order_date
	ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) [orders]
FROM order_part;
