CREATE TABLE target AS SELECT 30000 AS n;

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

CREATE TABLE powers_of_10(v INT);
INSERT INTO powers_of_10 VALUES
	(10),
	(100),
	(1000),
	(10000),
	(100000);

CREATE TABLE parts(p INT, t INT);
INSERT INTO parts SELECT p, MIN(v) FROM primes
JOIN powers_of_10 WHERE v > p GROUP BY p;

.print found primes
SELECT COUNT(*) FROM primes;

CREATE TABLE pairs(p1 INT, t1 INT, p2 INT, t2 INT);
INSERT INTO pairs SELECT a.p, a.t, b.p, b.t FROM parts a JOIN parts b
	WHERE a.rowid < b.rowid
	AND NOT EXISTS (SELECT 1 FROM primes d WHERE d.p*d.p <= a.p*b.t + b.p AND (a.p*b.t + b.p)%d.p == 0)
	AND NOT EXISTS (SELECT 1 FROM primes d WHERE d.p*d.p <= b.p*a.t + a.p AND (b.p*a.t + a.p)%d.p == 0);

DROP TABLE parts;
DROP TABLE primes;

.print found pairs
SELECT COUNT(*) FROM pairs;

CREATE TABLE triples(p1 INT, t1 INT, p2 INT, t2 INT, p3 INT, t3 INT);
INSERT INTO triples SELECT a.p1, a.t1, b.p1, b.t1, b.p2, b.t2 FROM pairs a
	JOIN pairs b ON a.p2 = b.p2
	WHERE a.p1 < b.p1
	AND EXISTS (SELECT 1 FROM pairs c WHERE c.p1 = a.p1 AND c.p2 = b.p1);

/*
CREATE TABLE triples(p1 INT, t1 INT, p2 INT, t2 INT, p3 INT, t3 INT);
INSERT INTO triples SELECT p1, t1, p2, t2, p, t FROM pairs JOIN parts b
	WHERE p2 < p
	AND NOT EXISTS (SELECT 1 FROM primes d WHERE d.p*d.p <= p1*t + b.p AND (p1*t + b.p)%d.p == 0)
	AND NOT EXISTS (SELECT 1 FROM primes d WHERE d.p*d.p <= b.p*t1 + p1 AND (b.p*t1 + p1)%d.p == 0)
	AND NOT EXISTS (SELECT 2 FROM primes d WHERE d.p*d.p <= p2*t + b.p AND (p2*t + b.p)%d.p == 0)
	AND NOT EXISTS (SELECT 2 FROM primes d WHERE d.p*d.p <= b.p*t2 + p2 AND (b.p*t2 + p2)%d.p == 0);
*/

.print found triples
SELECT COUNT(*) FROM triples;

CREATE TABLE quadruples(p1 INT, t1 INT, p2 INT, t2 INT, p3 INT, t3 INT, p4 INT, t4 INT);
INSERT INTO quadruples SELECT a.p1, a.t1, b.p1, b.t1, b.p2, b.t2, b.p3, b.t3 FROM pairs a
	JOIN triples b ON a.p2 = b.p3
	WHERE a.p1 < b.p1
	AND EXISTS (SELECT 1 FROM pairs c WHERE c.p1 = a.p1 AND c.p2 = b.p1)
	AND EXISTS (SELECT 1 FROM pairs c WHERE c.p1 = a.p1 AND c.p2 = b.p2);

/*
CREATE TABLE quadruples(p1 INT, t1 INT, p2 INT, t2 INT, p3 INT, t3 INT, p4 INT, t4 INT);
INSERT INTO quadruples SELECT p1, t1, p2, t2, p3, t3, p, t FROM pairs JOIN parts b
	WHERE p3 < p
	AND NOT EXISTS (SELECT 1 FROM primes d WHERE d.p*d.p <= p1*t + b.p AND (p1*t + b.p)%d.p == 0)
	AND NOT EXISTS (SELECT 1 FROM primes d WHERE d.p*d.p <= b.p*t1 + p1 AND (b.p*t1 + p1)%d.p == 0)
	AND NOT EXISTS (SELECT 2 FROM primes d WHERE d.p*d.p <= p2*t + b.p AND (p2*t + b.p)%d.p == 0)
	AND NOT EXISTS (SELECT 2 FROM primes d WHERE d.p*d.p <= b.p*t2 + p2 AND (b.p*t2 + p2)%d.p == 0)
	AND NOT EXISTS (SELECT 3 FROM primes d WHERE d.p*d.p <= p3*t + b.p AND (p3*t + b.p)%d.p == 0)
	AND NOT EXISTS (SELECT 3 FROM primes d WHERE d.p*d.p <= b.p*t3 + p3 AND (b.p*t3 + p3)%d.p == 0);
*/

DROP TABLE triples;

.print found quadruples
SELECT COUNT(*) FROM quadruples;

WITH quintuples(p1, p2, p3, p4, p5) AS
(SELECT a.p1, b.p1, b.p2, b.p3, b.p4 FROM pairs a
	JOIN quadruples b ON a.p2 = b.p4
	WHERE a.p1 < b.p1
	AND EXISTS (SELECT 1 FROM pairs c WHERE c.p1 = a.p1 AND c.p2 = b.p1)
	AND EXISTS (SELECT 1 FROM pairs c WHERE c.p1 = a.p1 AND c.p2 = b.p2)
	AND EXISTS (SELECT 1 FROM pairs c WHERE c.p1 = a.p1 AND c.p2 = b.p3)
)
/*
WITH quintuples(p1 INT, p2 INT, p3 INT, p4 INT, p5 INT) AS
(SELECT p1, p2, p3, p4, p FROM pairs JOIN parts b
	WHERE p4 < p
	AND NOT EXISTS (SELECT 1 FROM primes d WHERE d.p*d.p <= p1*t + b.p AND (p1*t + b.p)%d.p == 0)
	AND NOT EXISTS (SELECT 1 FROM primes d WHERE d.p*d.p <= b.p*t1 + p1 AND (b.p*t1 + p1)%d.p == 0)
	AND NOT EXISTS (SELECT 2 FROM primes d WHERE d.p*d.p <= p2*t + b.p AND (p2*t + b.p)%d.p == 0)
	AND NOT EXISTS (SELECT 2 FROM primes d WHERE d.p*d.p <= b.p*t2 + p2 AND (b.p*t2 + p2)%d.p == 0)
	AND NOT EXISTS (SELECT 3 FROM primes d WHERE d.p*d.p <= p3*t + b.p AND (p3*t + b.p)%d.p == 0)
	AND NOT EXISTS (SELECT 3 FROM primes d WHERE d.p*d.p <= b.p*t3 + p3 AND (b.p*t3 + p3)%d.p == 0)
	AND NOT EXISTS (SELECT 4 FROM primes d WHERE d.p*d.p <= p4*t + b.p AND (p4*t + b.p)%d.p == 0)
	AND NOT EXISTS (SELECT 4 FROM primes d WHERE d.p*d.p <= b.p*t4 + p4 AND (b.p*t4 + p4)%d.p == 0)
)
*/
SELECT MIN(p1+p2+p3+p4+p5) FROM quintuples;

