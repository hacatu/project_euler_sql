WITH RECURSIVE factors AS (
	SELECT
		600851475143 AS n,
		2 AS i
	UNION ALL
	SELECT
		CASE WHEN n%i = 0 THEN n/i ELSE n END,
		CASE WHEN n%i = 0 THEN i ELSE i + 1 END
	FROM factors
	WHERE i < n
)
SELECT
	MIN(n)
FROM
	factors

