WITH singles(num, name) AS (
	SELECT *
	FROM (VALUES
		(1, 'one'),
		(2, 'two'),
		(3, 'three'),
		(4, 'four'),
		(5, 'five'),
		(6, 'six'),
		(7, 'seven'),
		(8, 'eight'),
		(9, 'nine'),
		(10, 'ten'),
		(11, 'eleven'),
		(12, 'twelve'),
		(13, 'thirteen'),
		(14, 'fourteen'),
		(15, 'fifteen'),
		(16, 'sixteen'),
		(17, 'seventeen'),
		(18, 'eighteen'),
		(19, 'nineteen')
	)
), enties(digit, name) AS (
	SELECT *
	FROM (VALUES
		(2, 'twenty'),
		(3, 'thirty'),
		(4, 'forty'),
		(5, 'fifty'),
		(6, 'sixty'),
		(7, 'seventy'),
		(8, 'eighty'),
		(9, 'ninety')
	)
), full_names(num, name) AS (
	SELECT num, name FROM singles
	UNION ALL
	SELECT 10*digit, name FROM enties
	UNION ALL
	SELECT 10*digit + num, enties.name || '-' || singles.name
	FROM singles
	CROSS JOIN enties
	WHERE num < 10
	UNION ALL
	SELECT 100*num, name || ' hundred'
	FROM singles
	WHERE num < 10
	UNION ALL
	SELECT 100*a.num + b.num, a.name || ' hundred and ' || b.name
	FROM singles a
	CROSS JOIN singles b
	WHERE a.num < 10
	UNION ALL
	SELECT 100*num + 10*digit, singles.name || ' hundred and ' || enties.name
	FROM singles
	CROSS JOIN enties
	WHERE num < 10
	UNION ALL
	SELECT 100*a.num + 10*digit + b.num, a.name || ' hundred and ' || enties.name || '-' || b.name
	FROM singles a
	CROSS JOIN enties
	CROSS JOIN singles b
	WHERE a.num < 10 AND b.num < 10
	UNION ALL
	SELECT 1000, 'one thousand'
	ORDER BY num
)
SELECT SUM(LENGTH(REPLACE(REPLACE(name, ' ', ''), '-', ''))) FROM full_names;

