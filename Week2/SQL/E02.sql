USE sql_hw;
GO
-- Exercise 1 - Create Table
CREATE TABLE courses (
	course_id INT IDENTITY PRIMARY KEY,
	course_name VARCHAR(60) NOT NULL,
	course_author VARCHAR(40) NOT NULL,
	course_status VARCHAR(9) CHECK(course_status = 'published' OR course_status = 'draft' OR course_status = 'inactive'),
	course_published_dt DATE
);


-- Exercise 2 - Inserting Data

-- Rows with all data values
INSERT INTO courses
    (course_name, course_author, course_status, course_published_dt)
VALUES
    ('Programming using Python', 'Bob Dillon', 'published', DATEFROMPARTS(2020,09,30)),
    ('Data Engineering using Python', 'Bob Dillon', 'published', DATEFROMPARTS(2020,07,15)),
    ('Programming using Scala', 'Elvis Presley', 'published', DATEFROMPARTS(2020,05,12)),
	('Programming using Java', 'Mike Jack', 'inactive', DATEFROMPARTS(2020,08,10)),
	('Web Applications - Python Flask', 'Bob Dillon', 'inactive', DATEFROMPARTS(2020,07,20)),
	('Streaming Pipelines - Python', 'Bob Dillon', 'published', DATEFROMPARTS(2020,10,05)),
	('Web Applications - Scala Play', 'Elvis Presley', 'inactive', DATEFROMPARTS(2020,09,30)),
	('Web Applications - Python Django', 'Bob Dillon', 'published', DATEFROMPARTS(2020,06,23)),
	('Server Austomation - Ansible', 'Uncle Sam', 'published', DATEFROMPARTS(2020,07,05));
SELECT * FROM courses;

-- Rows with no date values
INSERT INTO courses
    (course_name, course_author, course_status)
VALUES
    ('Data Engineering using Scala', 'Elvis Presley', 'draft'),
    ('Web Applications - Java Spring', 'Mike Jack', 'draft'),
	('Pipeline Orchestration - Python', 'Bob Dillon', 'draft');
SELECT * FROM courses;


-- Exercise 3 - Updating Data
UPDATE courses
SET
	course_status = 'published',
	course_published_dt = CONVERT(DATE, GETDATE())
WHERE course_status = 'draft' AND (course_name LIKE '%Python%' OR course_name LIKE '%Scala%');

SELECT * FROM courses;


-- Exercise 4 - Deleting Data
DELETE FROM courses WHERE NOT (course_status = 'draft' OR course_status = 'published');
SELECT * FROM courses;

SELECT course_author, count(1) AS course_count
FROM courses
WHERE course_status= 'published'
GROUP BY course_author;