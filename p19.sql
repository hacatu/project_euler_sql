CREATE TABLE months(name TEXT, len INT);
INSERT INTO months VALUES
	('january', 31),
	('february', 28),
	('march', 31),
	('april', 30),
	('may', 31),
	('june', 30),
	('july', 31),
	('august', 31),
	('september', 30),
	('october', 31),
	('november', 30),
	('december', 31);

WITH RECURSIVE firsts(dow, month, year) AS (
	SELECT 1, 'january', 1900
	UNION ALL
	SELECT
		(dow + month.len + IIF(month.name = 'february' AND year%4 = 0 AND (year%100 != 0 OR year%400 = 0), 1, 0))%7,
		next_month.name,
		year + IIF(month.name = 'december', 1, 0)
	FROM firsts
	JOIN months month on month.name = firsts.month
	JOIN months next_month on (month.rowid + 1 - next_month.rowid)%12 = 0
	WHERE year <= 2000 
)
SELECT COUNT() FROM firsts WHERE dow = 0 AND year > 1900;

