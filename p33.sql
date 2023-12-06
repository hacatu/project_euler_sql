/*
We can look at four equations:
1: (10a + b)/(10a + c) = b/c
2: (10a + b)/(10x + b) = a/x
3: (10a + b)/(10b + c) = a/c
4: (10a + b)/(10x + a) = b/x

Note that these do not preclude any of the variables being the same
on top of the two that are forced to be the same, eg in (1) the tens
digits of the numerator and denominator are forced to be the same
but additionally we could have a = b or a = c.

However, "reducing" (10a + a)/(10a + a) or (10a + 0)/(10b + 0) is
considered trivial.

In equations (1) and (2), we can cross multiply and simplify to
get (a = 0 OR b = c) and (b = 0 OR a = x) respectively, which are both
disallowed.

In equation (3), we get 9ac + bc = 10ab.
If we work mod 9, then when b is coprime to 9, c = a mod 9,
so either c = a or a = 0 and c = 9, but both of these are disallowed.
Thus we must have b = 3, 6, or 9.

If b = 3, c = 10a/(3a + 1), which leads to no nontrivial solutions.
If b = 6, c = 20a/(3a + 2), which leads to (a, c) = (1, 4) and (2, 5).
If b = 9, c = 10a/(a + 1), which leads to (1, 5) and (4, 8).

In equation (4), we get an extremely similar equation 9bx + ab = 10ax,
and we can do an almost identical analysis to find

If a = 3, b = 10x/(3x + 1).
If a = 6, b - 20x/(3x + 2).
If a = 9, b = 10x/(x + 1).

This time, we are on the wrong side of the trivial point on each hyperbola
and we encounter no lattice points between it and the asymptote/upper bound.

So the only solutions are 1/4, 2/5, 1/5, and 4/8 = 1/2.
Their product is 1/100.
*/
WITH RECURSIVE fracs(p, q) AS (
	SELECT value, 10*value/(3*value + 1)
	FROM GENERATE_SERIES(1, 2)
	WHERE 10*value%(3*value + 1) = 0
	UNION ALL
	SELECT value, 20*value/(3*value + 2)
	FROM GENERATE_SERIES(1, 5)
	WHERE 20*value%(3*value + 2) = 0
	UNION ALL
	SELECT value, 10*value/(value + 1)
	FROM GENERATE_SERIES(1, 8)
	WHERE 10*value%(value + 1) = 0
), tmp_prod(p, q) AS (
	SELECT
		CAST(ROUND(EXP(SUM(LN(p)))) AS INT),
		CAST(ROUND(EXP(SUM(LN(q)))) AS INT)
	FROM fracs
), tmp_gcd(p, q) AS (
	SELECT p, q
	FROM tmp_prod
	UNION ALL
	SELECT q%p, p
	FROM tmp_gcd
	WHERE p != 0
)
SELECT tmp_prod.q/tmp_gcd.q
FROM tmp_prod
CROSS JOIN tmp_gcd
WHERE tmp_gcd.p = 0;

