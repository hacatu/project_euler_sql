/*
https://en.wikipedia.org/wiki/Tree_of_primitive_Pythagorean_triples
*/

CREATE TABLE primitive AS
WITH RECURSIVE primitive(a, b, c) AS (
	SELECT 3, 4, 5
	UNION ALL
	SELECT
		CASE value WHEN 0 THEN a - 2*b + 2*c WHEN 1 THEN a + 2*b + 2*c ELSE -a + 2*b + 2*c END as na,
		CASE value WHEN 0 THEN 2*a - b + 2*c WHEN 1 THEN 2*a + b + 2*c ELSE -2*a + b + 2*c END as nb,
		CASE value WHEN 0 THEN 2*a - 2*b + 3*c WHEN 1 THEN 2*a + 2*b + 3*c ELSE -2*a + 2*b + 3*c END as nc
	FROM primitive
	JOIN GENERATE_SERIES(0, 2)
	WHERE na + nb + nc <= 1500000
)
SELECT a, b, c FROM primitive WHERE a + b + c <= 1500000;

.print found primitive triples:
SELECT COUNT(*) FROM primitive;

WITH RECURSIVE multiples(a, b, c, k) AS (
	SELECT a, b, c, 1 FROM primitive
	UNION ALL
	SELECT a, b, c, k+1 FROM multiples
	WHERE (a + b + c)*(k+1) <= 1500000
), mults(l, m) AS (
	SELECT ((a+b+c)*k) as l, COUNT(*) FROM multiples
	GROUP BY l
)
SELECT COUNT(*) FROM mults WHERE m = 1;

