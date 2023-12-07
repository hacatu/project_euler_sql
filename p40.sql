CREATE TABLE dis AS
WITH RECURSIVE cte(idx) AS (
	SELECT 1
	UNION ALL
	SELECT 10*idx as n
	FROM cte
	WHERE n <= 1000000
)
SELECT * FROM cte;

WITH RECURSIVE champ_blocks(start_idx, l, f) AS (
	SELECT 1, 1, 1
	UNION ALL
	SELECT start_idx + 9*l*f as s, l + 1, 10*f
	FROM champ_blocks
	WHERE s <= 1000000
), champ_digits(idx, start_idx, d) AS (
	SELECT idx, start_idx, substr(f + (idx - start_idx)/l, (idx - start_idx)%l + 1, 1)
	FROM dis
	JOIN champ_blocks ON idx BETWEEN start_idx AND start_idx + 9*l*f - 1
)
SELECT ROUND(EXP(SUM(LN(d)))) FROM champ_digits;

