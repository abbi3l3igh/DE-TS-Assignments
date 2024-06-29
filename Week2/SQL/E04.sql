 /*

Here are the steps you need to perform to take care of this exercise.
  * Create tables
DONE
  * Load data
DONE
  * All the tables have surrogate primary keys. Here are the details.
    * orders.order_id
    * order_items.order_item_id
    * customers.customer_id
    * products.product_id
    * categories.category_id
    * departments.department_id
DONE
  * Get the maximum value from all surrogate primary key fields.
  * Create sequences for all surrogate primary key fields using maximum value. Make sure to use standard naming conventions for sequences.
  * Ensure sequences are mapped to the surrogate primary key fields.
  * Create foreign key constraints based up on this information.
    * orders.order_customer_id to customers.customer_id
    * order_items.order_item_order_id to orders.order_id
    * order_items.order_item_product_id to products.product_id
    * products.product_category_id to categories.category_id
    * categories.category_department_id to departments.department_id
  * Insert few records in `departments` to ensure that sequence generated numbers are used for `department_id`.
* Here are the commands to launch `psql` and run scripts to create tables as well as load data into tables.

*/
psql -U retail_user \
  -h localhost \
  -p 5432 \
  -d retail_db \
  -W
-- Exercise 1
SELECT MAX(order_id) FROM orders;
SELECT MAX(order_item_id) FROM order_items;
SELECT MAX(customer_id) FROM customers;
SELECT MAX(product_id) FROM products;
SELECT MAX(category_id) FROM categories;
SELECT MAX(department_id) FROM departments;
-- TODO: WHAT?!?!?

-- Exercise 2
ALTER TABLE orders
ADD CONSTRAINT FK_OrdCustId
FOREIGN KEY (order_customer_id) REFERENCES customers(customer_id);

ALTER TABLE order_items
ADD CONSTRAINT FK_OIOrdId
FOREIGN KEY (order_item_order_id) REFERENCES orders(order_id);

ALTER TABLE order_items
ADD CONSTRAINT FK_OIProdId
FOREIGN KEY (order_item_product_id) REFERENCES products(product_id);

ALTER TABLE products
ADD CONSTRAINT FK_ProdCat
FOREIGN KEY (product_category_id) REFERENCES categories(category_id);

ALTER TABLE categories
ADD CONSTRAINT FK_CatDep
FOREIGN KEY (category_department_id) REFERENCES departments(department_id);

-- Exercise 3
select chk.definition
-- REPEAT FOR EACH TABLE
from sys.check_constraints chk
inner join sys.columns col
    on chk.parent_object_id = col.object_id
inner join sys.tables st
    on chk.parent_object_id = st.object_id
where 
st.name = 'categories'
and col.column_id = chk.parent_column_id