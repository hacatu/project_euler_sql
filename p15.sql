WITH RECURSIVE binom(n, r, v) AS (
	SELECT 20, 0, 1
	UNION ALL
	SELECT n + 1, r + 1, v*(n + 1)/(r + 1)
	FROM binom
	WHERE n < 40
)
SELECT v FROM binom WHERE n == 40;