CREATE TABLE target AS SELECT 10000000 AS n;

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

/*
sqlite will not filter the join of primes x primes in an intelligent way, so it would take an untenible amount
of time to generate all semiprimes up to 10^7.  So, let's take 75841/phi(75841) as an upper bound and ignore
any prime that could never be as good.  That is, if we have a best value B and a max n, then
p/(p-1) * (n/p)/(n/p-1) < B
*/

DELETE FROM primes WHERE p < 232 OR p > 42918;

SELECT a.p*b.p FROM primes a
	JOIN primes b
	WHERE a.p*b.p <= (SELECT target.n FROM target)
	AND a.p*b.p%9 = (a.p-1)*(b.p-1)%9
	AND OCTET_LENGTH(a.p*b.p) = OCTET_LENGTH((a.p-1)*(b.p-1))
	AND (1 << (a.p*b.p%10*6)) + (1 << (a.p*b.p/10%10*6)) + (1 << (a.p*b.p/100%10*6)) + (1 << (a.p*b.p/1000%10*6)) + (1 << (a.p*b.p/10000%10*6)) + (1 << (a.p*b.p/100000%10*6)) + (1 << (a.p*b.p/1000000*6))
	= (1 << ((a.p-1)*(b.p-1)%10*6)) + (1 << ((a.p-1)*(b.p-1)/10%10*6)) + (1 << ((a.p-1)*(b.p-1)/100%10*6)) + (1 << ((a.p-1)*(b.p-1)/1000%10*6)) + (1 << ((a.p-1)*(b.p-1)/10000%10*6)) + (1 << ((a.p-1)*(b.p-1)/100000%10*6)) + (1 << ((a.p-1)*(b.p-1)/1000000*6))
	ORDER BY a.p*b.p/((a.p-1.0)*(b.p-1)) ASC
	LIMIT 1;

