--Для начала создадим таблицу
DROP TABLE IF EXISTS public.query;
CREATE TABLE public.query (
    searchid SERIAL PRIMARY KEY,
    year INT,
    month INT,
    day INT,
    userid INT,
    ts BIGINT,
    devicetype VARCHAR(50),
    deviceid VARCHAR(50),
    query VARCHAR(255)
);

--Создайте таблицу query (количество строк - порядка 20) с данными о поисковых запросах на маркетплейсе.
--Поля в таблице: searchid, year, month, day, userid, ts, devicetype, deviceid, query. ts- время запроса в формате unix
INSERT INTO public.query (year, month, day, userid, ts, devicetype, deviceid, query)
VALUES
(2023, 11, 16, 1, 1637078400, 'android', 'device1', 'к'),
(2023, 11, 16, 1, 1637078590, 'android', 'device1', 'ку'),
(2023, 11, 16, 1, 1637078600, 'android', 'device1', 'куп'),
(2023, 11, 16, 1, 1637078790, 'android', 'device1', 'купить'),
(2023, 11, 16, 1, 1637078800, 'android', 'device1', 'купить кур'),
(2023, 11, 16, 1, 1637079000, 'android', 'device1', 'купить куртку'),
(2023, 11, 16, 2, 1637078400, 'android', 'device2', 'к'),
(2023, 11, 16, 2, 1637078560, 'android', 'device2', 'ку'),
(2023, 11, 16, 2, 1637078580, 'android', 'device2', 'куп'),
(2023, 11, 16, 2, 1637078690, 'android', 'device2', 'купить'),
(2023, 11, 16, 2, 1637078700, 'android', 'device2', 'купить кур'),
(2023, 11, 16, 2, 1637078790, 'android', 'device2', 'купить куртку'),
(2023, 11, 16, 3, 1637078700, 'android', 'device3', 'купить обувь'),
(2023, 11, 16, 3, 1637078800, 'android', 'device3', 'купить сапоги'),
(2023, 11, 16, 3, 1637078820, 'android', 'device3', 'купить кроссовки'),
(2023, 11, 16, 3, 1637078890, 'android', 'device3', 'купить ботинки'),
(2023, 11, 16, 4, 1637078450, 'ios', 'device4', 'купить телефон'),
(2023, 11, 16, 4, 1637078550, 'ios', 'device4', 'купить смартфон'),
(2023, 11, 16, 4, 1637078720, 'ios', 'device4', 'купить айфон'),
(2023, 11, 16, 4, 1637078980, 'ios', 'device4', 'купить телефон apple'),
(2023, 11, 16, 5, 1637078400, 'android', 'device5', 'купить ноутбук'),
(2023, 11, 16, 5, 1637078465, 'android', 'device5', 'купить планшет'),
(2023, 11, 16, 5, 1637078720, 'android', 'device5', 'купить компьютер'),
(2023, 11, 16, 5, 1637078890, 'android', 'device5', 'купить мышку'),
(2023, 11, 16, 5, 1637079140, 'android', 'device5', 'купить клавиатуру');


WITH query_ranks AS (
    SELECT
        searchid,
        year,
        month,
        day,
        userid,
        ts,
        devicetype,
        deviceid,
        query,
        LEAD(ts) OVER (PARTITION BY userid, devicetype, deviceid ORDER BY ts) AS next_ts,
        LEAD(query) OVER (PARTITION BY userid, devicetype, deviceid ORDER BY ts) AS next_query
    FROM query
),
query_final as (
SELECT
        searchid,
        year,
        month,
        day,
        userid,
        ts,
        devicetype,
        deviceid,
        query,
        next_ts,
        next_query,
        --Для каждого запроса определим значение is_final:
        case
	        --Если пользователь вбил запрос (с определенного устройства), и после данного запроса больше ничего не искал, то значение равно 1
            WHEN next_ts IS NULL THEN 1 
            --Если пользователь вбил запрос (с определенного устройства), и до следующего запроса прошло более 3х минут, то значение также равно 1
            WHEN (next_ts - ts) > 180 THEN 1
            --Если пользователь вбил запрос (с определенного устройства), И следующий запрос был короче, И до следующего запроса прошло прошло более минуты, то значение равно 2
            WHEN (next_ts - ts) > 60 AND LENGTH(next_query) < LENGTH(query) THEN 2
            ELSE 0 --Иначе - значение равно 0
        END AS is_final
    FROM query_ranks
)
SELECT
    year,
    month,
    day,
    userid,
    ts,
    devicetype,
    deviceid,
    query,
    next_query,
    is_final
FROM query_final
WHERE (is_final = 1 OR is_final = 2)
AND devicetype = 'android'
AND year = 2023 AND month = 11 AND day = 16;