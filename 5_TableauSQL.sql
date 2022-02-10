use employees_mod;
show tables;
select * from t_departments;
SELECT * FROM t_dept_emp;
SELECT * FROM t_dept_manager;
SELECT * FROM t_employees;
SELECT * FROM t_salaries;


/*
Create a visualization that provides a breakdown between the male and 
female employees working in the company each year, starting from 1990. 
*/

SELECT 
    YEAR(t1.from_date) AS for_year,
    t2.gender,
    COUNT(t2.emp_no) AS no_of_employees
FROM
    t_dept_emp t1
        JOIN
    t_employees t2 ON t1.emp_no = t2.emp_no
GROUP BY t2.gender , for_year
HAVING for_year >= 1990
ORDER BY for_year;

/*
Compare the number of male managers to the number of female managers 
from different departments for each year, starting from 1990.
*/

-- understanding the data from t_dept_manage and t_dept_emp
select t1.emp_no, t1.dept_no, t1.from_date, t1.to_date, year(t3.hire_date) as cal_year, case when t1.to_date <> t2.to_date then 1 else 0 end as diff from t_dept_manager t1 join 
t_dept_emp t2 on t1.emp_no = t2.emp_no cross join t_employees t3 on t2.from_date = t3.hire_date 
where t1.to_date > sysdate() order by t1.emp_no desc;

-- you can use case or if clauses to get our answer, also we can use from_date or hire_date to get the unique set of years.
-- case when t4.cal_year >= year(t2.from_date) and t4.cal_year <= year(t2.to_date) then 1 else 0 end as acting_mgr
SELECT 
    t1.dept_name,
    t2.emp_no,
    t3.gender,
    t2.from_date,
    t2.to_date,
    t4.cal_year,
    IF(t4.cal_year >= YEAR(t2.from_date)
            AND t4.cal_year <= YEAR(t2.to_date),
        1,
        0) AS acting_mgr
FROM
    (SELECT 
        YEAR(hire_date) AS cal_year
    FROM
        t_employees
    GROUP BY cal_year) t4
        CROSS JOIN
    t_dept_manager t2
        JOIN
    t_employees t3 ON t3.emp_no = t2.emp_no
        JOIN
    t_departments t1 ON t2.dept_no = t1.dept_no
ORDER BY t2.emp_no , t4.cal_year;

-- Checking
SELECT 
    YEAR(from_date) AS cal_year
FROM
    t_dept_manager
GROUP BY cal_year
ORDER BY cal_year;
SELECT 
    t1.emp_no, t1.from_date, t2.cal_year
FROM
    t_dept_manager t1
        CROSS JOIN
    (SELECT 
        YEAR(hire_date) AS cal_year
    FROM
        t_employees
    GROUP BY cal_year) t2;


/*
Compare the average salary of female versus male employees in the entire company until year 2002,
and add a filter allowing you to see that per each department.
*/

SELECT 
    t1.gender,
    YEAR(t2.from_date) AS cal_year,
    t3.dept_name,
    round(avg(t4.salary),2) as avg_salary
FROM
    t_employees t1
        JOIN
    t_dept_emp t2 ON t1.emp_no = t2.emp_no
        JOIN
    t_departments t3 ON t2.dept_no = t3.dept_no
        JOIN
    t_salaries t4 ON t1.emp_no = t4.emp_no
    group by t1.gender, cal_year, t3.dept_name
    having cal_year <= 2002 and cal_year >= 1990
    order by t3.dept_name;
    
/*
Create an SQL stored procedure that will allow you to obtain the 
average male and female salary per department within a certain salary range. 
Let this range be defined by two values the user can insert when calling the procedure.

Finally, visualize the obtained result-set in Tableau as a double bar chart. 
*/

drop procedure if exists filter_salary;

delimiter $$
create procedure filter_salary(in p_min_salary float, in p_max_salary float)
begin
select 
	t1.gender,
    round(avg(t2.salary),2) as avg_salary,
    t3.dept_name
from 
	t_employees t1 join
    t_salaries t2 on t1.emp_no = t2.emp_no join
    t_dept_emp t4 on t4.emp_no = t2.emp_no join
	t_departments t3 on t4.dept_no = t3.dept_no
    where t2.salary >= p_min_salary and t2.salary <= p_max_salary
    group by t1.gender, t3.dept_name
    order by t4.dept_no;
end$$
delimiter ;

call filter_salary(50000, 90000);

select * from dept_emp where emp_no <= 10040;