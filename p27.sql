CREATE TABLE target AS SELECT 1000 as n;

CREATE TABLE primes AS
WITH RECURSIVE multiples AS (
	SELECT
		value*value AS prod,
		value AS gen
	FROM
		GENERATE_SERIES(3, (SELECT SQRT(n) FROM target), 2)
	UNION
	SELECT
		prod + 2*gen,
		gen
	FROM multiples
	WHERE prod + gen <= (SELECT n FROM target)
)
SELECT 2 as value
UNION ALL
SELECT
	value
FROM
	GENERATE_SERIES(3, (SELECT n FROM target), 2)
EXCEPT
SELECT DISTINCT prod
FROM multiples;

/*
This solution uses a trick pointed out by Marcus on the forums for
problem 27.  In particular, it turns out that n^2 + n + 41 is
basically the best prime generating polynomial, and most "better"
ones are just a horizontal shift of this one.
This original polynomial generates primes for inputs from 0 to 39,
but its vertex is at -1/2 so it is strictly increasing on this domain
and these prime values are distinct.
The "better" polynomial just shifts this one right by 40 so that it generates
the same primes but twice.
Obviously this works for any shift value, as long as we don't shift so far that
the "basin" of 80 values where it is prime immediately around the vertex no
longer contains the origin.
By defining p(n) = n^2 + n + 41 and plugging in L - n to p,
we get another polynomial p(L - n) = n^2 - p'(L) + p(L) which is prime for
more values as long as L does not exceed 40.

So b = p(L) and a = -p'(L).  Since b < 1000, L <= 30,
so we get ab = -p'(30)*p(30).

We don't even need to check that p(L - 0) is prime since it follows from construction
and the fact that L < 40 due to the magical properties of p(n).
*/

SELECT -(2*value + 1)*(value*value + value + 41)
FROM (SELECT CAST((SQRT(1 + 4*n - 4*41) - 1)/2 AS INT) as value FROM target);

