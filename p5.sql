CREATE TABLE primes(prime INT);
INSERT INTO primes VALUES (2), (3), (5), (7), (11), (13), (17), (19);
SELECT
	EXP(SUM(LN(prime)*FLOOR(LN(20)/LN(prime))))
FROM
	primes

