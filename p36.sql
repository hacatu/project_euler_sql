WITH RECURSIVE b10pals(n) AS (
	SELECT x*a.value + y*b.value + z*c.value
	FROM GENERATE_SERIES(1, 9, 2) a
	CROSS JOIN (
		SELECT
			column1 as x,
			column2 as y,
			column3 as z
		FROM (VALUES (1, 0, 0), (11, 0, 0), (101, 10, 0), (1001, 110, 0), (10001, 1010, 100), (100001, 10010, 1100))
	)
	JOIN GENERATE_SERIES(0, 9) b ON (y != 0) OR (b.value = 0) -- Avoid generating multiple copies of a and aa which don't use b
	JOIN GENERATE_SERIES(0, 9) c ON (z != 0) OR (c.value = 0) -- Avoid generating multiple copies of a, aa, aba, and abba which don't use c
), n_and_rev(n, h, t) AS (
	SELECT n, n, 0
	FROM b10pals
	UNION ALL
	SELECT n, h>>1, t<<1|(h&1)
	FROM n_and_rev
	WHERE h != 0
)
SELECT SUM(n)
FROM n_and_rev
WHERE h = 0 AND n = t;

