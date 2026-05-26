/*
We want to find a loop of 6 numbers {a, b, c, d, e, f}
so that:
- each number is 4 digits long
- each number begins with the last 2 digits of the previous number
- this includes the first number beginning with the last 2 digits of the last number
- each of these "figurate" types: triangle, square, pentagonal, hexagonal, heptagonal, octagonal
  can be assigned a unique one of the numbers (although note that multiple of the numbers
  could be one of these types)

We have
- P3(n) = n(n+1)/2		45-140
- P4(n) = n^2			32-99
- P5(n) = n(3n-1)/2		26-81
- P6(n) = n(2n-1)		23-70
- P7(n) = n(5n-3)/2		21-63
- P8(n) = n(3n-2)		19-58

And since we have 6 numbers, we can try something like this:
- select an order for the figures (there are 5! = 120 orders, since we can assume any one we want is first)
- generate the first, third, and fifth numbers
- check that the second, fourth, and sixth numbers are correct
*/

CREATE TABLE figures(k INT, n INT);
INSERT INTO figures
	SELECT 3, value*(value+1)/2 FROM GENERATE_SERIES(19, 140)
	WHERE value*(value+1)/2 >= 1000
	AND value*(value+1)/2 < 10000;
INSERT INTO figures
	SELECT 4, value*value FROM GENERATE_SERIES(19, 140)
	WHERE value*value >= 1000
	AND value*value < 10000;
INSERT INTO figures
	SELECT 5, value*(3*value-1)/2 FROM GENERATE_SERIES(19, 140)
	WHERE value*(3*value-1)/2 >= 1000
	AND value*(3*value-1)/2 < 10000;
INSERT INTO figures
	SELECT 6, value*(2*value-1) FROM GENERATE_SERIES(19, 140)
	WHERE value*(2*value-1) >= 1000
	AND value*(2*value-1) < 10000;
INSERT INTO figures
	SELECT 7, value*(5*value-3)/2 FROM GENERATE_SERIES(19, 140)
	WHERE value*(5*value-3)/2 >= 1000
	AND value*(5*value-3)/2 < 10000;
INSERT INTO figures
	SELECT 8, value*(3*value-2) FROM GENERATE_SERIES(19, 140)
	WHERE value*(3*value-2) >= 1000
	AND value*(3*value-2) < 10000;

CREATE TABLE pairs(a, b, fmask);
INSERT INTO pairs
	SELECT a.n, b.n, (1<<8)|(1<<b.k) FROM figures a
	JOIN figures b
	WHERE a.k = 8 AND b.k != 8 AND a.n != b.n
	AND b.n/100 = a.n%100;
CREATE TABLE triples(a, b, c, fmask);
INSERT INTO triples
	SELECT a, b, n, fmask|(1<<k) FROM pairs
	JOIN figures
	WHERE fmask&(1<<k) = 0 AND n != a AND n != b
	AND n/100 = b%100;
DROP TABLE pairs;
CREATE TABLE quadruples(a, b, c, d, fmask);
INSERT INTO quadruples
	SELECT a, b, c, n, fmask|(1<<k) FROM triples
	JOIN figures
	WHERE fmask&(1<<k) = 0 AND n != a AND n != b AND n != c
	AND n/100 = c%100;
DROP TABLE triples;
CREATE TABLE quintuples(a, b, c, d, e, fmask);
INSERT INTO quintuples
	SELECT a, b, c, d, n, fmask|(1<<k) FROM quadruples
	JOIN figures
	WHERE fmask&(1<<k) = 0 AND n != a AND n != b AND n != c AND n != d
	AND n/100 = d%100;
DROP TABLE quadruples;
CREATE TABLE sextuples(a, b, c, d, e, f);
INSERT INTO sextuples
	SELECT a, b, c, d, e, n FROM quintuples
	JOIN figures
	WHERE fmask|(1<<k) = 504 AND n/100 = e%100 AND a/100 = n%100
	AND n != a AND n != b AND n != c AND n != d AND n != e;
SELECT a+b+c+d+e+f FROM sextuples;

