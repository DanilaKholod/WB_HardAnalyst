/*with min_and_max as (
	select industry, MAX(salary) as max_salary, min(salary) as min_salary
	from salary s 
	group by industry
),
employee_max_salary as (
	select first_name as name_highest_salary, salary, s.industry, max_salary, min_salary
	from salary as s
	join min_and_max mm on mm.industry = s.industry
	where salary = max_salary
),
employee_min_salary as (
	select first_name as name_lowest_salary, salary, s.industry, max_salary, min_salary
	from salary as s
	join min_and_max mm on mm.industry = s.industry
	where salary = min_salary
)
select first_name, last_name, s.salary, s.industry, name_highest_salary, name_lowest_salary
from salary s
join employee_max_salary as e on e.industry = s.industry
join employee_min_salary as em on em.industry = s.industry
order by industry*/

select 
    first_name, 
    last_name, 
    salary, 
    industry,
    first_value(first_name) OVER (PARTITION BY industry ORDER BY salary DESC) AS name_highest_salary,
    first_value(first_name) OVER (PARTITION BY industry ORDER BY salary ASC) AS name_lowest_salary
from  salary
order by industry