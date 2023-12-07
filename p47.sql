CREATE TABLE target AS SELECT 200000 as n;

CREATE TABLE primes AS
WITH RECURSIVE multiples AS (
	SELECT
		value*value AS prod,
		value AS gen
	FROM
		GENERATE_SERIES(3, (SELECT SQRT(target.n) FROM target), 2)
	UNION
	SELECT
		prod + 2*gen,
		gen
	FROM multiples
	WHERE prod + gen <= (SELECT target.n FROM target)
)
SELECT 2 as value
UNION ALL
SELECT
	value
FROM
	GENERATE_SERIES(3, (SELECT target.n FROM target), 2)
EXCEPT
SELECT DISTINCT prod
FROM multiples;

CREATE TABLE omega AS
WITH RECURSIVE tmp_omega(n, p, i, pp, d) AS (
	SELECT 1, 2, 1, 1, 1
	UNION ALL
	SELECT
		IIF(dummy.value = 0, n*p, n),
		IIF(dummy.value = 0, p, primes.value),
		IIF(dummy.value = 0, i, i + 1),
		IIF(dummy.value = 0, pp*p, 1),
		IIF(dummy.value = 0 AND pp = 1, 2*d, d)
	FROM tmp_omega
	LEFT JOIN primes ON primes.rowid = i + 1
	CROSS JOIN GENERATE_SERIES(0, 1, 1) dummy
	WHERE n*(CASE dummy.value WHEN 0 THEN p ELSE primes.value END) <= (SELECT target.n FROM target)
)
SELECT n, d FROM tmp_omega WHERE pp != 1 OR p = 2;

WITH cte(n, d, d1, d2, d3) AS (
	SELECT n, d, LEAD(d) OVER win AS d1, LEAD(d, 2) OVER win AS d2, LEAD(d, 3) OVER win
	FROM omega
	WINDOW win AS (ORDER BY n ROWS BETWEEN CURRENT ROW AND 3 FOLLOWING)
)
SELECT n FROM cte
WHERE d = 16 AND d1 = 16 AND d2 = 16 AND d3 = 16
LIMIT 1;

