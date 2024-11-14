--Найти клиентов, сделавших наибольшее количество заказов, и для каждого из них найти среднее время между заказом и доставкой, 
--а также общую сумму всех их заказов. Вывести клиентов в порядке убывания общей суммы заказов.
with t as (
	select customer_id, name, COUNT(order_id) as order_cnt, AVG(diff_time) as avg_delivery_time, SUM(order_ammount) as total_amount -- Находим основные величины
	from (
		select c.customer_id, order_id, name, TO_TIMESTAMP(o.shipment_date, 'YYYY-MM-DD HH24:MI:SS') - TO_TIMESTAMP(o.order_date, 'YYYY-MM-DD HH24:MI:SS') as diff_time, order_ammount
		from customers_new c
		join orders_new o on c.customer_id = o.customer_id
		order by customer_id
	) as t1
	group by customer_id, name
)
select t.customer_id, name, avg_delivery_time, total_amount
from t
where order_cnt = (select max(order_cnt) from t) -- Фильтруем по максимальному числу заказов
order by total_amount desc