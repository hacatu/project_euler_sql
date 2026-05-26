/*
The numerators (and denominators) are almost a linear recurrence:
https://oeis.org/A113873
*/
WITH RECURSIVE numers(a, b, n) AS (
	SELECT '1', '1', 2
	UNION ALL
	SELECT
		DECIMAL_ADD(IIF(n%3 = 1, DECIMAL_MUL(n/3*2, a), a), b),
		a,
		n+1
	FROM numers
	WHERE n<102
), tot(a, t) AS (
	SELECT a, 0 FROM numers WHERE n=102
	UNION ALL
	SELECT SUBSTR(a, 2), t+CAST(SUBSTR(a, 1, 1) AS INT)
	FROM tot
	WHERE a != ''
)
SELECT t FROM tot WHERE a = '';

