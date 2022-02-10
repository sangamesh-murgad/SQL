drop trigger if exists trig_ins_dept_mng;
delimiter $$
create trigger trig_ins_dept_mng
after insert on dept_manager
for each row
begin
	declare v_curr_salary int;

select max(salary) into v_curr_salary from salaries where emp_no = new.emp_no;

if v_curr_salary is not null then update salaries
	set to_date = sysdate()
where
	emp_no = new.emp_no and to_date = new.to_date;

insert into salaries
	values(new.emp_no, v_curr_salary + 20000, new.from_date, new.to_date);

end if;
end $$

delimiter ;




/*
Similar to the exercises done in the lecture, obtain a result set containing the 
	employee number, 
    first name, and 
    last name of all employees with a number higher than 109990. 
    Create a fourth column in the query, indicating whether this employee is also a manager, 
according to the data provided in the dept_manager table, or a regular employee.
*/

SELECT 
    t1.emp_no,
    t1.first_name,
    t1.last_name,
    CASE
        WHEN t2.emp_no IS NULL THEN 'Manager'
        ELSE 'Employee'
    END AS is_manager
FROM
    employees t1
        LEFT JOIN
    dept_manager t2 ON t1.emp_no = t2.emp_no
WHERE
    t1.emp_no >= 109990;

/*
Extract a dataset containing the following information about the managers: 
employee number, first name, and last name. Add two columns at the end 
	– one showing the difference between the maximum and minimum salary of that employee, and 
    - another one saying whether this salary raise was higher than $30,000 or NOT.
If possible, provide more than one solution.
*/

SELECT 
    t1.emp_no,
    t2.first_name,
    t2.last_name,
    MAX(t3.salary) - MIN(t3.salary) AS Salary_difference,
    CASE
        WHEN MAX(t3.salary) - MIN(t3.salary) > 30000 THEN 'Salary was raised more than $30000'
        ELSE 'Salary was raised less than $30000'
    END AS Salary_raise
FROM
    dept_manager t1
        JOIN
    employees t2 ON t1.emp_no = t2.emp_no
        JOIN
    salaries t3 ON t1.emp_no = t3.emp_no
GROUP BY t1.emp_no;

-- Alternative solution using if() clause in place of Case clause

SELECT 
    t1.emp_no,
    t2.first_name,
    t2.last_name,
    MAX(t3.salary) - MIN(t3.salary) AS Salary_difference,
    IF(MAX(t3.salary) - MIN(t3.salary) > 30000,
        'salary was raised more than $30000',
        'salary was raised less than $30000') AS Salary_raise
FROM
    dept_manager t1
        JOIN
    employees t2 ON t1.emp_no = t2.emp_no
        JOIN
    salaries t3 ON t1.emp_no = t3.emp_no
GROUP BY t1.emp_no;

/*
Extract the 
		employee number, 
        first name, and 
        last name of the first 100 employees, and 
        add a fourth column, called “current_employee” saying “Is still employed” 
if the employee is still working in the company, or “Not an employee anymore” if they aren’t.
Hint: You’ll need to use data from both the ‘employees’ and the ‘dept_emp’ table to solve this exercise.
*/

SELECT 
    *
FROM
    dept_emp;
SELECT 
    *
FROM
    employees;
SELECT 
    t1.emp_no,
    t1.first_name,
    t1.last_name,
    IF(t2.to_date > SYSDATE(),
        'is still employed',
        'Not an employee anymore') AS current_employee
FROM
    dept_emp t2
        JOIN
    employees t1 ON t2.emp_no = t1.emp_no
GROUP BY t2.emp_no
LIMIT 100;

SELECT 
    t1.emp_no,
    t1.first_name,
    t1.last_name,
    CASE
        WHEN t2.to_date > SYSDATE() THEN 'Is Still Employeed'
        ELSE 'Not an Employee Anymore'
    END AS current_employee
FROM
    employees t1
        JOIN
    dept_emp t2 ON t1.emp_no = t2.emp_no
GROUP BY t1.emp_no
LIMIT 100;


# 10 PRACTICE QUESTIONS TO SOLVE
USE employees;
DROP table departments_dup, dept_manager_dup;

/*
Exercise 1
Find the average salary of the male and female employees in each department.
*/
SELECT 
	t3.dept_name,
    t1.gender,
    ROUND(AVG(t2.salary), 2) AS avg_salary
FROM
    employees t1
        JOIN
    salaries t2 ON t1.emp_no = t2.emp_no
        JOIN
    dept_emp t4 ON t4.emp_no = t2.emp_no
        JOIN
    departments t3 ON t3.dept_no = t4.dept_no
GROUP BY t1.gender, t3.dept_no
order by t3.dept_no;


/*
Exercise 2
Find the lowest department number encountered in the 'dept_emp' table. Then, find the highest department number.
*/

SELECT 
    MIN(dept_no) AS min_dept_number,
    MAX(dept_no) AS max_dept_number
FROM
    dept_emp;
    
    
# Exercise 3
# Obtain a table containing the following three fields for all individuals whose employee number is no greater than 10040:
# - employee number
# - the smallest department number among the departments where an employee has worked in 
# 		-- Hint-(use a subquery to retrieve this value from the 'dept_emp' table)
# - assign  '110022' as 'manager' to all individuals whose employee number is less than or equal to 10020, and 
# 			'110039' to those whose number is between 10021 and 10040 inclusive (use a CASE statement to create the third field).
# If you've worked correctly, you should obtain an output containing 40 rows. 
# Here’s the top part of the output.

SELECT 
    t1.emp_no,
    t1.low_dept,
    CASE
        WHEN t1.emp_no <= 10020 THEN 11002
        ELSE 110039
    END AS manager
FROM
    (SELECT 
        emp_no, MIN(dept_no) AS low_dept
    FROM
        dept_emp
    WHERE
        emp_no <= 10040
    GROUP BY emp_no) t1
GROUP BY t1.emp_no;

SELECT 
    e.emp_no,
    (SELECT 
            MIN(de.dept_no) AS low_dept
        FROM
            dept_emp de
        WHERE
            e.emp_no = de.emp_no) AS dept,
    CASE
        WHEN e.emp_no <= 10020 THEN 11002
        ELSE 110039
    END AS manager
FROM
    employees e
WHERE
    e.emp_no <= 10040;
    
/*
Exercise 4
Retrieve a list of all employees that have been hired in 2000.
*/

SELECT 
    *
FROM
    employees
WHERE
    YEAR(hire_date) = 2000;
    
/*
Exercise 5
Retrieve a list of all employees from the ‘titles’ table who are engineers.
Repeat the exercise, this time retrieving a list of all employees from the ‘titles’ table who are senior engineers.
After LIKE, you could indicate what you are looking for with or without using parentheses. 
Both options are correct and will deliver the same output. We think using parentheses 
is better for legibility and that’s why it is the first option we’ve suggested.
*/

select * from titles where title = 'Engineer' and to_date > sysdate();
select distinct title from titles;
select * from titles where title in ('Senior Engineer', 'Engineer', 'Assistant Engineer');
select * from titles where title like ('%Engineer%');
select e.emp_no, e.first_name, e.last_name, t.title from employees e join titles t on e.emp_no = t.emp_no where t.title = 'Engineer';

select * from titles where title like ('Senior engineer');
select * from titles where title in ('senior engineer');
select * from titles where title = 'senior engineer';

/*
Exercise 6
Create a procedure that asks you to insert an employee number and that will obtain an 
output containing the same number, as well as the number and name of the last department the employee has worked in.
Finally, call the procedure for employee number 10010.
If you've worked correctly, you should see that employee number 10010 has worked for department number 6 - "Quality Management".
*/

Drop procedure if exists emp_last_dept;

delimiter $$
create procedure emp_last_dept(in p_emp_no integer)
begin
	select e.emp_no, de.dept_no, d.dept_name
    from employees e join dept_emp de on e.emp_no = de.emp_no join departments d on de.dept_no = d.dept_no
    where de.emp_no = p_emp_no and de.from_date = (select max(from_date) from dept_emp where emp_no = p_emp_no) 
    group by de.emp_no order by to_date desc;
end $$

delimiter ;

call emp_last_dept(10010);
-- Alternate querry
select de.emp_no, de.dept_no, d.dept_name from dept_emp de join departments d on d.dept_no = de.dept_no
where emp_no = 10010 and de.from_date = (select max(from_date) from dept_emp where emp_no = 10010) group by emp_no;

/*
Exercise 7
How many contracts have been registered in the ‘salaries’ table with duration of more than one year and 
of value higher than or equal to $100,000?
Hint: You may wish to compare the difference between the start and end date of the salaries contracts.
*/

select 
	count(*)
    from salaries where salary >= 100000 and datediff(to_date,from_date) > 365;
    
select emp_no, from_date, to_date, datediff(to_date,from_date) from salaries;

/*
Exercise 8
Create a trigger that checks if the hire date of an employee is higher than the current date. 
If true, set the hire date to equal the current date. Format the output appropriately (YY-mm-dd).
Extra challenge: You can try to declare a new variable called 'today' which stores today's data, and then use it in your trigger!
After creating the trigger, execute the following code to see if it's working properly.

INSERT employees VALUES ('999904', '1970-01-31', 'John', 'Johnson', 'M', '2025-01-01');  
SELECT 
    *
FROM
    employees
ORDER BY emp_no DESC;
*/
DROP TRIGGER IF EXISTS trig_hdate_higher;
DELIMITER $$
CREATE TRIGGER trig_hdate_higher
BEFORE INSERT ON employees
for each row
begin
DECLARE today DATE;
 SELECT DATE_FORMAT(sysdate(),"%y-%m-%d") INTO today;
IF NEW.hire_date > today THEN
SET NEW.hire_date = today;
end if;
end $$
DELIMITER ;

INSERT employees VALUES ('999904', '1970-01-31', 'John', 'Johnson', 'M', '2025-01-01');  

SELECT 
    *
FROM
    employees
ORDER BY emp_no DESC;

/*
Exercise 9
Define a function that retrieves the largest contract salary value of an employee. Apply it to employee number 11356.
In addition, what is the lowest contract salary value of the same employee? 
You may want to create a new function that to obtain the result.
*/
DROP FUNCTION IF EXISTS f_highest_salary;

DELIMITER $$
CREATE FUNCTION f_highest_salary(p_emp_no INT) RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
	DECLARE v_highest_sal DECIMAL(10,2);
 SELECT MAX(s.salary) INTO v_highest_sal 
	FROM employees e JOIN salaries s ON e.emp_no = s.emp_no 
    WHERE e.emp_no = p_emp_no; 

RETURN v_highest_sal;
END $$
DELIMITER ;

SELECT f_highest_salary(11356);
/*
Exercise 10
Based on the previous exercise, you can now try to create a third function that also accepts a second parameter. 
Let this parameter be a character sequence. Evaluate if its value is 'min' or 'max' and based 
on that retrieve either the lowest or the highest salary, respectively 
(using the same logic and code structure from Exercise 9). 
If the inserted value is any string value different from ‘min’ or ‘max’, 
let the function return the difference between the highest and the lowest salary of that employee.
*/

DROP FUNCTION IF EXISTS f_salary;

DELIMITER $$
CREATE FUNCTION f_salary(p_emp_no INT, p_min_or_max VARCHAR(10)) RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
DECLARE v_sal_info DECIMAL(10,2);
SELECT 
	CASE WHEN p_min_or_max = 'MAX' THEN MAX(s.salary)
		 WHEN p_min_or_max = 'MIN' THEN MIN(s.salary)
         ELSE MAX(s.salary) - MIN(s.salary)
	END AS salary_info
INTO v_sal_info FROM 
	employees e join
    salaries s on e.emp_no = s.emp_no
    WHERE e.emp_no = p_emp_no;
RETURN v_sal_info;

END $$
DELIMITER ;

SELECT f_salary(11356,'min') as min_max_sal;
select employees.f_salary(11356, 'min');
select employees.f_salary(11356, 'max');
select employees.f_salary(11356, 'maxxx');