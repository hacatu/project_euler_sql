CREATE TABLE target AS SELECT CAST(1000000 AS INT) AS n;

CREATE TABLE primes AS
WITH RECURSIVE generators(gen) AS (
	SELECT * FROM GENERATE_SERIES(5, (SELECT SQRT(target.n) FROM target), 6)
), multiples(prod, gen) AS (
	SELECT
		gen*gen,
		6*gen
	FROM generators
	UNION ALL SELECT
		(gen + 2)*(gen + 2),
		6*(gen + 2)
	FROM generators
	UNION ALL SELECT
		gen*(gen + 2),
		6*gen
	FROM generators
	UNION ALL SELECT
		(gen + 2)*(gen + 6),
		6*(gen + 2)
	FROM generators
	UNION ALL SELECT
		prod + gen,
		gen
	FROM multiples
	WHERE prod + gen <= (SELECT n FROM target)
)
SELECT column1 as p FROM (VALUES (2), (3))
UNION ALL
SELECT * FROM GENERATE_SERIES(3, (SELECT target.n FROM target), 2)
WHERE value%6 in (1, 5)
EXCEPT
SELECT DISTINCT prod
FROM multiples;

WITH RECURSIVE sums(a, b, tot, max_len, max_sum, max_start) AS (
	SELECT 1, 2, 2, 1, 2, 0
	UNION ALL
	SELECT
		IIF(tot + r.p >= 1000000, a + 1, a),
		IIF(tot + r.p >= 1000000, b, b + 1),
		IIF(tot + r.p >= 1000000, tot - l.p, tot + r.p),
		IIF(b - a > max_len AND tot IN primes, b - a, max_len),
		IIF(b - a > max_len AND tot IN primes, tot, max_sum),
		IIF(b - a > max_len AND tot IN primes, l.p, max_start)
	FROM sums
	JOIN primes l ON a = l.rowid
	JOIN primes r ON b = r.rowid
	WHERE (6*max_len*max_len + (4*l.p - 26)*max_len - 1)/4 < 1000000
)
SELECT max_sum FROM sums ORDER BY max_len DESC LIMIT 1;

