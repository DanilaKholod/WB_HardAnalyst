--Для каждого из неуспешных продавцов (из предыдущего задания) посчитайте, сколько полных месяцев прошло с даты регистрации продавца.
--Отсчитывайте от того времени, когда вы выполняете задание. Считайте, что в месяце 30 дней. Например, для 61 дня полных месяцев будет 2.
--Также выведите разницу между максимальным и минимальным сроком доставки среди неуспешных продавцов. Это число должно быть одинаковым для всех неуспешных продавцов.

--Назовите поля: seller_id, month_from_registration ,max_delivery_difference.Выведите ответ по возрастанию id селлера.
--Примечание: Категория “Bedding” по-прежнему не должна учитываться в расчетах.

with seller_type as ( --Подзапрос из предыдущего задания
	SELECT 
    seller_id,
    COUNT(DISTINCT category) AS total_categ,
    AVG(rating) AS avg_rating,
    SUM(revenue) AS total_revenue,
    CASE 
        WHEN COUNT(DISTINCT category) > 1 AND SUM(revenue) > 50000 THEN 'rich'
        WHEN COUNT(DISTINCT category) > 1 AND SUM(revenue) < 50000 THEN 'poor'
    END AS seller_type
	FROM 
	    sellers s 
	WHERE 
	    category != 'Bedding'
	GROUP BY 
	    seller_id
	ORDER BY 
	    seller_id
)
select seller_id,  
	((CURRENT_TIMESTAMP::date - MIN(date_reg::date)) / 30)::int as month_from_registration, 
	(SELECT MAX(delivery_days) FROM sellers -- Подзапрос, который находит максимальное количество дней доставки среди бедных продавцов
     WHERE seller_id IN (select seller_id from seller_type where seller_type = 'poor') AND category != 'Bedding') - 
    (SELECT MIN(delivery_days) FROM sellers -- Подзапрос, который находит минимальное количество дней доставки среди бедных продавцов
     WHERE seller_id IN (select seller_id from seller_type where seller_type = 'poor') AND category != 'Bedding') AS max_delivery_difference
from sellers s
where seller_id in (select seller_id from seller_type where seller_type = 'poor') and category != 'Bedding'
group by seller_id
order by seller_id 

