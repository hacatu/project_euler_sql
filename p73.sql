CREATE TABLE target AS SELECT 12000 AS n;

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
), contributions(m, pp, l, bigo, lilo) AS (
	SELECT pp, pp, IIF(pp=p, LN(p-1), LN(p)), 1, IIF(pp=p, 1, 0) FROM powers
	UNION ALL
	SELECT m+pp, pp, l, bigo, lilo FROM contributions WHERE m+pp <= (SELECT n FROM target)
), mul_tbl(m, phi, bigo, lilo) AS (
	SELECT m, CAST(ROUND(EXP(SUM(l))) AS INT), SUM(bigo), SUM(lilo) FROM contributions
		GROUP BY m
)
SELECT SUM(phi/2 - (phi + IIF(phi%3 = 0, 0, IIF(bigo%2 = 0, 1, -1) << (lilo - 1 - IIF(m%3 = 0, 1, 0))))/3) FROM mul_tbl
	WHERE m >= 4;

