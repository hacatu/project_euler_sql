CREATE TABLE avs(v INT);
.import --rowsep , --ascii 0059_cipher.txt avs
/*
The ascii values for lowercase letters are
97 thru 122
and the frequencies of letters are given here
https://en.wikipedia.org/wiki/Letter_frequency
*/

CREATE TABLE freqs(ascii INT, w REAL);
INSERT INTO freqs VALUES
	(97, 0.082),
	(98, 0.015),
	(99, 0.028),
	(100, 0.043),
	(101, 0.127),
	(102, 0.022),
	(103, 0.020),
	(104, 0.061),
	(105, 0.070),
	(106, 0.0016),
	(107, 0.0077),
	(108, 0.040),
	(109, 0.024),
	(110, 0.067),
	(111, 0.075),
	(112, 0.019),
	(113, 0.0012),
	(114, 0.060),
	(115, 0.063),
	(116, 0.091),
	(117, 0.028),
	(118, 0.0098),
	(119, 0.024),
	(120, 0.0015),
	(121, 0.020),
	(122, 0.00074);

-- assume that ' ' (space) is the most common character for each slice
CREATE TABLE key(v INT);
INSERT INTO key
	SELECT
		(v|32)-(v&32)
	FROM avs
	WHERE rowid%3 = 1
	GROUP BY v
	ORDER BY COUNT(*) DESC
	LIMIT 1;
INSERT INTO key
	SELECT
		(v|32)-(v&32)
	FROM avs
	WHERE rowid%3 = 2
	GROUP BY v
	ORDER BY COUNT(*) DESC
	LIMIT 1;
INSERT INTO key
	SELECT
		(v|32)-(v&32)
	FROM avs
	WHERE rowid%3 = 0
	GROUP BY v
	ORDER BY COUNT(*) DESC
	LIMIT 1;

/*
SELECT * FROM key;

SELECT
	GROUP_CONCAT(CHAR((key.v|avs.v)-(key.v&avs.v)), '')
	FROM avs
	JOIN key ON avs.rowid%3 = key.rowid%3;
*/

SELECT SUM((key.v|avs.v)-(key.v&avs.v))
	FROM avs
	JOIN key ON avs.rowid%3 = key.rowid%3;
