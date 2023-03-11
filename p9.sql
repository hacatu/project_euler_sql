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
SELECT
	POWER(1000/(a + b + c), 3)*a*b*c
FROM primitive
WHERE
	a + b + c <= 1000 AND
	1000 % (a + b + c) = 0
LIMIT 1;

