WITH powers(a, n) AS (
	SELECT g.value, g.value*h.value
	FROM GENERATE_SERIES(1, FLOOR(LN(100)/LN(2))) g
	CROSS JOIN GENERATE_SERIES(2, 100) h
), min_bases(a, n) AS (
	SELECT MIN(a), n FROM powers GROUP BY n
), power_counts(a, n) AS (
	SELECT a, COUNT() FROM min_bases GROUP BY a
), bases(a, n) AS (
	SELECT CAST(POW(g.value, h.value) AS INT) as a, h.value
	FROM GENERATE_SERIES(2, 100) g
	CROSS JOIN GENERATE_SERIES(1, FLOOR(LN(100)/LN(2))) h
	WHERE a <= 100
), max_powers(a, n) AS (
	SELECT a, MAX(n) FROM bases GROUP BY a
), base_counts(a, n) AS (
	SELECT n, COUNT() FROM max_powers GROUP BY n
)
SELECT SUM(a.n*b.n) FROM power_counts a JOIN base_counts b ON a.a = b.a;

