CREATE TABLE target AS SELECT 100000 as n, 500 as d;

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

WITH RECURSIVE divisors(n, p, i, k, d) AS (
	SELECT * FROM (VALUES (2, 2, 1, 0, 1), (1, 3, 2, 0, 1) )
	UNION ALL
	SELECT
		CASE dummy.value WHEN 0 THEN n*p ELSE n END,
		CASE dummy.value WHEN 0 THEN p ELSE primes.value END,
		CASE dummy.value WHEN 0 THEN i ELSE i + 1 END,
		CASE dummy.value WHEN 0 THEN k + 1 ELSE 0 END,
		CASE dummy.value WHEN 0 THEN d / (k + 1) * (k + 2) ELSE d END
	FROM divisors
	LEFT JOIN primes ON primes.rowid = i + 1
	CROSS JOIN GENERATE_SERIES(0, 1, 1) dummy
	WHERE n*(CASE dummy.value WHEN 0 THEN p ELSE primes.value END) <= (SELECT target.n FROM target)
), triangle_divisors(t, d) AS (
	SELECT
		n*(n + 1)/2,
		d*LEAD(d) OVER (ORDER BY n ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING)
	FROM divisors
	WHERE k > 0
	ORDER BY n
)
SELECT t, d FROM triangle_divisors WHERE d > (SELECT target.d FROM target) ORDER BY t LIMIT 1;
