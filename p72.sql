CREATE TABLE target AS SELECT 1000000 AS n;

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

WITH RECURSIVE powers(p, pp) AS (
	SELECT p, p FROM primes
	UNION ALL
	SELECT p, pp*p FROM powers WHERE pp*p <= (SELECT n FROM target)
), contributions(m, pp, l) AS (
	SELECT pp, pp, IIF(pp=p, LN(p-1), LN(p)) FROM powers
	UNION ALL
	SELECT m+pp, pp, l FROM contributions WHERE m+pp <= (SELECT n FROM target)
), phi_tbl(m, phi) AS (
	SELECT m, CAST(ROUND(EXP(SUM(l))) AS INT) FROM contributions
		GROUP BY m
)
SELECT SUM(phi) FROM phi_tbl;

