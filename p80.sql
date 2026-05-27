/*
Ordinarily, we can compute the square root of n iteratively using

x <- 1/2 * (x + n/x)

However, in sql, we only have DECIMAL_ADD, DECIMAL_MUL, DECIMAL_SUB, DECIMAL_SUM, DECIMAL_CMP, and DECIMAL_POW2
functions.  In other words, we have to do the division manually.

To do this, we can also use iteration: for 1/b, we have

x <- x(2 - bx)

If we initially set x = 1/b (using floats), then this would be correct to about 15 decimal digits,
and each step doubles this, so we need to do 3 iterations.  We will probably inline this.

Similarly, we use floats to guess the square root, so again we need 3 newton iterations
*/

WITH RECURSIVE nonsquares(n) AS (
	SELECT * FROM GENERATE_SERIES(1, 100)
	EXCEPT SELECT value*value FROM GENERATE_SERIES(1, 10)
), sqrts(n, xi, i, yj, j) AS (
	SELECT n, FORMAT('%.14f', SQRT(n)), 0, NULL, 0 FROM nonsquares
	UNION ALL
	SELECT
		n,
		/*
		If i = 3, we are done
		If i < 3 and j = 3, do a sqrt iteration and initialize the next inversion
		If i < 3 and j < 3, do an inverse iteration
		*/
		IIF(j=3, SUBSTR(DECIMAL_MUL(0.5, SUBSTR(DECIMAL_ADD(xi, SUBSTR(DECIMAL_MUL(n, yj), 1, 121)), 1, 121)), 1, 121), xi),
		IIF(j=3, i+1, i),
		CASE j
			WHEN 0 THEN SUBSTR(DECIMAL_MUL(FORMAT('%.14f', 1.0/xi), SUBSTR(DECIMAL_SUB(2, SUBSTR(DECIMAL_MUL(xi, FORMAT('%.14f', 1.0/xi)), 1, 121)), 1, 121)), 1, 121)
			WHEN 3 THEN NULL
			ELSE SUBSTR(DECIMAL_MUL(yj, SUBSTR(DECIMAL_SUB(2, SUBSTR(DECIMAL_MUL(xi, yj), 1, 121)), 1, 121)), 1, 121) END,
		(j+1)%4
	FROM sqrts WHERE i < 3
), tots(s, a) AS (
	SELECT SUBSTR(xi, 1, 101), 0 FROM sqrts WHERE i = 3
	UNION ALL
	SELECT SUBSTR(s, 2), a + IIF(SUBSTR(s, 1, 1) = '.', 0, SUBSTR(s, 1, 1)) FROM tots WHERE s != ''
)
SELECT SUM(a) FROM tots WHERE s = '';

