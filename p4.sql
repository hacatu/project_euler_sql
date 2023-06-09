SELECT
	CAST(((1000 - a.value) * (1000 - b.value)) AS VARCHAR) AS s
FROM
	GENERATE_SERIES(1, 100) a
FULL JOIN
	GENERATE_SERIES(1, 100) b
WHERE
	SUBSTR(s, 1, 1) = SUBSTR(s, 6, 1) AND
	SUBSTR(s, 2, 1) = SUBSTR(s, 5, 1) AND
	SUBSTR(s, 3, 1) = SUBSTR(s, 4, 1)
ORDER BY
	s DESC
LIMIT
	1

