WITH RECURSIVE convergents(h, k, h1, k1, i) AS (
	SELECT '3', '2', '1', '1', 1
	UNION ALL
	SELECT
		DECIMAL_ADD(DECIMAL_MUL(2, h), h1),
		DECIMAL_ADD(DECIMAL_MUL(2, k), k1),
		h,
		k,
		i + 1
	FROM convergents
	WHERE i < 1000
)
SELECT COUNT(*) FROM convergents WHERE LENGTH(h) > LENGTH(k);