/*
We can represent every number that matters as (a*sqrt(d) + b)/c,
although reducing it will be challenging.

Consider 23:

r(23) -> 1/(r(23) - 4) * (r(23) + 4)/(r(23) - 4) = (r(23) + 4)/(23 - 4^2) = (r(23) + 4)/7
(r(23) + 4)/7 -> 7/(r(23) - 3) * (r(23) + 3)/(r(23) + 3) = (7*r(23) + 21)/(23 - 3^2) = (r(23) + 3)/2

(r(d) + b)/c -> 1/( (r(d) + b)/c - c*F/c )
	= c/( r(d) + b - c*F ) * (r(d) - b + c*F)/(r(d) - b + c*F)
	= c*(r(d) - b + c*F)/(d - b^2 + 2*b*c*F - c^2*F^2)
	= (r(d) + c*F - b)/((d - b^2)/c + (2*b - c*F)*F)

I believe we can assume that a = 1 to avoid needing to take gcds, since gcds would be a big extra layer
of complexity.

So, for every squarefree d, we need to construct and count a sequence something like
d, b, c, i -> d, b, c, i BUT if d, b, c, i already occured, stop.

Not quite, we cannot have a recursive cte reference itself multiple times:

cte(d, b, c, i) AS (
	SELECT d, 0, 1, 0 FROM nonsquares
	UNION ALL
	SELECT
		d,
		c*CAST((SQRT(d) + b)/c AS INT) - b,
		(d - b*b)/c + 2*b*CAST((SQRT(d) + b)/c AS INT) - c, -- WRONG FORMULA
		i + 1
	FROM cte a
	WHERE NOT EXISTS (
		SELECT 1 FROM cte b
		WHERE a.d = b.d AND a.b = b.b AND a.c = b.c
	)
), gaps(d, b, c, l) AS (
	SELECT d, b, c, MAX(i)-MIN(i)+1 FROM cte
	GROUP BY d, b, c
), periods(d, l) AS (
	SELECT d, MAX(l) FROM gaps
	GROUP BY d
)

So we will use Brent cycle detection instead.
*/
WITH RECURSIVE nonsquares(d) AS (
	SELECT * FROM GENERATE_SERIES(1, 10000)
	EXCEPT SELECT value*value FROM GENERATE_SERIES(1, 100)
), brent(d, bt, ct, bh, ch, lam, power) AS (
	SELECT
		-- (r(d) + b)/c -> (r(d) + c*F - b)/((d - b^2)/c + (2*b - c*F)*F)
		d, 0, 1, CAST(SQRT(d) AS INT), d - CAST(SQRT(d) AS INT)*CAST(SQRT(d) AS INT),
		1, 1
	FROM nonsquares
	UNION ALL
	SELECT
		d,
		IIF(power = lam, bh, bt),
		IIF(power = lam, ch, ct),
		-- (r(d) + b)/c -> (r(d) + c*F - b)/((d - b^2)/c + (2*b - c*F)*F)
		ch*CAST((SQRT(d) + bh)/ch AS INT) - bh,
		(d - bh*bh)/ch + (2*bh - ch*CAST((SQRT(d) + bh)/ch AS INT))*CAST((SQRT(d) + bh)/ch AS INT),
		IIF(power = lam, 1, lam + 1),
		IIF(power = lam, power * 2, power)
	FROM brent
	WHERE bt != bh OR ct != ch
)
SELECT COUNT(*) FROM brent
	WHERE bt = bh AND ct = ch AND lam%2 = 1;

