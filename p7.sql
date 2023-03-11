CREATE TABLE target AS SELECT 10001 AS i, 114319 AS n;

WITH RECURSIVE multiples AS (
	SELECT
		value*value AS prod,
		value AS gen
	FROM
		GENERATE_SERIES(3, (SELECT SQRT(target.n) FROM target), 2)
	UNION
	SELECT
		prod + 2*gen,
		gen
	FROM multiples
	WHERE prod + gen <= (SELECT target.n FROM target)
)
SELECT
	value
FROM
	GENERATE_SERIES(3, (SELECT target.n FROM target), 2)
EXCEPT
SELECT DISTINCT prod
FROM multiples
LIMIT 1 OFFSET (SELECT target.i FROM target) - 2;

