CREATE DATABASE qa;
USE qa;

CREATE TABLE categories (
  category_id INT IDENTITY NOT NULL,
  category_department_id INT NOT NULL,
  category_name VARCHAR(45) NOT NULL,
  PRIMARY KEY (category_id)
); 

SELECT TOP 10 * FROM categories;

BULK INSERT dbo.categories
FROM 'C:\Users\asmit\SkillStorm\PythonTraining\ProfNotes\20240617-DE-TS-LectureMaterials\SQL\Data\retail_db\data\categories.csv'
WITH (FORMAT='CSV', ROWTERMINATOR = '0x0a', FIRSTROW=2) ;

DROP TABLE categories;

CREATE TABLE categories (
  category_id INT IDENTITY NOT NULL,
  category_department_id INT NOT NULL,
  category_name VARCHAR(45) NOT NULL,
  PRIMARY KEY (category_id)
); 

SELECT TOP 10 * FROM categories;