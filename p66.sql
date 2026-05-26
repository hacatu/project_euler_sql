/*
https://en.wikipedia.org/wiki/Pell%27s_equation

We know that the continued fraction for sqrt(D) has an extremely particular form:
[floor(sqrt(D)); a_1, ..., a_(r-1), 2*floor(sqrt(D))]
That is, the periodic part starts immediately after the first term, and the last
term in the repetand is 2x the first term.  This means we can totally skip brent cycle detection etc.

Now, the fundamental solution to x^2 - Dy^2 = 1 is related to the cfrac for sqrt(D) in one of two ways,
depending on if the period r is odd or even:

If r is even, then
x1, y1 = h_(r-1), k_(r-1)

If r is odd, then
x1, y1 = h_(2r-1), k_(2r-1)

So we need another recursive cte for the convergents, using the formula:
h[n] = a[n]*h[n-1] + h[n-2]
k[n] = a[n]*k[n-1] + k[n-2]
where h[-1] = 1, h[0] = a[0], k[-1] = 0, k[0] = 1
But we don't need to compute k actually because we know that y will be smaller than x.
*/
WITH RECURSIVE nonsquares(d) AS (
	SELECT * FROM GENERATE_SERIES(1, 1000)
	EXCEPT SELECT value*value FROM GENERATE_SERIES(1, 31)
), cfracs(d, b, c, F, i) AS (
	SELECT
		-- (r(d) + b)/c -> (r(d) + c*F - b)/((d - b^2)/c + (2*b - c*F)*F)
		d, 0, 1, CAST(SQRT(d) AS INT), 0
	FROM nonsquares
	UNION ALL
	SELECT
		d,
		-- (r(d) + b)/c -> (r(d) + c*F - b)/((d - b^2)/c + (2*b - c*F)*F)
		c*F - b,
		(d - b*b)/c + (2*b - c*F)*F,
		CAST((SQRT(d) + c*F - b)/((d - b*b)/c + (2*b - c*F)*F) AS INT),
		i+1
	FROM cfracs
	WHERE F != 2*CAST(SQRT(d) AS INT)
), numers(d, hn, hp, n, r) AS (
	SELECT d, CAST(SQRT(d) AS INT), 1, 0, MAX(i)
	FROM cfracs GROUP BY d
	UNION ALL
	SELECT
		numers.d,
		DECIMAL_ADD(DECIMAL_MUL(F, hn), hp),
		hn,
		n+1,
		r
	FROM numers
	JOIN cfracs ON numers.d = cfracs.d AND n%r+1 = i
	WHERE n < IIF(r%2 = 0, r-1, 2*r-1)
)
SELECT d, hn FROM numers
	WHERE n = IIF(r%2 = 0, r-1, 2*r-1)
	ORDER BY CAST(hn AS REAL) DESC
	LIMIT 1;

