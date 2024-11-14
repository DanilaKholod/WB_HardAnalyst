--Отберите продавцов, зарегистрированных в 2022 году и продающих ровно 2 категории товаров с суммарной выручкой, превышающей 75 000.
--Выведите seller_id данных продавцов, а также столбец category_pair с наименованиями категорий, которые продают данные селлеры.

--Например, если селлер продает товары категорий “Game”, “Fitness”, то для него необходимо вывести пару категорий category_pair с разделителем “-” в алфавитном порядке (т.е. “Game - Fitness”).
--Поля в результирующей таблице: seller_id, category_pair

WITH seller_filter AS ( -- Запрос, который фильтрует нам продавцов, которые зарегистрировались в 2022 году и выводят их вырочку за каждую категорию
    SELECT
        seller_id,
        category,
        SUM(revenue) AS total_revenue
    FROM
        sellers
    WHERE
        EXTRACT(YEAR FROM date_reg::date) = 2022
    GROUP BY
        seller_id, category
),
seller_two_categories AS ( -- Запрос, который находит нам id продавцов, которые продают всего 2 категории, суммирует их вырочку и делает массив из них 
    SELECT
        seller_id,
        array_agg(category ORDER BY category) AS categories,
        SUM(total_revenue) AS seller_total_revenue
    FROM
        seller_filter
    GROUP BY
        seller_id
    HAVING
        COUNT(category) = 2
        AND SUM(total_revenue) > 75000
),
t AS ( -- Финальный подзапрос, который склеивает наш массив категорий в строку
    SELECT
        seller_id,
        categories[1] || ' - ' || categories[2] AS category_pair
    FROM
        seller_two_categories
)
SELECT
    seller_id,
    category_pair
FROM
    t