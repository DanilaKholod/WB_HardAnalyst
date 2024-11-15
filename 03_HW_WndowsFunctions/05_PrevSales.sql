--Выведите для каждого магазина и товарного направления сумму продаж в рублях за предыдущую дату. Только для магазинов Санкт-Петербурга.
--Столбцы в результирующей таблице:

--DATE_, SHOPNUMBER, CATEGORY, PREV_SALES
select 
    date, 
    ss.shopnumber, 
    g.category,
    SUM(price) as total_sales, -- Рассчитываем сумму продаж по цене (total_sales)
    lag(SUM(price)) over (partition by ss.shopnumber, g.category order by date) as PREV_SALES  -- Получаем сумму продаж за предыдущую дату
from sales ss
join shops s on ss.shopnumber = s.shopnumber
join goods g on g.id_good = ss.id_good
where city = 'СПб' -- Фильтруем результаты по городу 
group by date, ss.shopnumber, g.category
order by date, shopnumber, category 