CREATE TABLE triag(i INT, j INT, n INT, PRIMARY KEY (i, j));

WITH RECURSIVE tmp_rows(ro, i, remaining) AS (
	SELECT
		'',
		0,
		'75 n'||
		'95 64 n'||
		'17 47 82 n'||
		'18 35 87 10 n'||
		'20 04 82 47 65 n'||
		'19 01 23 75 03 34 n'||
		'88 02 77 73 07 63 67 n'||
		'99 65 04 28 06 16 70 92 n'||
		'41 41 26 56 83 40 80 70 33 n'||
		'41 48 72 33 47 32 37 16 94 29 n'||
		'53 71 44 65 25 43 91 52 97 51 14 n'||
		'70 11 33 28 77 73 17 78 39 68 17 57 n'||
		'91 71 52 38 17 14 91 43 58 50 27 29 48 n'||
		'63 66 04 68 89 53 67 30 73 16 69 87 40 31 n'||
		'04 62 98 27 23 09 70 98 73 93 38 53 60 04 23 n'
	UNION ALL
	SELECT
		substr(remaining, 0, instr(remaining, 'n')),
		i + 1,
		substr(remaining, instr(remaining, 'n') + 1)
	FROM tmp_rows
	WHERE remaining != ''
), tmp_triag(i, j, n, remaining) AS (
	SELECT
		i,
		0,
		0,
		ro
	FROM tmp_rows
	WHERE i != 0
	UNION ALL
	SELECT
		i,
		j + 1,
		CAST(substr(remaining, 0, instr(remaining, ' ')) AS INT),
		substr(remaining, instr(remaining, ' ') + 1)
	FROM tmp_triag
	WHERE remaining != ''
)
INSERT INTO triag
SELECT i, j, n FROM tmp_triag WHERE j != 0;

CREATE TABLE pmax_triag(i INT, j INT, n INT, PRIMARY KEY (i, j));

INSERT INTO pmax_triag
SELECT * FROM triag WHERE i = 15;

WITH cte(i, j, n) AS (SELECT i, j, MAX(n) OVER (ORDER BY j RANGE BETWEEN CURRENT ROW AND 1 FOLLOWING) FROM pmax_triag WHERE i = 15)
INSERT INTO pmax_triag
SELECT triag.i, triag.j, triag.n + cte.n
FROM triag JOIN  cte ON triag.i + 1 = cte.i AND triag.j = cte.j;

WITH cte(i, j, n) AS (SELECT i, j, MAX(n) OVER (ORDER BY j RANGE BETWEEN CURRENT ROW AND 1 FOLLOWING) FROM pmax_triag WHERE i = 14)
INSERT INTO pmax_triag
SELECT triag.i, triag.j, triag.n + cte.n
FROM triag JOIN  cte ON triag.i + 1 = cte.i AND triag.j = cte.j;

WITH cte(i, j, n) AS (SELECT i, j, MAX(n) OVER (ORDER BY j RANGE BETWEEN CURRENT ROW AND 1 FOLLOWING) FROM pmax_triag WHERE i = 13)
INSERT INTO pmax_triag
SELECT triag.i, triag.j, triag.n + cte.n
FROM triag JOIN  cte ON triag.i + 1 = cte.i AND triag.j = cte.j;

WITH cte(i, j, n) AS (SELECT i, j, MAX(n) OVER (ORDER BY j RANGE BETWEEN CURRENT ROW AND 1 FOLLOWING) FROM pmax_triag WHERE i = 12)
INSERT INTO pmax_triag
SELECT triag.i, triag.j, triag.n + cte.n
FROM triag JOIN  cte ON triag.i + 1 = cte.i AND triag.j = cte.j;

WITH cte(i, j, n) AS (SELECT i, j, MAX(n) OVER (ORDER BY j RANGE BETWEEN CURRENT ROW AND 1 FOLLOWING) FROM pmax_triag WHERE i = 11)
INSERT INTO pmax_triag
SELECT triag.i, triag.j, triag.n + cte.n
FROM triag JOIN  cte ON triag.i + 1 = cte.i AND triag.j = cte.j;

WITH cte(i, j, n) AS (SELECT i, j, MAX(n) OVER (ORDER BY j RANGE BETWEEN CURRENT ROW AND 1 FOLLOWING) FROM pmax_triag WHERE i = 10)
INSERT INTO pmax_triag
SELECT triag.i, triag.j, triag.n + cte.n
FROM triag JOIN  cte ON triag.i + 1 = cte.i AND triag.j = cte.j;

WITH cte(i, j, n) AS (SELECT i, j, MAX(n) OVER (ORDER BY j RANGE BETWEEN CURRENT ROW AND 1 FOLLOWING) FROM pmax_triag WHERE i = 9)
INSERT INTO pmax_triag
SELECT triag.i, triag.j, triag.n + cte.n
FROM triag JOIN  cte ON triag.i + 1 = cte.i AND triag.j = cte.j;

WITH cte(i, j, n) AS (SELECT i, j, MAX(n) OVER (ORDER BY j RANGE BETWEEN CURRENT ROW AND 1 FOLLOWING) FROM pmax_triag WHERE i = 8)
INSERT INTO pmax_triag
SELECT triag.i, triag.j, triag.n + cte.n
FROM triag JOIN  cte ON triag.i + 1 = cte.i AND triag.j = cte.j;

WITH cte(i, j, n) AS (SELECT i, j, MAX(n) OVER (ORDER BY j RANGE BETWEEN CURRENT ROW AND 1 FOLLOWING) FROM pmax_triag WHERE i = 7)
INSERT INTO pmax_triag
SELECT triag.i, triag.j, triag.n + cte.n
FROM triag JOIN  cte ON triag.i + 1 = cte.i AND triag.j = cte.j;

WITH cte(i, j, n) AS (SELECT i, j, MAX(n) OVER (ORDER BY j RANGE BETWEEN CURRENT ROW AND 1 FOLLOWING) FROM pmax_triag WHERE i = 6)
INSERT INTO pmax_triag
SELECT triag.i, triag.j, triag.n + cte.n
FROM triag JOIN  cte ON triag.i + 1 = cte.i AND triag.j = cte.j;

WITH cte(i, j, n) AS (SELECT i, j, MAX(n) OVER (ORDER BY j RANGE BETWEEN CURRENT ROW AND 1 FOLLOWING) FROM pmax_triag WHERE i = 5)
INSERT INTO pmax_triag
SELECT triag.i, triag.j, triag.n + cte.n
FROM triag JOIN  cte ON triag.i + 1 = cte.i AND triag.j = cte.j;

WITH cte(i, j, n) AS (SELECT i, j, MAX(n) OVER (ORDER BY j RANGE BETWEEN CURRENT ROW AND 1 FOLLOWING) FROM pmax_triag WHERE i = 4)
INSERT INTO pmax_triag
SELECT triag.i, triag.j, triag.n + cte.n
FROM triag JOIN  cte ON triag.i + 1 = cte.i AND triag.j = cte.j;

WITH cte(i, j, n) AS (SELECT i, j, MAX(n) OVER (ORDER BY j RANGE BETWEEN CURRENT ROW AND 1 FOLLOWING) FROM pmax_triag WHERE i = 3)
INSERT INTO pmax_triag
SELECT triag.i, triag.j, triag.n + cte.n
FROM triag JOIN  cte ON triag.i + 1 = cte.i AND triag.j = cte.j;

WITH cte(i, j, n) AS (SELECT i, j, MAX(n) OVER (ORDER BY j RANGE BETWEEN CURRENT ROW AND 1 FOLLOWING) FROM pmax_triag WHERE i = 2)
INSERT INTO pmax_triag
SELECT triag.i, triag.j, triag.n + cte.n
FROM triag JOIN  cte ON triag.i + 1 = cte.i AND triag.j = cte.j;

SELECT n FROM pmax_triag WHERE i = 1 LIMIT 1;
