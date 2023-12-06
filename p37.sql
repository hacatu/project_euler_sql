CREATE TABLE target AS SELECT 10000 AS n;

CREATE TABLE primes AS
WITH RECURSIVE generators(gen) AS (
	SELECT * FROM GENERATE_SERIES(5, (SELECT SQRT(target.n) FROM target), 6)
), multiples(prod, gen) AS (
	SELECT
		gen*gen,
		6*gen
	FROM generators
	UNION SELECT
		(gen + 2)*(gen + 2),
		6*(gen + 2)
	FROM generators
	UNION SELECT
		gen*(gen + 2),
		6*gen
	FROM generators
	UNION SELECT
		(gen + 2)*(gen + 6),
		6*(gen + 2)
	FROM generators
	UNION SELECT
		prod + gen,
		gen
	FROM multiples
	WHERE prod + gen <= (SELECT target.n FROM target)
)
SELECT 3 as p
UNION ALL
SELECT * FROM GENERATE_SERIES(5, (SELECT target.n FROM target), 2)
WHERE value%6 in (1, 5)
EXCEPT
SELECT DISTINCT prod
FROM multiples;

WITH RECURSIVE right_trunc(n, r, p, i) AS (
	-- we fudge the prime entry for 3 to be 7, 1 instead of 3, 0,
	-- since otherwise we would have to check n = p OR n%p != 0 just for this one case
	SELECT * FROM (VALUES (2, 1, 3, 0), (3, 1, 7, 1), (5, 2, 3, 0), (7, 2, 3, 0))
	UNION ALL
	SELECT
		-- column1 is the automatically generated name for the first column of a VALUES statement
		IIF(s.p > r, 10*n + column1, n),
		IIF(s.p > r, CAST(SQRT(10*n + column1) AS INT), r),
		IIF(s.p > r, 3, primes.p),
		IIF(s.p > r, 0, i + 1)
	FROM right_trunc s
	JOIN primes ON i + 1 = primes.rowid
	JOIN (VALUES (1), (3), (7), (9)) ON s.p > r OR column1 = 1 -- avoid generating duplicate scratch rows
	WHERE n%s.p != 0
), left_trunc(n, u, t, r, p, i) AS (
	SELECT n, 100, n%100, 3, 3, 0
	FROM right_trunc WHERE p > r AND n >= 10 AND n%10 NOT IN (1, 9) AND n%100%3 != 0
	UNION ALL
	SELECT
		n,
		IIF(s.p > r, 10*u, u),
		IIF(s.p > r, n%(10*u), t),
		IIF(s.p > r, CAST(SQRT(n%(10*u)) AS INT), r),
		IIF(s.p > r, 3, primes.p),
		IIF(s.p > r, 0, i + 1)
	FROM left_trunc s
	JOIN primes ON i + 1 = primes.rowid
	WHERE t%s.p != 0 AND u < n
)
SELECT SUM(n) FROM left_trunc WHERE u >= n;

