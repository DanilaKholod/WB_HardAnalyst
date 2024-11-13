--Рассчитайте среднюю цену категорий товаров в таблице products, в названиях товаров которых присутствуют слова «hair» или «home». 
--Среднюю цену округлите до двух знаков после запятой. Столбец с полученным значением назовите avg_price
select ROUND(AVG(price), 2) as avg_price, category
from products p 
where name ilike '%hair%' or name ilike '%home%' -- поиск нужных названий товаров
group by category --группировка по категориям