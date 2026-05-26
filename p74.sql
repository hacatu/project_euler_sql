CREATE TABLE fx AS
WITH RECURSIVE cte(n, h, v) AS (
	SELECT value, value, 0 FROM GENERATE_SERIES(1, 999999)
	UNION ALL
	SELECT n, h/10, v + CASE h%10
		WHEN 0 THEN 1
		WHEN 1 THEN 1
		WHEN 2 THEN 2
		WHEN 3 THEN 6
		WHEN 4 THEN 24
		WHEN 5 THEN 120
		WHEN 6 THEN 720
		WHEN 7 THEN 5040
		WHEN 8 THEN 40320
		ELSE 362880 END
	FROM cte WHERE h != 0
)
SELECT n, v FROM cte WHERE h = 0;

.print fx done

CREATE TABLE brent1 AS
WITH RECURSIVE brent1(x, t, h, power, lam) AS (
	SELECT n, n, v, 1, 1 FROM fx
	UNION ALL
	SELECT
		x,
		IIF(power = lam, h, t),
		v,
		IIF(power = lam, power*2, power),
		IIF(power = lam, 1, lam + 1)
	FROM brent1
	JOIN fx ON h=n
	WHERE t != h
)
SELECT x, lam FROM brent1 WHERE t = h;

.print brent1 done

CREATE TABLE brent2 AS
WITH RECURSIVE brent2(x, t, h, i, lam) AS (
	SELECT x, x, x, 0, lam FROM brent1
	UNION ALL
	SELECT
		x, t, v, i+1, lam
	FROM brent2
	JOIN fx ON h=n
	WHERE i < lam
)
SELECT x, t, h, lam FROM brent2 WHERE i = lam;

DROP TABLE brent1;

.print brent2 done

WITH RECURSIVE brent3(x, t, h, mu, lam) AS (
	SELECT x, t, h, 0, lam FROM brent2
	UNION ALL
	SELECT
		x, a.v, b.v, mu+1, lam
	FROM brent3
	JOIN fx a ON t = a.n
	JOIN fx b ON h = b.n
	WHERE t != h
)
SELECT COUNT(*) FROM brent3 WHERE t = h AND mu+lam = 60;

