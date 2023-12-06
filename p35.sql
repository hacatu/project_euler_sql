CREATE TABLE target AS SELECT 1000000 AS n;

CREATE TABLE cand_primes AS
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
	SELECT * FROM (VALUES (2), (3))
	UNION ALL
	SELECT * FROM GENERATE_SERIES(5, (SELECT target.n FROM target), 2)
	WHERE value%6 in (1, 5)
	EXCEPT
	SELECT DISTINCT prod
	FROM multiples
), candidates1(s) AS (
	SELECT 0
	UNION ALL
	SELECT 10*s + column1
	FROM candidates1
	CROSS JOIN (VALUES (1), (3), (7), (9))
	WHERE s < 100000
), candidates2(s) AS (
	SELECT * FROM (VALUES (2), (5))
	UNION ALL
	SELECT s
	FROM candidates1
	WHERE s != 1
), cand_primes(s) AS (
	SELECT *
	FROM candidates2
	-- It would be much faster to test the ~4k values in candidates2,
	-- but I would rather just copy paste my prime sieve and use that as a prime test.
	-- Writing miller rabin in sql would be tough
	INTERSECT
	SELECT *
	FROM primes
)
SELECT
	s as n,
	CASE WHEN s < 10 THEN 1
	WHEN s < 100 THEN 2
	WHEN s < 1000 THEN 3
	WHEN s < 10000 THEN 4
	WHEN s < 100000 THEN 5
	ELSE 6 END as d
FROM cand_primes;

-- Now we delete candidates that don't have their right rotation
-- in the list, so we must delete d-1 times.
DELETE FROM cand_primes
WHERE d = 2 AND (n/10 + n%10*10, d) NOT IN cand_primes;

DELETE FROM cand_primes
WHERE d = 3 AND (n/10 + n%10*100, d) NOT IN cand_primes;
DELETE FROM cand_primes
WHERE d = 3 AND (n/10 + n%10*100, d) NOT IN cand_primes;

DELETE FROM cand_primes
WHERE d = 4 AND (n/10 + n%10*1000, d) NOT IN cand_primes;
DELETE FROM cand_primes
WHERE d = 4 AND (n/10 + n%10*1000, d) NOT IN cand_primes;
DELETE FROM cand_primes
WHERE d = 4 AND (n/10 + n%10*1000, d) NOT IN cand_primes;

DELETE FROM cand_primes
WHERE d = 5 AND (n/10 + n%10*10000, d) NOT IN cand_primes;
DELETE FROM cand_primes
WHERE d = 5 AND (n/10 + n%10*10000, d) NOT IN cand_primes;
DELETE FROM cand_primes
WHERE d = 5 AND (n/10 + n%10*10000, d) NOT IN cand_primes;
DELETE FROM cand_primes
WHERE d = 5 AND (n/10 + n%10*10000, d) NOT IN cand_primes;

DELETE FROM cand_primes
WHERE d = 6 AND (n/10 + n%10*100000, d) NOT IN cand_primes;
DELETE FROM cand_primes
WHERE d = 6 AND (n/10 + n%10*100000, d) NOT IN cand_primes;
DELETE FROM cand_primes
WHERE d = 6 AND (n/10 + n%10*100000, d) NOT IN cand_primes;
DELETE FROM cand_primes
WHERE d = 6 AND (n/10 + n%10*100000, d) NOT IN cand_primes;
DELETE FROM cand_primes
WHERE d = 6 AND (n/10 + n%10*100000, d) NOT IN cand_primes;

SELECT COUNT(n) FROM cand_primes;

