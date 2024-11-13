--Для каждого города выведите число покупателей из соответствующей таблицы, 
--сгруппированных по возрастным категориям и отсортированных по убыванию количества покупателей в каждой категории.
select city, age_category, COUNT(*) as user_count
from ( --Создадим подзапрос, где распределим людей по возрастным категориям
	select city, 
	case
		when age <= 20 then 'young'
		when 20 < age  and age < 50 then 'adult'
		when 50 <= age then 'old'
		else 'other'
	end as age_category
	from users u 
) as t1
group by city, age_category --группировка по городам и категориям
order by user_count desc
