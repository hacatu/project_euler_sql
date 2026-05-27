CREATE TABLE q(n INT, p INT, v INT);
INSERT INTO q SELECT value, 2, 1-value%2 FROM GENERATE_SERIES(0, 100);
INSERT INTO q
WITH RECURSIVE cte(n, v) AS (
	SELECT n, v FROM q WHERE n < 3 AND p=2
	UNION ALL
	SELECT cte.n+3 AS nn, cte.v+q.v FROM cte
	JOIN q ON nn = q.n
	WHERE nn <= 100 AND q.p = 2
)
SELECT n, 3, v FROM cte;
INSERT INTO q
WITH RECURSIVE cte(n, v) AS (
	SELECT n, v FROM q WHERE n < 5 AND p=3
	UNION ALL
	SELECT cte.n+5 AS nn, cte.v+q.v FROM cte
	JOIN q ON nn = q.n
	WHERE nn <= 100 AND q.p = 3
)
SELECT n, 5, v FROM cte;
INSERT INTO q
WITH RECURSIVE cte(n, v) AS (
	SELECT n, v FROM q WHERE n < 7 AND p=5
	UNION ALL
	SELECT cte.n+7 AS nn, cte.v+q.v FROM cte
	JOIN q ON nn = q.n
	WHERE nn <= 100 AND q.p = 5
)
SELECT n, 7, v FROM cte;
INSERT INTO q
WITH RECURSIVE cte(n, v) AS (
	SELECT n, v FROM q WHERE n < 11 AND p=7
	UNION ALL
	SELECT cte.n+11 AS nn, cte.v+q.v FROM cte
	JOIN q ON nn = q.n
	WHERE nn <= 100 AND q.p = 7
)
SELECT n, 11, v FROM cte;
INSERT INTO q
WITH RECURSIVE cte(n, v) AS (
	SELECT n, v FROM q WHERE n < 13 AND p=11
	UNION ALL
	SELECT cte.n+13 AS nn, cte.v+q.v FROM cte
	JOIN q ON nn = q.n
	WHERE nn <= 100 AND q.p = 11
)
SELECT n, 13, v FROM cte;
INSERT INTO q
WITH RECURSIVE cte(n, v) AS (
	SELECT n, v FROM q WHERE n < 17 AND p=13
	UNION ALL
	SELECT cte.n+17 AS nn, cte.v+q.v FROM cte
	JOIN q ON nn = q.n
	WHERE nn <= 100 AND q.p = 13
)
SELECT n, 17, v FROM cte;
INSERT INTO q
WITH RECURSIVE cte(n, v) AS (
	SELECT n, v FROM q WHERE n < 19 AND p=17
	UNION ALL
	SELECT cte.n+19 AS nn, cte.v+q.v FROM cte
	JOIN q ON nn = q.n
	WHERE nn <= 100 AND q.p = 17
)
SELECT n, 19, v FROM cte;
INSERT INTO q
WITH RECURSIVE cte(n, v) AS (
	SELECT n, v FROM q WHERE n < 23 AND p=19
	UNION ALL
	SELECT cte.n+23 AS nn, cte.v+q.v FROM cte
	JOIN q ON nn = q.n
	WHERE nn <= 100 AND q.p = 19
)
SELECT n, 23, v FROM cte;
INSERT INTO q
WITH RECURSIVE cte(n, v) AS (
	SELECT n, v FROM q WHERE n < 29 AND p=23
	UNION ALL
	SELECT cte.n+29 AS nn, cte.v+q.v FROM cte
	JOIN q ON nn = q.n
	WHERE nn <= 100 AND q.p = 23
)
SELECT n, 29, v FROM cte;
INSERT INTO q
WITH RECURSIVE cte(n, v) AS (
	SELECT n, v FROM q WHERE n < 31 AND p=29
	UNION ALL
	SELECT cte.n+31 AS nn, cte.v+q.v FROM cte
	JOIN q ON nn = q.n
	WHERE nn <= 100 AND q.p = 29
)
SELECT n, 31, v FROM cte;
INSERT INTO q
WITH RECURSIVE cte(n, v) AS (
	SELECT n, v FROM q WHERE n < 37 AND p=31
	UNION ALL
	SELECT cte.n+37 AS nn, cte.v+q.v FROM cte
	JOIN q ON nn = q.n
	WHERE nn <= 100 AND q.p = 31
)
SELECT n, 37, v FROM cte;
INSERT INTO q
WITH RECURSIVE cte(n, v) AS (
	SELECT n, v FROM q WHERE n < 41 AND p=37
	UNION ALL
	SELECT cte.n+41 AS nn, cte.v+q.v FROM cte
	JOIN q ON nn = q.n
	WHERE nn <= 100 AND q.p = 37
)
SELECT n, 41, v FROM cte;
INSERT INTO q
WITH RECURSIVE cte(n, v) AS (
	SELECT n, v FROM q WHERE n < 43 AND p=41
	UNION ALL
	SELECT cte.n+43 AS nn, cte.v+q.v FROM cte
	JOIN q ON nn = q.n
	WHERE nn <= 100 AND q.p = 41
)
SELECT n, 43, v FROM cte;
INSERT INTO q
WITH RECURSIVE cte(n, v) AS (
	SELECT n, v FROM q WHERE n < 47 AND p=43
	UNION ALL
	SELECT cte.n+47 AS nn, cte.v+q.v FROM cte
	JOIN q ON nn = q.n
	WHERE nn <= 100 AND q.p = 43
)
SELECT n, 47, v FROM cte;
INSERT INTO q
WITH RECURSIVE cte(n, v) AS (
	SELECT n, v FROM q WHERE n < 53 AND p=47
	UNION ALL
	SELECT cte.n+53 AS nn, cte.v+q.v FROM cte
	JOIN q ON nn = q.n
	WHERE nn <= 100 AND q.p = 47
)
SELECT n, 53, v FROM cte;
INSERT INTO q
WITH RECURSIVE cte(n, v) AS (
	SELECT n, v FROM q WHERE n < 59 AND p=53
	UNION ALL
	SELECT cte.n+59 AS nn, cte.v+q.v FROM cte
	JOIN q ON nn = q.n
	WHERE nn <= 100 AND q.p = 53
)
SELECT n, 59, v FROM cte;
INSERT INTO q
WITH RECURSIVE cte(n, v) AS (
	SELECT n, v FROM q WHERE n < 61 AND p=59
	UNION ALL
	SELECT cte.n+61 AS nn, cte.v+q.v FROM cte
	JOIN q ON nn = q.n
	WHERE nn <= 100 AND q.p = 59
)
SELECT n, 61, v FROM cte;
INSERT INTO q
WITH RECURSIVE cte(n, v) AS (
	SELECT n, v FROM q WHERE n < 67 AND p=61
	UNION ALL
	SELECT cte.n+67 AS nn, cte.v+q.v FROM cte
	JOIN q ON nn = q.n
	WHERE nn <= 100 AND q.p = 61
)
SELECT n, 67, v FROM cte;
INSERT INTO q
WITH RECURSIVE cte(n, v) AS (
	SELECT n, v FROM q WHERE n < 71 AND p=67
	UNION ALL
	SELECT cte.n+71 AS nn, cte.v+q.v FROM cte
	JOIN q ON nn = q.n
	WHERE nn <= 100 AND q.p = 67
)
SELECT n, 71, v FROM cte;
INSERT INTO q
WITH RECURSIVE cte(n, v) AS (
	SELECT n, v FROM q WHERE n < 73 AND p=71
	UNION ALL
	SELECT cte.n+73 AS nn, cte.v+q.v FROM cte
	JOIN q ON nn = q.n
	WHERE nn <= 100 AND q.p = 71
)
SELECT n, 73, v FROM cte;
INSERT INTO q
WITH RECURSIVE cte(n, v) AS (
	SELECT n, v FROM q WHERE n < 79 AND p=73
	UNION ALL
	SELECT cte.n+79 AS nn, cte.v+q.v FROM cte
	JOIN q ON nn = q.n
	WHERE nn <= 100 AND q.p = 73
)
SELECT n, 79, v FROM cte;
INSERT INTO q
WITH RECURSIVE cte(n, v) AS (
	SELECT n, v FROM q WHERE n < 83 AND p=79
	UNION ALL
	SELECT cte.n+83 AS nn, cte.v+q.v FROM cte
	JOIN q ON nn = q.n
	WHERE nn <= 100 AND q.p = 79
)
SELECT n, 83, v FROM cte;
INSERT INTO q
WITH RECURSIVE cte(n, v) AS (
	SELECT n, v FROM q WHERE n < 89 AND p=83
	UNION ALL
	SELECT cte.n+89 AS nn, cte.v+q.v FROM cte
	JOIN q ON nn = q.n
	WHERE nn <= 100 AND q.p = 83
)
SELECT n, 89, v FROM cte;
INSERT INTO q
WITH RECURSIVE cte(n, v) AS (
	SELECT n, v FROM q WHERE n < 97 AND p=89
	UNION ALL
	SELECT cte.n+97 AS nn, cte.v+q.v FROM cte
	JOIN q ON nn = q.n
	WHERE nn <= 100 AND q.p = 89
)
SELECT n, 97, v FROM cte;
SELECT MIN(n) FROM q WHERE v>=5000;

