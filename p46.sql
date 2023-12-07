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

SELECT value as g
FROM GENERATE_SERIES(9, (SELECT n FROM target), 2)
EXCEPT
SELECT p + 2*value*value as n
FROM primes
JOIN GENERATE_SERIES(0, (SELECT (n-3)/2 FROM target)) ON n <= (SELECT n FROM target)
ORDER BY g LIMIT 1;

