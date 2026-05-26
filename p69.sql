CREATE TABLE target AS SELECT 100 AS n;

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

WITH RECURSIVE primorials(prod, i) AS (
	SELECT 1, 1
	UNION ALL
	SELECT prod*p, i+1 FROM primorials
	JOIN primes ON i = rowid WHERE prod*p <= 1000000
)
SELECT MAX(prod) FROM primorials;

