--Найти клиента с самым долгим временем ожидания между заказом и доставкой. Для этой задачи у вас есть таблицы "Customers", "Orders"
with t as (
	select 
	    c.customer_id,
	    c.name,
	    extract(EPOCH from (TO_TIMESTAMP(o.shipment_date, 'YYYY-MM-DD HH24:MI:SS') - TO_TIMESTAMP(o.order_date, 'YYYY-MM-DD HH24:MI:SS'))) as waiting_time_seconds -- Расчёт секунд между временем заказа и его доставки
	from 
	    customers_new c
	join 
	    orders_new as o on c.customer_id = o.customer_id
	where o.order_status = 'Approved' -- Нужны только доставленные заказы
)
select customer_id, name -- Вывод только имени и id
from t
where waiting_time_seconds = (select MAX(waiting_time_seconds) from t)
