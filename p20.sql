WITH factorials(l, f, i, k, c) AS (
	SELECT 1, '01', 1, 1, 0--, 'init'
	UNION ALL
	SELECT
		IIF(i = k AND c = 0, l + 1, l),
		CASE WHEN i < k THEN
			substr(f, 1, 2*(k - i - 1)) || printf('%02d', (CAST(substr(f, 2*(k - i - 1) + 1, 2) AS INT)*l + c)%100) || substr(f, 2*(k - i) + 1, 2*i)
		WHEN i = k AND c > 0 THEN
			printf('%02d', c) || f
		ELSE
			f
		END,
		IIF(i = k AND c = 0, 0, i + 1),
		IIF(i = k AND c > 0, k + 1, k),
		IIF(i < k, (CAST(substr(f, 2*(k - i - 1) + 1, 2) AS INT)*l + c)/100, 0)/*,
		CASE WHEN i < k THEN
			printf('parse `%s`[%d:+2]: ', f, 2*(k - i - 1)) || substr(f, 2*(k - i - 1), 2)
			--printf('parse %d', CAST(substr(f, 2*(k - i - 1), 2) AS INT))
		WHEN i = k AND c > 0 THEN
			printf('carryout %02d', c)
		ELSE
			'next'
		END*/
	FROM factorials t WHERE l < 100
), factorial_n(f) AS (
	SELECT f FROM factorials WHERE i = k AND c = 0 AND l = 99
)
SELECT SUM(CAST(substr(f, value, 1) AS INT))
FROM factorial_n
CROSS JOIN GENERATE_SERIES(1, LENGTH(f));

