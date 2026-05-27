/*
We will assume that every digit occurs exactly once,
so there are 8 digits, and we can find them one at a time:
- last digit = (or together last) & ~ (or together nonlast)
- transform partial passcodes by removing last digit and removing them if they are now 1 digit
*/
CREATE TABLE partial_tmp(part INT);
.import 0079_keylog.txt partial_tmp

CREATE TABLE partials0(part INT);
INSERT INTO partials0
SELECT 1000+part FROM partial_tmp;

DROP TABLE partial_tmp;

CREATE TABLE digits(d INT, i INT);

INSERT INTO digits
WITH RECURSIVE cte(land, hand, i) AS (
	SELECT 0, 0, 1
	UNION ALL
	SELECT
		land | (1 << (part%10)),
		hand | (1 << (part/10%10)) | IIF(part >= 1000, (1 << (part/100)), 0),
		i+1
	FROM cte
	JOIN partials0 ON i=rowid
)
SELECT CAST(ROUND(LOG2(land&~hand)) AS INT), 0 FROM cte
	ORDER BY cte.i DESC LIMIT 1;

CREATE TABLE partials1(part INT);
INSERT INTO partials1
SELECT DISTINCT IIF(part%10 = d, IIF(part >= 1000, part/10, 0), part) as mine
FROM partials0 JOIN digits WHERE i=0 AND mine!=0;

DROP TABLE partials0;

INSERT INTO digits
WITH RECURSIVE cte(land, hand, i) AS (
	SELECT 0, 0, 1
	UNION ALL
	SELECT
		land | (1 << (part%10)),
		hand | (1 << (part/10%10)) | IIF(part >= 1000, (1 << (part/100)), 0),
		i+1
	FROM cte
	JOIN partials1 ON i=rowid
)
SELECT CAST(ROUND(LOG2(land&~hand)) AS INT), 1 FROM cte
	ORDER BY cte.i DESC LIMIT 1;

CREATE TABLE partials2(part INT);
INSERT INTO partials2
SELECT DISTINCT IIF(part%10 = d, IIF(part >= 1000, part/10, 0), part) as mine
FROM partials1 JOIN digits WHERE i=1 AND mine!=0;

DROP TABLE partials1;

INSERT INTO digits
WITH RECURSIVE cte(land, hand, i) AS (
	SELECT 0, 0, 1
	UNION ALL
	SELECT
		land | (1 << (part%10)),
		hand | (1 << (part/10%10)) | IIF(part >= 1000, (1 << (part/100)), 0),
		i+1
	FROM cte
	JOIN partials2 ON i=rowid
)
SELECT CAST(ROUND(LOG2(land&~hand)) AS INT), 2 FROM cte
	ORDER BY cte.i DESC LIMIT 1;

CREATE TABLE partials3(part INT);
INSERT INTO partials3
SELECT DISTINCT IIF(part%10 = d, IIF(part >= 1000, part/10, 0), part) as mine
FROM partials2 JOIN digits WHERE i=2 AND mine!=0;

DROP TABLE partials2;

INSERT INTO digits
WITH RECURSIVE cte(land, hand, i) AS (
	SELECT 0, 0, 1
	UNION ALL
	SELECT
		land | (1 << (part%10)),
		hand | (1 << (part/10%10)) | IIF(part >= 1000, (1 << (part/100)), 0),
		i+1
	FROM cte
	JOIN partials3 ON i=rowid
)
SELECT CAST(ROUND(LOG2(land&~hand)) AS INT), 3 FROM cte
	ORDER BY cte.i DESC LIMIT 1;

CREATE TABLE partials4(part INT);
INSERT INTO partials4
SELECT DISTINCT IIF(part%10 = d, IIF(part >= 1000, part/10, 0), part) as mine
FROM partials3 JOIN digits WHERE i=3 AND mine!=0;

DROP TABLE partials3;

INSERT INTO digits
WITH RECURSIVE cte(land, hand, i) AS (
	SELECT 0, 0, 1
	UNION ALL
	SELECT
		land | (1 << (part%10)),
		hand | (1 << (part/10%10)) | IIF(part >= 1000, (1 << (part/100)), 0),
		i+1
	FROM cte
	JOIN partials4 ON i=rowid
)
SELECT CAST(ROUND(LOG2(land&~hand)) AS INT), 4 FROM cte
	ORDER BY cte.i DESC LIMIT 1;

CREATE TABLE partials5(part INT);
INSERT INTO partials5
SELECT DISTINCT IIF(part%10 = d, IIF(part >= 1000, part/10, 0), part) as mine
FROM partials4 JOIN digits WHERE i=4 AND mine!=0;

DROP TABLE partials4;

INSERT INTO digits
WITH RECURSIVE cte(land, hand, i) AS (
	SELECT 0, 0, 1
	UNION ALL
	SELECT
		land | (1 << (part%10)),
		hand | (1 << (part/10%10)) | IIF(part >= 1000, (1 << (part/100)), 0),
		i+1
	FROM cte
	JOIN partials5 ON i=rowid
)
SELECT CAST(ROUND(LOG2(land&~hand)) AS INT), 5 FROM cte
	ORDER BY cte.i DESC LIMIT 1;

CREATE TABLE partials6(part INT);
INSERT INTO partials6
SELECT DISTINCT IIF(part%10 = d, IIF(part >= 1000, part/10, 0), part) as mine
FROM partials5 JOIN digits WHERE i=5 AND mine!=0;

DROP TABLE partials5;

/*
Now, partials6 will contain ONE partial, equal to '1ab', where 'ab' is the start of the passcode.
*/

INSERT INTO digits
SELECT part%100, 6 FROM partials6;

SELECT SUM(d*POW(10, i)) FROM digits;

