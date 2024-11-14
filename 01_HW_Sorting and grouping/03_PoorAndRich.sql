--Назовем “успешными” (’rich’) селлерами тех: кто продает более одной категории товаров и чья суммарная выручка превышает 50 000
--Остальные селлеры (продают более одной категории, но чья суммарная выручка менее 50 000) будут обозначаться как ‘poor’. 
--Выведите для каждого продавца количество категорий, средний рейтинг его категорий, суммарную выручку, а также метку ‘poor’ или ‘rich’.
SELECT 
    seller_id,
    COUNT(DISTINCT category) AS total_categ,
    ROUND(AVG(rating), 2) AS avg_rating,
    SUM(revenue) AS total_revenue,
    CASE 
        WHEN COUNT(DISTINCT category) > 1 AND SUM(revenue) > 50000 THEN 'rich'
        WHEN COUNT(DISTINCT category) > 1 AND SUM(revenue) < 50000 THEN 'poor'
    END AS seller_type
FROM 
    sellers s
WHERE 
    category != 'Bedding'
GROUP BY 
    seller_id
ORDER BY 
    seller_id

--Здесь также ещё выводится те продавцы, которые не rich и не poor