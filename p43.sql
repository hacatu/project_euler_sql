WITH RECURSIVE div_checks(p, t, i) AS (
	SELECT * FROM (VALUES (17, 1, 1), (13, 10, 2), (11, 100, 3), (7, 1000, 4), (5, 10000, 5), (3, 100000, 6), (2, 1000000, 7))
), perms(n, tail, i) AS (
	SELECT
		value as n,
		REPLACE(REPLACE(REPLACE('9876543210', value%10, ''), value/10%10, ''), value/100, '') as tail,
		2
	FROM GENERATE_SERIES((123 + 16)/17*17, 987/17*17, 17)
	WHERE LENGTH(tail) = 7
	UNION ALL
	SELECT
		100*t*SUBSTR(tail, value, 1) + n,
		SUBSTR(tail, 1, value - 1) || SUBSTR(tail, value + 1),
		perms.i + 1
	FROM perms
	JOIN div_checks on perms.i = div_checks.i
	JOIN GENERATE_SERIES(1, 7) ON value <= 9 - perms.i AND (n/t + 100*SUBSTR(tail, value, 1))%p = 0
)
SELECT SUM(tail||n) FROM perms WHERE i = 8;

