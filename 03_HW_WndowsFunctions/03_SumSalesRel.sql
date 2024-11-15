--Отберите за каждую дату долю от суммарных продаж (в рублях на дату). Расчеты проводите только по товарам направления ЧИСТОТА.
--Столбцы в результирующей таблице:

--DATE_, CITY, SUM_SALES_REL
select 
    date, 
    city, 
    ROUND(SUM(price) / SUM(SUM(price)) over (partition by date), 2) AS SUM_SALES_REL
from sales ss
join shops s on ss.shopnumber = s.shopnumber
join goods g on g.id_good = ss.id_good
where  g.category = 'ЧИСТОТА'
group by date, city
order by date, city DESC;