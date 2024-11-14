--Напишите SQL-запрос, который выполнит следующие задачи:

--1. Вычислит общую сумму продаж для каждой категории продуктов.
--2. Определит категорию продукта с наибольшей общей суммой продаж.
--3. Для каждой категории продуктов, определит продукт с максимальной суммой продаж в этой категории.

-- Подзапрос для вычисления общей суммы продаж для каждой категории продуктов
with category_sales as (
    select 
        p.product_category,
        SUM(o.order_ammount) as total_sales
    from 
        Orders o
    join 
        Products p on o.product_id = p.product_id
    group by
        p.product_category
),
-- Подзапрос для определения cуммы продаж каждого продукта в заказах
product_sales as (
    select 
        p.product_category,
        p.product_name,
        SUM(o.order_ammount) AS product_sales
    from 
        Orders o
    join 
        Products p ON o.product_id = p.product_id
    group by
        p.product_category, p.product_name
),
-- Подзапрос для определения продукта с максимальной суммой продаж в категории
max_product_sales as (
    select 
        ps.product_category,
        MAX(ps.product_sales) AS max_sales
    from 
        product_sales ps
    group by
        ps.product_category
)
-- Основной запрос для объединения результатов
select 
    cs.product_category,
    cs.total_sales,
    ps.product_name,
    ps.product_sales,
    -- Поле, которое решает задачу по выводу категории с максимальными продажами
    (select product_category from category_sales
    where total_sales = (select max(total_sales) from category_sales)) as product_category_max_salse
from 
    category_sales cs
join 
    max_product_sales mps on cs.product_category = mps.product_category
join 
    product_sales ps on mps.product_category = ps.product_category and mps.max_sales = ps.product_sales
order by cs.total_sales desc -- Сортируем по убыванию, чтобы каждая 1 строчка определяла категорию продукта с наибольшей общей суммой продаж
