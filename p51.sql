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

DELETE FROM primes
WHERE (SELECT MAX(LENGTH(p) - LENGTH(REPLACE(p, value, ''))) FROM GENERATE_SERIES(0, 10)) < 3;

CREATE TABLE bitmasks AS
SELECT (value&1) + 10*(value>>1&1) + 100*(value>>2&1) + 1000*(value>>3&1) + 10000*(value>>4&1) + 100000*(value>>5) AS mask
FROM GENERATE_SERIES(7, 63)
WHERE (value&1) + (value>>1&1) + (value>>2&1) + (value>>3&1) + (value>>4&1) + (value>>5) == 3 AND (value&1) == 0;

WITH masked_primes(mask, prime, const) AS (
	SELECT
		mask,
		p,
		p - ((p%10)*(mask%10) + 10*(p/10%10)*(mask/10%10) + 100*(p/100%10)*(mask/100%10) + 1000*(p/1000%10)*(mask/1000%10) + 10000*(p/10000%10)*(mask/10000%10) + 100000*(p/100000)*(mask/100000))
	FROM primes JOIN bitmasks
	WHERE ((p%10)*(mask%10) + 10*(p/10%10)*(mask/10%10) + 100*(p/100%10)*(mask/100%10) + 1000*(p/1000%10)*(mask/1000%10) + 10000*(p/10000%10)*(mask/10000%10) + 100000*(p/100000)*(mask/100000))%mask == 0
), mask_sets(mask, first_prime, num_primes) AS (
	SELECT mask, MIN(prime) OVER win, COUNT(prime) OVER win
	FROM masked_primes
	WINDOW win AS (PARTITION BY mask, const)
)
SELECT MIN(first_prime) FROM mask_sets WHERE num_primes >= 8;

