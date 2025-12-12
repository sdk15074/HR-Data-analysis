
-- **************total employees 
 
  select  count(employee_id) as Total_employees from employee_data;   
  
  -- total active employee
select count(*) as total_employee from employee_data 
where status = "Active";
 
 --  **************Count of Employees by Department
 
select departments_data.department_name, count(employee_data.employee_id) as total_employees
from employee_data
join departments_data on employee_data.department_id = departments_data.department_id
group by departments_data.department_name;

-- Monthly Payroll Calculation

select sum(salary) as total_salary
from employee_data
where status = "active";


-- total attrition by gender 
select gender,count(*) as total_employee from employee_data 
where status = "resigned"
group by gender;
  
-- Attrition Rate

SELECT 
    ROUND((SELECT 
                    COUNT(*) AS total_employee
                FROM
                    employee_data
                WHERE
                    status = 'resigned') / COUNT(*) * 100,
            2) AS attrition_rate
FROM
    employee_data;
    

-- Attendance – Late Employees

select employee_data.first_name,
       employee_data.last_name,
       attendence_data.date,
       attendence_data.check_in
from attendence_data
join employee_data on employee_data.employee_id = attendence_data.employee_id
where check_in > "09:30:00";

-- Performance – Top Performers
select employee_data.first_name,
	   employee_data.last_name,
       performance.rating
from performance 
join employee_data on  performance.employee_id = employee_data.employee_id
where rating = "5"
limit 5; 

-- Salary Increment Log (With Window Function)

select salary_history.employee_id,
	   salary_history.old_salary,
       salary_history.new_salary,
       salary_history.updated_at,
       new_salary - old_salary  as increment_amount,
       round((new_salary - old_salary)/old_salary *100,2) as increment_percentage
from salary_history;      

-- Working Hours Calculation
select attendence_data.employee_id,
       attendence_data.date,
       timestampdiff(hour,check_in,check_out) as working_hour
from attendence_data;  

 -- Update Salary History Automatically(creating a trigger)
 delimiter $$
 create trigger update_salary_history
 after update on  employee_data
 for each row
 begin
     if new.salary <> old.salary then
        insert into salary_history (employee_id, old_salary,new_salary,updated_at)
		values (old.employee_id,old.salary,new.salary,now());
     end if;
end$$    
delimiter ;
SET SQL_SAFE_UPDATES = 0;

update employee_data 
set salary = 79000
where  employee_id = 1;

-- Average Salary per Department
select departments_data.department_name, round(avg(employee_data.salary),1) as average_salary
from employee_data
join departments_data on employee_data.department_id = departments_data.department_id
group by departments_data.department_name
order by average_salary ;

-- Top 10 highest paid employees 

SELECT 
    employee_data.first_name,
    employee_data.last_name,
    MAX(employee_data.salary) AS highest_salary
FROM
    employee_data
GROUP BY employee_data.first_name , employee_data.last_name
ORDER BY highest_salary DESC
LIMIT 10;

-- Late Employees Count
SELECT 
    attendence_data.employee_id, COUNT(*) AS late_days
FROM
    attendence_data
WHERE
    status = 'present'
        AND check_in > '09:30:00'
GROUP BY attendence_data.employee_id
ORDER BY late_days DESC;
 
 -- Average Performance Rating by Department
SELECT 
    departments_data.department_name,
    round(AVG(performance.rating),1) AS average_rating
FROM
    performance
        JOIN
    employee_data ON employee_data.employee_id = performance.employee_id
        JOIN
    departments_data ON departments_data.department_id = employee_data.department_id
GROUP BY departments_data.department_name
ORDER BY average_rating desc;

-- **********************gender distribution ********************************8
SELECT 
    departments_data.department_name,
    employee_data.gender,
    COUNT(*) AS total_count
FROM
    employee_data
        JOIN
    departments_data ON employee_data.department_id = departments_data.department_id
GROUP BY departments_data.department_name , employee_data.gender;

-- total employee according to job role

select employee_data.job_role , count(employee_data.employee_id) as total_employee from employee_data
group by employee_data.job_role;
 
 
SELECT 
    departments_data.department_name,
    MONTHNAME(attendence_data.date) AS month,
    COUNT(CASE
        WHEN attendence_data.status = 'Present' THEN 1
    END) AS total_present,
    COUNT(*) AS total_records
FROM
    attendence_data
        JOIN
    employee_data ON attendence_data.employee_id = employee_data.employee_id
        JOIN
    departments_data ON employee_data.department_id = departments_data.department_id
GROUP BY departments_data.department_name , MONTHNAME(attendence_data.date)
ORDER BY month , departments_data.department_name;

-- **************average rating 

select round(avg(performance.rating),1) as average_rating from performance;

-- total count by jobrole
select job_role,count(*) as total_employee from employee_data 
where status = "resigned"
group by job_role;

select salary,count(*) as total_employee from employee_data 
where status = "resigned"
group by salary;


-- attendence daily trend by depeartment 

select departments_data.department_name,
	   attendence_data.date,
       count(case when attendence_data.status = "present" then 1 end) as total_present,
       count(case when attendence_data.status = "absent" then 1 end) as total_absent 
from attendence_data
join employee_data on employee_data.employee_id = attendence_data.employee_id
join departments_data on departments_data.department_id = employee_data.department_id
group by departments_data.department_name, attendence_data.date
order by departments_data.department_name, attendence_data.date desc;
       
       