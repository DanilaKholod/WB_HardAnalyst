--Найти клиентов, у которых были заказы, доставленные с задержкой более чем на 5 дней, и клиентов, у которых были заказы, которые были отменены. 
--Для каждого клиента вывести имя, количество доставок с задержкой, количество отмененных заказов и их общую сумму. Результат отсортировать по общей 
--сумме заказов в убывающем порядке.
select 
    c.customer_id,
    c.name,
    count(case 
            when to_timestamp(o.shipment_date, 'YYYY-MM-DD HH24:MI:SS') - to_timestamp(o.order_date, 'YYYY-MM-DD HH24:MI:SS') > interval '5 days' 
            then 1 
         end) as delayed_deliveries_count, -- считаем количество заказов, доставленных с задержкой более 5 дней
    count(case 
            when o.order_status = 'Cancel' 
            then 1 
         end) as cancelled_orders_count, -- считаем количество отмененных заказов
    sum(case 
            when o.order_status = 'Cancel' 
            then o.order_ammount 
            else 0 
         end) as total_cancelled_amount -- суммируем общую сумму отмененных заказов
from 
    customers_new c
join 
    orders_new o on c.customer_id = o.customer_id -- объединяем с таблицей заказов по идентификатору клиента
group by
    c.customer_id, c.name
having 
    count(case 
            when to_timestamp(o.shipment_date, 'YYYY-MM-DD HH24:MI:SS') - to_timestamp(o.order_date, 'YYYY-MM-DD HH24:MI:SS') > interval '5 days' 
            then 1 
         end)  > 0 -- фильтруем, если есть хотя бы один заказ с задержкой более 5 дней
    and COUNT(case 
            when o.order_status = 'Cancel' 
            then 1 
         END) > 0 -- и хотя бы один отмененный заказ
order by total_cancelled_amount DESC
