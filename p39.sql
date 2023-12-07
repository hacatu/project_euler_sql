-- using euclid's formula, 2m(m + n) is the perimeter
-- we use a farey sequence to generate simplified fractions n/m
-- so the minimal perimeter for a fixed m is 2m(m + 1)
-- so we need 2m(m + 1) <= 1000, which implies m <= 22
WITH RECURSIVE farey(a, b, c, d) AS (
	SELECT 0, 1, 1, 22
	UNION ALL
	SELECT
		c, d, (22 + b)/d*c - a, (22 + b)/d*d - b
	FROM farey
	WHERE c <= 22
), primitive(a, b, c) AS (
	SELECT
		f.b*f.b - f.a*f.a,
		2*f.a*f.b,
		f.b*f.b + f.a*f.a
	FROM farey f
	WHERE
		f.a&f.b&1 = 0 AND
		f.a != 0 AND f.b != 0 AND f.a != f.b
)
SELECT (a + b + c)*value AS p, COUNT() AS k
FROM primitive
JOIN GENERATE_SERIES(1, 1000/12)
WHERE p <= 1000
GROUP BY p
ORDER BY k DESC LIMIT 1;

