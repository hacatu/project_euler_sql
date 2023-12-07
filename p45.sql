/*
k = (i + 1)/2, then we want (6j-1)^2 - 3(2i+1)^2 = -2
a decent starting resource for generalized pell eqns is
https://web.archive.org/web/20150318090657/http://www.numbertheory.org/pdfs/patz5.pdf
Basically, if we write a solution to x^2 - Dy^2 = N as x + y*sqrt(D), we can represent it as
+/- (x0 + y0*sqrt(D)) * (u + v*sqrt(D))**n, where n is an integer, x0 + y0*sqrt(D) is the
fundamental solution to x^2 - Dy^2 = N, and u + v*sqrt(D) is the fundamental solution to x^2 - Dy^2 = 1
Here, D = 3 and N = -2, and u, v is 2, 1.  The fundamental solution is x, y = 5, 3.
However, x, y is a transformation of the variables i, j
we actually care about, and in particular only every fourth solution x, y produces an integer solution i, j,
so we take (2 + sqrt(3))^4 = (97 + 56*sqrt(3)) and get x + y*sqrt(3) = (5 + 3*sqrt(3))*(97 + 56*sqrt(3))^n
*/
WITH RECURSIVE pell(x, y, n) AS (
	SELECT 5, 3, 0
	UNION ALL
	SELECT 97*x + 168*y, 56*x + 97*y, n + 1
	FROM pell
	WHERE n < 2
)
SELECT (y*y - 1)/8 FROM pell WHERE n = 2;

