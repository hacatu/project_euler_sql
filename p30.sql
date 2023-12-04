WITH RECURSIVE partitions(p, k) AS (
	SELECT CAST(value AS TEXT), value
	FROM GENERATE_SERIES(0, 6)
	UNION ALL
	SELECT p || value, k + value
	FROM partitions
	JOIN GENERATE_SERIES(0, 6) ON k + value <= 6
	WHERE LENGTH(p) < 9
	UNION ALL
	SELECT p || (6 - k), 6
	FROM partitions
	WHERE LENGTH(p) = 9
), quintsums(p, s) AS (
	SELECT
		p,
		printf('%06d', CAST(substr(p, 2, 1) AS INT)
		+ 32*CAST(substr(p, 3, 1) AS INT)
		+ 243*CAST(substr(p, 4, 1) AS INT)
		+ 1024*CAST(substr(p, 5, 1) AS INT)
		+ 3125*CAST(substr(p, 6, 1) AS INT)
		+ 7776*CAST(substr(p, 7, 1) AS INT)
		+ 16807*CAST(substr(p, 8, 1) AS INT)
		+ 32768*CAST(substr(p, 9, 1) AS INT)
		+ 59049*CAST(substr(p, 10, 1) AS INT))
	FROM partitions
	WHERE LENGTH(p) = 10
), qscounts(p, s, q) AS (
	SELECT
		p,
		s,
		(6 - LENGTH(REPLACE(s, '0', '')))
		|| (6 - LENGTH(REPLACE(s, '1', '')))
		|| (6 - LENGTH(REPLACE(s, '2', '')))
		|| (6 - LENGTH(REPLACE(s, '3', '')))
		|| (6 - LENGTH(REPLACE(s, '4', '')))
		|| (6 - LENGTH(REPLACE(s, '5', '')))
		|| (6 - LENGTH(REPLACE(s, '6', '')))
		|| (6 - LENGTH(REPLACE(s, '7', '')))
		|| (6 - LENGTH(REPLACE(s, '8', '')))
		|| (6 - LENGTH(REPLACE(s, '9', '')))
	FROM quintsums
)
SELECT SUM(CAST(s AS INT)) - 1 FROM qscounts WHERE p = q;


