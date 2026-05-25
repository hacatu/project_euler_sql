/*
In layer i of the square, the corners are
4i^2-2i+1, 4i^2+1, 4i^2+2i+1, and 4i^2+4i+1

https://en.wikipedia.org/wiki/Bateman%E2%80%93Horn_conjecture
The bateman-horn conjecture says that the number of times
say f(i) = 4i^2-2i+1 is prime for 1 <= i < x is
P(x) = (product for prime p of (1 - 1/p*#{n:4*n^2 - 2*n + 1 = 0 mod p})/(1 - 1/p)) / 2 * integral for t from 2 to x of dt/lnt
and similar.

So we get

P_tr(x) = 1.120791897916639 * integral for t from 2 to x of dt/lnt
P_tl(x) = 0.6864217662883323 * integral for t from 2 to x of dt/lnt
P_bl(x) = 1.120791897916639 * integral for t from 2 to x of dt/lnt

and obvously the bottom right corner is never prime.

So the total number of primes is
2.9280055621216103 * integral for t from 2 to x of dt/lnt
and the total number of numbers on the diagonals is
4x - 3

So we want to compute when

(2.9280055621216103 * integral for t from 2 to x of dt/lnt)/(4x - 3) <= 0.1

2.9280055621216103 * (li(x) - li(2))/(4x - 3) <= 0.1
(li(x) - li(2))/(4x - 3) <= 0.03415294058647238

Manually bisecting, I find that the crossover point is x = 5015.

However, we know the actual answer, and it is over 2x that.
*/

/*
Since we know the answer is a side length of 26241, this corresponds to i=13120.

But to assume a LITTLE less, let's suppose the max diagonal element is at most 10^10, so we need all primes
up to 10^5 and we can do trial division
*/

CREATE TABLE target AS SELECT 100000 AS n;

CREATE TABLE primes AS
WITH RECURSIVE generators(gen) AS (
	SELECT * FROM GENERATE_SERIES(5, (SELECT SQRT(target.n) FROM target), 6)
), multiples(prod, gen) AS (
	SELECT
		gen*gen,
		6*gen
	FROM generators
	UNION ALL SELECT
		(gen + 2)*(gen + 2),
		6*(gen + 2)
	FROM generators
	UNION ALL SELECT
		gen*(gen + 2),
		6*gen
	FROM generators
	UNION ALL SELECT
		(gen + 2)*(gen + 6),
		6*(gen + 2)
	FROM generators
	UNION ALL SELECT
		prod + gen,
		gen
	FROM multiples
	WHERE prod + gen <= (SELECT n FROM target)
)
SELECT column1 as p FROM (VALUES (3))
UNION ALL
SELECT * FROM GENERATE_SERIES(3, (SELECT target.n FROM target), 2)
WHERE value%6 in (1, 5)
EXCEPT
SELECT DISTINCT prod
FROM multiples;

/*
Now, we want to use trial division to check every diagonal element layer by layer until the density drops too low.
We will use a recursive cte which needs to keep track of i and the total number of primes so far.
*/
WITH RECURSIVE cte AS (
	SELECT
		2 as i, -- i is actually the NEXT i, because I did not want to actually subs i+1 into the polys
		3 as primecount
	UNION
	SELECT
		i+1,
		primecount
		+ IIF(EXISTS (SELECT 1 FROM primes WHERE p*p <= (4*i*i-2*i+1) AND (4*i*i-2*i+1)%p == 0), 0, 1)
		+ IIF(EXISTS (SELECT 1 FROM primes WHERE p*p <= (4*i*i+1) AND (4*i*i+1)%p == 0), 0, 1)
		+ IIF(EXISTS (SELECT 1 FROM primes WHERE p*p <= (4*i*i+2*i+1) AND (4*i*i+2*i+1)%p == 0), 0, 1)
	FROM cte
	WHERE 10*primecount >= 4*i - 3
)
SELECT 2*MAX(i)-1 FROM cte
-- SELECT * FROM cte

