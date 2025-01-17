CREATE TABLE lines(line);
.import 0054_poker.txt lines

CREATE TABLE card_values AS 
SELECT
	value as name,
	value
FROM GENERATE_SERIES(2, 9)
UNION ALL
SELECT * FROM (VALUES ('T', 10), ('J', 11), ('Q', 12), ('K', 13), ('A', 14));

CREATE TABLE hand_scores AS
WITH raw_hands(str, player, round) AS (
	SELECT
		SUBSTR(line, 1 + 15*(value - 1), 14) AS str,
		value AS player,
		lines.rowid AS round
	FROM lines
	JOIN GENERATE_SERIES(1, 2)
), hand_masks(str, mask, suites, player, round) AS (
	SELECT
		str,
		REPLACE(GROUP_CONCAT(14 - LENGTH(REPLACE(str, name, '')) ORDER BY value), ',', ''),
		SUBSTR(str, 2, 1) || SUBSTR(str, 5, 1) || SUBSTR(str, 8, 1) || SUBSTR(str, 11, 1) || SUBSTR(str, 14, 1),
		player,
		round
	FROM raw_hands
	JOIN card_values
	GROUP BY player, round
), hand_tiebreakers(str, mask, is_flush, tiebreaker, player, round) AS (
	SELECT
		str,
		mask,
		LENGTH(REPLACE(suites, 'H', ''))*LENGTH(REPLACE(suites, 'C', ''))*LENGTH(REPLACE(suites, 'D', ''))*LENGTH(REPLACE(suites, 'S', '')) == 0,
		(WITH singletons(value) AS (
			SELECT value FROM GENERATE_SERIES(2, 14) WHERE SUBSTR(mask, value - 1, 1) == '1'
		), psums(value, row_number) AS (
			SELECT value, ROW_NUMBER() OVER (ORDER BY value) FROM singletons
		) SELECT SUM(value << (4*row_number - 4)) FROM psums),
		player,
		round
	FROM hand_masks
)
SELECT str, mask, player, round,
	/*
	The value assigned to each hand is a 6 digit base 16 number.
	The most significant digit ranges from 0 for no special hand up to 8 for a straight flush:
	0) no special
	1) pair
	2) 2 pair
	3) 3 of a kind
	4) straight
	5) flush
	6) full house (3 of a kind + pair)
	7) 4 of a kind
	8) staight flush (including royal flush)
	Then the remaining 5 digits are populated as needed to break ties correctly.
	It's "easy" to find one or two values with given multiplicity using "mask", for example in a 2 pair we can find
	the larger and smaller pair (values with multiplicity 2) and the remaining number (value with multiplicity 1)
	as the last and first 2s in "mask" and the first 1 in "mask" respectively.
	However, while storing "mask" as a string is usually more convenient than storing it as an integer or splitting it across rows and
	using window/aggregate functions, it does present some problems for (0), (1), and (5), where there are 3 or more values with the
	same multiplicity, since we cannot just use "LTRIM" and "RTRIM" to find the index of the first and last value with that multiplicity.
	So we will handle these in a later pass
	*/
	IIF(
		is_flush,
		CASE /* is a flush */
		WHEN mask LIKE '%11111%' THEN /* a straight flush, including a royal flush */
			(8 << 20) + (15 - LENGTH(LTRIM(mask, '0')))
		/* 4 of a kind is not possible in a flush */
		/* A full house is not possible in a flush */
		ELSE /* a flush */
			(5 << 20) + tiebreaker
		END,
		CASE /* isn't a flush */
		WHEN mask LIKE '%4%' THEN /* 4 of a kind */
			/* v-- 4 of a kind        v-- value of quadruplicate number         v-- value of remaining number */
			(7 << 20) + ((15 - LENGTH(LTRIM(mask, '01'))) << 4) + (15 - LENGTH(LTRIM(mask, '04')))
		WHEN mask LIKE '%3%' AND mask LIKE '%2%' THEN /* full house */
			/* v-- full house         v-- value of triplicate number          v-- value of duplicate nuber */
			(6 << 20) + ((15 - LENGTH(LTRIM(mask, '02'))) << 4) + (15 - LENGTH(LTRIM(mask, '03')))
		/* a flush isn't possible in this case */
		WHEN mask LIKE '%11111%' THEN /* a straight */
			/* v-- flush             v-- value of smallest element */
			(4 << 20) + (15 - LENGTH(LTRIM(mask, '0')))
		WHEN mask LIKE '%3%' THEN /* 3 of a kind, and not a full house or 4 of a kind by case ordering */
		    /* v-- 3 of a kind           v-- value of triplicate number      v-- value of larger remaining number    v-- value of smaller remaining number */
			(3 << 20) + ((15 - LENGTH(LTRIM(mask, '01'))) << 8) + ((2 + LENGTH(RTRIM(mask, '03'))) << 4) + (15 - LENGTH(LTRIM(mask, '03')))
		WHEN mask LIKE '%2%2%' THEN /* 2 pair, and not a full house or 4 of a kind by case ordering */
			/* v-- 2 pair             v-- value of larger duplicate number        v-- value of smaller duplicate number       v-- value of remaining number */
			(2 << 20) + ((2 + LENGTH(RTRIM(mask, '01'))) << 8) + ((15 - LENGTH(LTRIM(mask, '01'))) << 4) + (15 - LENGTH(LTRIM(mask, '02')))
		WHEN mask LIKE '%2%' THEN /* a pair, and not a better hand by case ordering */
			/* v-- a pair            v-- value of duplicate number */
			(1 << 20) + ((15 - LENGTH(LTRIM(mask, '01'))) << 12) + tiebreaker
		ELSE /* no special hand */
			tiebreaker
		END
	) AS score
FROM hand_tiebreakers;

SELECT COUNT(*)
FROM hand_scores a
JOIN hand_scores b
ON a.round == b.round AND a.player == 1 AND b.player == 2
WHERE a.score > b.score;

