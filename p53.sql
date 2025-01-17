WITH RECURSIVE small_binom(n, r, v) AS (
	SELECT 9, 0, 1
	UNION ALL
	SELECT n, r + 1, (n - r)*v/(r + 1)
	FROM small_binom
	WHERE r < n
), saturated_binom(n, r, v) AS (
	SELECT * FROM small_binom
	UNION ALL
	SELECT n + 1, r, min((n + 1)*v/(n + 1 - r), 1000001)
	FROM saturated_binom
	WHERE n <= 100
), cutoffs(r, min_n) AS (
	SELECT 10, 23
	UNION ALL
	SELECT r, MIN(n)
	FROM saturated_binom
	WHERE v == 1000001
	GROUP BY r
	ORDER BY r DESC
), psums(r, n, n1) AS (
	SELECT
		r,
		min_n,
		LAG(min_n, 1, 101) OVER win
	FROM cutoffs
	WINDOW win AS (ORDER BY r ROWS 1 PRECEDING)
)
SELECT
	SUM(n1*(n1 - 1)/2 - n*(n - 1)/2 + (n1 - n)*(1 - 2*r))
FROM psums;

