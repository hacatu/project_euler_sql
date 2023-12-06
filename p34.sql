WITH RECURSIVE tmp_partitions(parts, d) AS (
	SELECT '', value
	FROM GENERATE_SERIES(0, 8)
	UNION ALL
	SELECT
		CASE value WHEN 0 THEN parts || d ELSE parts END,
		d + value
	FROM tmp_partitions
	JOIN GENERATE_SERIES(0, 1) ON d + value <= 8
	WHERE LENGTH(parts) < 5
), partitions(parts) AS (
	SELECT DISTINCT parts FROM tmp_partitions WHERE LENGTH(parts) > 1
), factorials(n, f) AS (
	SELECT * FROM (VALUES ('0', 1), ('', 0))
	UNION ALL
	-- coerce n to an integer
	SELECT '' || (n + 1), (n + 1)*f
	FROM factorials
	WHERE f != 0 AND n + 0 < 8
), factsums(parts, n) AS (
	SELECT parts, '' || SUM(f)
	FROM (
		SELECT parts, substr(parts, value, 1) as c
		FROM partitions
		CROSS JOIN GENERATE_SERIES(1, 5)
		WHERE c != ''
	)
	JOIN factorials ON c = n
	GROUP BY parts
)
-- should use something like the factsums `select` or the BIT_COUNT trick from a couple problems ago
SELECT SUM(n) FROM factsums WHERE
	LENGTH(parts) = LENGTH(n) AND
	LENGTH(REPLACE(parts, '0', '')) = LENGTH(REPLACE(n, '0', '')) AND
	LENGTH(REPLACE(parts, '1', '')) = LENGTH(REPLACE(n, '1', '')) AND
	LENGTH(REPLACE(parts, '2', '')) = LENGTH(REPLACE(n, '2', '')) AND
	LENGTH(REPLACE(parts, '3', '')) = LENGTH(REPLACE(n, '3', '')) AND
	LENGTH(REPLACE(parts, '4', '')) = LENGTH(REPLACE(n, '4', '')) AND
	LENGTH(REPLACE(parts, '5', '')) = LENGTH(REPLACE(n, '5', '')) AND
	LENGTH(REPLACE(parts, '6', '')) = LENGTH(REPLACE(n, '6', '')) AND
	LENGTH(REPLACE(parts, '7', '')) = LENGTH(REPLACE(n, '7', ''));

