--Выведите информацию о топ-3 товарах по продажам в штуках в каждом магазине в каждую дату.
--Столбцы в результирующей таблице:

--DATE_ , SHOPNUMBER, ID_GOOD
WITH CumulativeSales AS (
    SELECT 
        ss.date,           
        ss.shopnumber,      
        ss.id_good,           
        COUNT(ss.id_good) AS daily_sales,  -- Считаем количество продаж товаров за день
        -- Рассчитываем накопительное количество проданных товаров
        SUM(COUNT(ss.id_good)) OVER (PARTITION BY ss.shopnumber, ss.id_good ORDER BY ss.date) AS total_sales
    FROM 
        sales ss              
    GROUP BY 
        ss.date, ss.shopnumber, ss.id_good
    ORDER BY 
        ss.date, ss.shopnumber -- Сортируем результаты по дате и номеру магазина 
),
RankedSales AS (
    -- Этот CTE будет использоваться для нумерации товаров
    SELECT 
        date, 
        shopnumber, 
        id_good, 
        total_sales,
        -- Присваиваем ранг товара по количеству продаж для каждой даты и магазина
        ROW_NUMBER() OVER (PARTITION BY date, shopnumber ORDER BY total_sales DESC) AS rank
    FROM 
        CumulativeSales
)
SELECT 
    date, 
    shopnumber, 
    id_good
FROM 
    RankedSales
WHERE 
    rank <= 3 -- Отбираем только топ-3 товара по количеству продаж для каждой даты и магазина
ORDER BY date, shopnumber, rank