CREATE TABLE target AS SELECT 2000000 AS n;

WITH RECURSIVE generators(gen) AS (
	SELECT
		*
	FROM
		GENERATE_SERIES(5, (SELECT SQRT(target.n) FROM target), 6)
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
), primes(p) AS (
	SELECT
		value
	FROM
		GENERATE_SERIES(5, (SELECT target.n FROM target), 2)
	WHERE value%6 in (1, 5)
	EXCEPT
	SELECT DISTINCT prod
	FROM multiples
)
SELECT 5 + SUM(p) FROM primes;

