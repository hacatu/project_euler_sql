WITH remainders(d, r, l) AS (
	SELECT value, 10%value, 1
	FROM GENERATE_SERIES(2, 1000)
	WHERE value%2 != 0 AND value%5 != 0
	UNION ALL
	SELECT d, r*10%d, l + 1
	FROM remainders
	WHERE r > 1
)
SELECT d FROM remainders WHERE r <= 1 ORDER BY l DESC LIMIT 1;

