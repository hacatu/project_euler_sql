/*
All 18 digit numbers can fit in a signed 64 bit int, but not all 19 digit numbers,
so we will target 18 digit numbers.  Moreover, we can pack the digit counts into another
64 bit number easily.
*/

CREATE TABLE res(n INT, m INT);
INSERT INTO res
WITH RECURSIVE tmp(r, n, m) AS (
	SELECT 1, 1, 0
	UNION ALL
	SELECT
		IIF(n=0, r+1, r),
		IIF(n=0, (r+1)*(r+1)*(r+1), n/10),
		IIF(n=0, 0, m+(1<<(n%10*6)))
	FROM tmp
	WHERE n < 1000000000000000000
), cte(n, m) AS (
	SELECT r*r*r, m FROM tmp WHERE tmp.n = 0
)
SELECT MIN(n), COUNT(*)
FROM cte
GROUP BY m;
SELECT MIN(n)
FROM res
WHERE m = 5;

