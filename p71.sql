WITH approxes(n, d) AS (
	SELECT (3*value-1)/7, value FROM GENERATE_SERIES(1, 1000000)
)
SELECT * FROM approxes
	ORDER BY CAST(n as REAL)/d DESC
	LIMIT 1;

