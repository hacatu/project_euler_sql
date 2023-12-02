CREATE TABLE target AS SELECT 1000000 AS n;
WITH high_steps_3(n, l, c) AS (
	SELECT 4*value + 3, 6*value + 5, 2
	FROM GENERATE_SERIES(((SELECT target.n FROM target) + 1)/6, ((SELECT target.n FROM target) - 3)/4)
	UNION ALL
	SELECT
		n,
		CASE l&1 WHEN 0 THEN l/2 ELSE (3*l + 1)/2 END,
		c + (l&1) + 1
	FROM high_steps_3
	WHERE l > n
), all_steps(n, l, c) AS (
	SELECT 2*value, value, 1
	-- 0 mod 2
	FROM GENERATE_SERIES(1, (SELECT target.n FROM target)/2)
	UNION ALL
	-- 1 MOD 4
	SELECT 4*value + 1, 3*value + 1, 3
	FROM GENERATE_SERIES(1, ((SELECT target.n FROM target) - 1)/4)
	UNION ALL
	-- 3 MOD 4 (low)
	SELECT 4*value + 3, 6*value + 5, 2
	FROM GENERATE_SERIES(0, ((SELECT target.n FROM target) - 5)/6)
	UNION ALL
	SELECT * FROM high_steps_3 WHERE n > l
	ORDER BY l
), all_counts(n, c) AS (
	SELECT 1, 1
	UNION ALL
	SELECT all_steps.n, all_steps.c + all_counts.c
	FROM all_steps
	JOIN all_counts ON l = all_counts.n
)
SELECT n FROM all_counts ORDER BY c DESC LIMIT 1;
