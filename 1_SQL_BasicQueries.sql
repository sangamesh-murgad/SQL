USE employees;
SELECT 
    *
FROM
    employees
WHERE
    first_name = 'Elvis';
    
SELECT 
    *
FROM
    employees
WHERE
    first_name = 'Kellie' AND gender = 'F';
    
SELECT 
    *
FROM
    employees
WHERE
    first_name = 'Kellie'
        OR first_name = 'Aruna';

-- EXTRACT ALL THE FEMALE EMPLOYEES WHOS FIRST NAME BEGINS WITH KELLIE OR ARUNA
SELECT 
    *
FROM
    employees
WHERE
    gender = 'F'
        AND (first_name = 'Kellie'
        OR first_name = 'Aruna');

-- using in operator select all individuals from employees whoes first names is either 'Denis' or 'Elvis'
SELECT 
    *
FROM
    employees
WHERE
    first_name IN ('Denis' , 'Elvis');

-- Extract all records from the employees table, aside from those with employee named 'Mark', 'John' or 'Jacob'
SELECT 
    *
FROM
    employees
WHERE
    first_name NOT IN ('Mark' , 'John', 'Jacob');

-- Working with the 'Employees' table, use the like operator select all individuals whose names start with 'Mark' and last name starting with 'G'
SELECT 
    *
FROM
    employees
WHERE
    first_name LIKE ('Mark%')
        AND last_name LIKE ('G%');

-- Retrive the list of all the employees who have been hired in the year 2000
SELECT 
    *
FROM
    employees
WHERE
    hire_date LIKE ('2000%');

-- Retrive a list of all the employees whose employee number is written with 5 characters, and starts with 1000
SELECT 
    *
FROM
    employees
WHERE
    emp_no LIKE ('1000_');

-- Extract all individuals from employees table whose first name contains 'Jack'
SELECT 
    *
FROM
    employees
WHERE
    first_name LIKE ('%jack%');

-- Once you have done that, extract another list containing the names of employees that do not contain 'jack'
SELECT 
    *
FROM
    employees
WHERE
    first_name NOT LIKE ('%jack%');

-- Select all the information from 'salaries' table regarding cotracts from 66000 to 70000 dollers per year.
SELECT 
    *
FROM
    salaries
WHERE
    salary BETWEEN 66000 AND 70000;

-- Retrieve a list of all employees whose employee number is not between '10004' and '10012'.
SELECT 
    *
FROM
    employees
WHERE
    emp_no NOT BETWEEN 10004 AND 10012;

-- Select the names of all the departments with numbers between 'd003' and 'd006'.
SELECT 
    *
FROM
    departments
WHERE
    dept_no BETWEEN 'd003' AND 'd006';

-- Select the names of all departements whose department number value is not null.
SELECT 
    *
FROM
    departments
WHERE
    dept_no IS NOT NULL;
SELECT 
    *
FROM
    departments
WHERE
    dept_no IS NULL;

-- Retrieve a list with the data about all the female employees who were hired in the year 2000 or after.
SELECT 
    *
FROM
    employees
WHERE
    gender = 'F'
        AND hire_date >= '2000-01-01';

-- Extract a list with all employees salary higher than $150,000 per annum.
SELECT 
    *
FROM
    salaries
WHERE
    salary > 150000;

-- Obtain the list with different hire dates from employees table.
SELECT DISTINCT
    hire_date
FROM
    employees;

-- How many annual contracts with value higher than or equal to $ 100,000 have been registered in the salaries table
SELECT 
    COUNT(*)
FROM
    salaries
WHERE
    salary >= 100000;

-- How many managers do we have in the employees database? use the * symol to solve this excercise
SELECT 
    COUNT(*)
FROM
    dept_manager;

-- Select all data from 'employees' table, ordering it by hire date with descending order and ascending order
SELECT 
    *
FROM
    employees
ORDER BY hire_date DESC;

SELECT 
    *
FROM
    employees
ORDER BY hire_date;

/* Write a query that obtains two columns. The first column must contain annual salaries higher than 80000 dollars. 
The second column, renamed to 'emps_with_same_salary', must show the number of employees contracted with same salary.
Lastly, sort the output by the first column*/

SELECT 
    salary, COUNT(salary) AS 'emps_with_same_salary'
FROM
    salaries
WHERE
    salary > 80000
GROUP BY salary
ORDER BY salary;

SELECT 
    salary, COUNT(emp_no) AS 'emps_with_same_sal'
FROM
    salaries
WHERE
    salary BETWEEN 99000 AND 100000
GROUP BY salary
ORDER BY salary;

-- Select all employees whose average salary is higher than $120,000 per annum
SELECT 
    *, AVG(salary)
FROM
    salaries
WHERE
    salary > 120000
GROUP BY emp_no
ORDER BY emp_no;

SELECT 
    *, AVG(salary) AS 'avg_salary'
FROM
    salaries
GROUP BY emp_no
HAVING AVG(salary) > 120000
order by avg(salary) asc;

SELECT 
    emp_no, AVG(salary) AS 'avg_salary'
FROM
    salaries
GROUP BY emp_no
HAVING AVG(salary) > 120000
ORDER BY AVG(salary) ASC;

-- Select employee numbers of all individuals who have signed more than one contracts after 1st January 2000.
SELECT 
    emp_no
FROM
    dept_emp
WHERE
    from_date > '2001-01-01'
GROUP BY emp_no
HAVING COUNT(from_date) > 1
ORDER BY emp_no;

SELECT 
    emp_no, COUNT(from_date)
FROM
    dept_emp
WHERE
    from_date > '2001-01-01'
GROUP BY emp_no
HAVING COUNT(from_date) > 1;

-- Select the first 100 rows from the dept_emp table.
SELECT 
    *
FROM
    dept_emp
LIMIT 100;

-- select 10 records from titles table
SELECT 
    *
FROM
    titles
LIMIT 10;

insert into employees values (999903, '1977-01-01', 'Petricia', 'smith', 'F', '2001-05-02');

SELECT 
    *
FROM
    employees
ORDER BY emp_no desc
LIMIT 10;

insert into titles (emp_no, title, from_date) values (999903, 'Senior Engineer', '1997-10-01' );
SELECT 
    *
FROM
    titles
ORDER BY emp_no DESC
LIMIT 10;

/* insert informat about the individual employee number 999903 into 'dept_emp' table.
He/She is working for department no 5, and started work on 1st October 1997; His/Her
contract period is for indefinate period of time.*/

Insert into dept_emp 
values (
999903,
 'd005', 
 '1997-10-01', 
 '9999-01-01');
 
 SELECT 
    *
FROM
    dept_emp
ORDER BY emp_no DESC
LIMIT 10;

INSERT INTO departments VALUES ('d010', 'Business Analysis');

DELETE FROM departments
WHERE
    dept_no = 'd010';
commit;
DELETE FROM employees 
WHERE
    emp_no = 999903;
SELECT 
    *
FROM
    dept_emp
WHERE
    emp_no = 999903;

-- how many department are there in employee database
SELECT 
    COUNT(DISTINCT dept_no)
FROM
    dept_emp;

-- what is the amount of money spent on salaries for all contracts starting after the 1st of January 1997.
SELECT 
    SUM(salary)
FROM
    salaries
WHERE
    from_date > '1997-01-01';

-- which is the lowest employee number in the database?
select min(emp_no) from employees;
-- which is the highest employee number in the database?
select max(emp_no) from employees;

-- what is the average salary paid to employees who started after the 1st jan 1997?
select avg(salary) from salaries where from_date > '1997-01-01';

-- round the average amount of money spent on salary for all employees who started after 1st jan 1997 to a precision of cents
select round(avg(salary),2) from salaries where from_date > '1997-01-01';

use employees;

CREATE TABLE departments_dup (
    dept_no CHAR(4) NULL,
    dept_name VARCHAR(40) NULL
);

insert into departments_dup select * from departments;

SELECT 
    *
FROM
    departments_dup
ORDER BY dept_no;

INSERT INTO departments_dup
(
    dept_name
)
VALUES
(
    'Public Relatioins'
);

DELETE FROM departments_dup 
WHERE
    dept_no = 'd002';
 
commit;
 
delete from departments_dup where dept_no = 'd010';
 
insert into departments_dup (dept_no) values ('d010'),('d011');

drop table if exists dept_manager_dup;
CREATE TABLE dept_manager_dup (
    emp_no INT(11) NOT NULL,
    dept_no CHAR(4) NULL,
    from_date DATE NOT NULL,
    to_date DATE NULL
);

insert into dept_manager_dup select * from dept_manager;
select * from dept_manager_dup order by emp_no;
insert into dept_manager_dup (emp_no, from_date) values 
('999904','2017-01-01'),
('999905','2017-01-01'),
('999906','2017-01-01'),
('999907','2017-01-01');
delete from dept_manager_dup where dept_no = 'd001';
insert into departments_dup (dept_name) values('Public Relations');
select * from departments_dup order by dept_no;
delete from departments_dup where dept_no = 'd002';

/* extract a list containing information about all managers' employee number, 
first and the last name, department no and hire_date*/
select t1.emp_no, t1.dept_no, t2.first_name, t2.last_name, t2.hire_date
from dept_manager t1
inner join employees t2 on t1.emp_no = t2.emp_no;

/*
Join the employees and dept_manager tables to return a subset of all the employees 
whose last name is Markovitch. see if the output contains a manager with than name.
*/
SELECT 
    t1.emp_no,
    t1.first_name,
    t1.last_name,
    t2.dept_no,
    t2.from_date
FROM
    employees t1
        JOIN
    dept_manager t2 ON t1.emp_no = t2.emp_no
WHERE
    t1.last_name = 'Markovitch'
ORDER BY t2.dept_no , t1.emp_no DESC;

-- how many male and female managers we have in the employees database?
SELECT 
    t2.gender, COUNT(t2.gender) AS gender_count
FROM
    dept_manager t1
        JOIN
    employees t2 ON t1.emp_no = t2.emp_no
GROUP BY gender;

SELECT
    *
FROM
    (SELECT
        e.emp_no,
            e.first_name,
            e.last_name,
            NULL AS dept_no,
            NULL AS from_date
    FROM
        employees e
    WHERE
        last_name = 'Denis' UNION SELECT
        NULL AS emp_no,
            NULL AS first_name,
            NULL AS last_name,
            dm.dept_no,
            dm.from_date
    FROM
        dept_manager dm) as a
ORDER BY -a.emp_no DESC;

/*
Extract the information about all the department managers who were 
hired between 1st of January 1990 and the 1st of January 1995?
*/
select * from dept_manager where from_date between '1990-01-01' and '1995-01-01';
select t1.* from employees t1 where t1.emp_no in (select emp_no from dept_manager where from_date between '1990-01-01' and '1995-01-01');
select * from dept_manager where emp_no in (select emp_no from employees where hire_date between '1990-01-01' and '1995-01-01');

-- Select the entire information for all the employees whose job title is 'Assistant Engineer'?
SELECT 
    *
FROM
    employees
WHERE
    EXISTS( SELECT 
            *
        FROM
            titles
        WHERE
            employees.emp_no = titles.emp_no
                AND title = 'Assistant Engineer'
                AND from_date > '2000-01-01')
ORDER BY hire_date DESC;

/* Starting your code with DROP TABLE, create a table called 'emp_manager' 
(emp_no - integer of 11, not null, dept_no char of 4; manager_no integer of 11 not null).*/
Drop table if exists emp_manager;
CREATE TABLE emp_manager (
    emp_no INT(11) NOT NULL,
    dept_no CHAR(4) NULL,
    manager_no INT(11) NOT NULL
);
SELECT 
    *
FROM
    emp_manager;

insert into emp_manager 
select u.* from 
	(SELECT 
		a.*
	FROM
		(SELECT 
			t1.emp_no AS emp_no,
				t2.dept_no AS dept_no,
				(SELECT 
						emp_no
					FROM
						dept_manager
					WHERE
						emp_no = 110022) AS manager_no
		FROM
			employees t1
		JOIN dept_emp t2 ON t1.emp_no = t2.emp_no
		WHERE
			t1.emp_no <= 10020
		GROUP BY t1.emp_no
		ORDER BY t1.emp_no) AS a 
	UNION SELECT 
		b.*
	FROM
		(SELECT 
			t1.emp_no AS emp_no,
				t2.dept_no AS dept_no,
				(SELECT 
						emp_no
					FROM
						dept_manager
					WHERE
						emp_no = 110039) AS manager_no
		FROM
			employees t1
		JOIN dept_emp t2 ON t1.emp_no = t2.emp_no
		WHERE
			t1.emp_no > 10020
		GROUP BY t1.emp_no
		ORDER BY t1.emp_no
		LIMIT 20) AS b 
	UNION SELECT 
		c.*
	FROM
		(SELECT 
			t1.emp_no AS emp_no,
				t2.dept_no AS dept_no,
				(SELECT 
						emp_no
					FROM
						dept_manager
					WHERE
						emp_no = 110039) AS manager_no
		FROM
			employees t1
		JOIN dept_emp t2 ON t1.emp_no = t2.emp_no
		WHERE
			t1.emp_no = 110022
		GROUP BY t1.emp_no
		ORDER BY t1.emp_no) AS c 
	UNION SELECT 
		d.*
	FROM
		(SELECT 
			t1.emp_no AS emp_no,
				t2.dept_no AS dept_no,
				(SELECT 
						emp_no
					FROM
						dept_manager
					WHERE
						emp_no = 110022) AS manager_no
		FROM
			employees t1
		JOIN dept_emp t2 ON t1.emp_no = t2.emp_no
		WHERE
			t1.emp_no = 110039
		GROUP BY t1.emp_no
		ORDER BY t1.emp_no) AS d) as u
;

select * from emp_manager;

CREATE OR REPLACE VIEW v_avg_manager_salary AS
    SELECT 
        t1.emp_no, ROUND(AVG(t1.salary), 2) AS avg_manager_salary
    FROM
        salaries t1
            JOIN
        dept_manager t2 ON t2.emp_no = t1.emp_no
    GROUP BY t2.emp_no
    ORDER BY avg_manager_salary;