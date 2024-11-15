--Отберите данные по продажам за 2.01.2016. Укажите для каждого магазина его адрес, сумму проданных товаров в штуках, сумму проданных товаров в рублях.
--Столбцы в результирующей таблице:
--SHOPNUMBER , CITY , ADDRESS, SUM_QTY SUM_QTY_PRICE
select distinct shopnumber, city, addres, qty_sum, qty_sum_price
from
(
	select date, ss.shopnumber , city , addres, ss.id_good , price,
	COUNT(ss.id_good) over (partition by ss.shopnumber) as qty_sum,
	SUM(g.price) over (partition by ss.shopnumber) as qty_sum_price
	from sales ss
	join shops s on ss.shopnumber = s.shopnumber
	join goods g on g.id_good = ss.id_good 
	where date = '02-01-2016'::date
) as t
order by shopnumber