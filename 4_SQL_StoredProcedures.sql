use employees;

drop procedure if exists emp_avg_salary;
delimiter $$
create procedure emp_avg_salary()
begin
		select round(avg(salary),2) as avg_salaries from salaries;
end$$

delimiter ;

call employees.emp_avg_salary();
call emp_avg_salary();

drop procedure if exists emp_info;
DELIMITER $$

CREATE PROCEDURE emp_info(in p_first_name varchar(255), in p_last_name varchar(255), out p_emp_no integer)
BEGIN
                SELECT
                                e.emp_no
                INTO p_emp_no FROM
                                employees e
                WHERE
                                e.first_name = p_first_name
                                                AND e.last_name = p_last_name;
END$$

DELIMITER ;

select * from employees limit 100;

DELIMITER $$
CREATE FUNCTION emp_info(p_first_name varchar(255), p_last_name varchar(255)) RETURNS decimal(10,2)
DETERMINISTIC NO SQL READS SQL DATA
BEGIN
                DECLARE v_max_from_date date;
    DECLARE v_salary decimal(10,2);
SELECT
    MAX(from_date)
INTO v_max_from_date FROM
    employees e
        JOIN
    salaries s ON e.emp_no = s.emp_no
WHERE
    e.first_name = p_first_name
        AND e.last_name = p_last_name;
SELECT
    s.salary
INTO v_salary FROM
    employees e
        JOIN
    salaries s ON e.emp_no = s.emp_no
WHERE
    e.first_name = p_first_name
        AND e.last_name = p_last_name
        AND s.from_date = v_max_from_date;
                RETURN v_salary;

END$$

DELIMITER ;

SELECT EMP_INFO('Aruna', 'Journel');