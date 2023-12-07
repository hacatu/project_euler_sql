CREATE TABLE target AS SELECT 9997 as n;

CREATE TABLE primes AS
WITH RECURSIVE multiples AS (
	SELECT
		value*value AS prod,
		value AS gen
	FROM
		GENERATE_SERIES(3, (SELECT SQRT(target.n) FROM target), 2)
	UNION
	SELECT
		prod + 2*gen,
		gen
	FROM multiples
	WHERE prod + gen <= (SELECT target.n FROM target)
)
SELECT 2 as p
UNION ALL
SELECT
	value as p
FROM
	GENERATE_SERIES(3, (SELECT target.n FROM target), 2)
EXCEPT
SELECT DISTINCT prod
FROM multiples;

WITH prime_masks(p, dmask) AS (
	SELECT p, (1<<p%10*3) + (1<<p/10%10*3) + (1<<p/100%10*3) + (1<<p/1000*3)
	FROM primes
	WHERE p > 999
), cand_masks(dmask) AS (
	SELECT dmask
	FROM (SELECT dmask, MIN(p) as p0, COUNT(p) as k FROM prime_masks GROUP BY dmask)
	WHERE k > 2
)
SELECT l.p || ((l.p + r.p)/2) || r.p
FROM cand_masks
JOIN prime_masks l ON l.dmask = cand_masks.dmask
JOIN prime_masks r ON r.dmask = cand_masks.dmask AND l.p < r.p
WHERE (l.p + r.p)%2 = 0 AND ((l.p + r.p)/2, cand_masks.dmask) IN prime_masks;

