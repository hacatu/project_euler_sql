/* stage:
0: add n1 to n1 reversed and store the result in n2
1: move n2 to n1 and reset idx
2: check if n1 is a palindrome
3: n1 is a palindrome
4: reset idx and return to stage 0
5: 50 generations reached, n1 is assumed lychrel
 */
WITH RECURSIVE raa_values(n1, n2, generation, stage, idx, carry) AS (
	SELECT
		CAST(value AS TEXT),
		'',
		0,
		0,
		1,
		0
	FROM GENERATE_SERIES(4, 9999)
	UNION ALL
	SELECT
		IIF(stage == 1, IIF(carry != 0, carry || n2, n2), n1),
		CASE stage
			WHEN 0 THEN ((SUBSTR(n1, idx, 1) + SUBSTR(n1, -idx, 1) + carry)%10) || n2
			ELSE ''
		END,
		IIF(stage == 1, generation + 1, generation),
		CASE stage
			WHEN 0 THEN IIF(idx == LENGTH(n1), 1, 0)
			WHEN 1 THEN 2
			WHEN 2 THEN CASE
				WHEN idx >= LENGTH(n1) + 1 - idx THEN 3
				WHEN SUBSTR(n1, idx, 1) != SUBSTR(n1, -idx, 1) THEN IIF(generation >= 50, 5, 4)
				ELSE 2
			END
			WHEN 3 THEN 3
			WHEN 4 THEN 0
			WHEN 5 THEN 5
		END,
		CASE stage
			WHEN 0 THEN idx + 1
			WHEN 1 THEN 1
			WHEN 2 THEN idx + 1
			WHEN 3 THEN 1
			WHEN 4 THEN 1
			WHEN 5 THEN 1
		END,
		IIF(stage == 0, CAST((SUBSTR(n1, idx, 1) + SUBSTR(n1, -idx, 1) + carry)/10 AS INT), 0)
	FROM raa_values
	WHERE stage != 3 AND stage != 5
)
SELECT COUNT(*) FROM raa_values
WHERE stage == 5;

