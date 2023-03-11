WITH RECURSIVE fib AS (
	SELECT
		0 AS idx,
		0 AS cur,
		1 AS pre
	UNION
	SELECT
		idx + 1,
		cur + pre,
		cur
	FROM fib
	WHERE cur <= 4000000
)
SELECT
	SUM(cur)
FROM fib
WHERE cur%2 == 0

