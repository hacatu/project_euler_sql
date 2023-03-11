SELECT
	SUM(value)*SUM(value) - SUM(value*value)
FROM
	GENERATE_SERIES(1, 100)

