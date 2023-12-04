CREATE TABLE target AS SELECT 10000 as n;

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
SELECT 2 as value
UNION ALL
SELECT
	value
FROM
	GENERATE_SERIES(3, (SELECT target.n FROM target), 2)
EXCEPT
SELECT DISTINCT prod
FROM multiples;

CREATE TABLE divsums AS
WITH RECURSIVE tmp_divsums(n, p, i, pp, d) AS (
	SELECT 1, 2, 1, 1, 1
	UNION ALL
	SELECT
		CASE dummy.value WHEN 0 THEN n*p ELSE n END,
		CASE dummy.value WHEN 0 THEN p ELSE primes.value END,
		CASE dummy.value WHEN 0 THEN i ELSE i + 1 END,
		CASE dummy.value WHEN 0 THEN pp*p ELSE 1 END,
		-- divsum(n) is multiplicative with divsum(p^k) = (p^(k+1) - 1)/(p^k - 1)
		-- so we divide the divsum stored for n by the contribution from its current highest power of p (pp) and multiply by the contribution for pp*p
		CASE dummy.value WHEN 0 THEN IIF(pp = 1, (p*p - 1)/(p - 1)*d, (pp*p*p - 1)/(p - 1) * (d/((pp*p - 1)/(p - 1))))  ELSE d END
	FROM tmp_divsums
	LEFT JOIN primes ON primes.rowid = i + 1
	CROSS JOIN GENERATE_SERIES(0, 1, 1) dummy
	WHERE n*(CASE dummy.value WHEN 0 THEN p ELSE primes.value END) <= (SELECT target.n FROM target)
)
SELECT n, d - n as d FROM tmp_divsums WHERE pp != 1 OR p = 2;

SELECT SUM(a.n)
FROM divsums a
JOIN divsums b ON a.d = b.n AND b.d = a.n
WHERE a.n != b.n;

