CREATE TABLE target AS SELECT CAST(SQRT(8000000) AS INT) AS n;

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
	WHERE prod + gen <= (SELECT target.n FROM target)
)
SELECT column1 as p FROM (VALUES (2), (3), (5))
UNION ALL
SELECT * FROM GENERATE_SERIES(5, (SELECT target.n FROM target), 2)
WHERE value%6 in (1, 5)
EXCEPT
SELECT DISTINCT prod
FROM multiples;

CREATE TABLE permutations AS
WITH RECURSIVE tmp_perms(head, tail) AS (
	SELECT '', '7654321'
	UNION ALL
	SELECT
		head || substr(tail, value, 1),
		substr(tail, 1, value - 1) || substr(tail, value + 1)
	FROM tmp_perms
	JOIN GENERATE_SERIES(1, 7) ON value <= LENGTH(tail)
)
SELECT head + 0 as n FROM tmp_perms WHERE tail = '';

WITH RECURSIVE prime_perms(n, i, r, p, j) AS (
	SELECT
		sc.n,
		sc.i,
		CAST(SQRT(n) AS INT),
		2,
		0
	FROM (SELECT n, rowid AS i FROM permutations LIMIT 1) as sc
	UNION ALL
	SELECT
		IIF(s.p > r OR s.n%s.p = 0, permutations.n, s.n),
		IIF(s.p > r OR s.n%s.p = 0, i + 1, i),
		IIF(s.p > r OR s.n%s.p = 0, CAST(SQRT(permutations.n) AS INT), r),
		IIF(s.p > r OR s.n%s.p = 0, 2, primes.p),
		IIF(s.p > r OR s.n%s.p = 0, 0, j + 1)
	FROM prime_perms s
	JOIN primes ON primes.rowid = j + 1
	JOIN permutations ON permutations.rowid = i + 1
)
SELECT n FROM prime_perms WHERE p > r LIMIT 1;

