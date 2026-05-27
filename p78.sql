WITH RECURSIVE cte(pstr, n, ka, kb, k, acc) AS (
	SELECT '000001', 1, 0, 2, 2, 1
	UNION ALL
	SELECT
		IIF(k = kb, CONCAT(pstr, FORMAT('%06u', acc)), pstr),
		IIF(k = kb, n+1, n),
		IIF(k = kb, CAST(CEIL(-(SQRT(24*(n+1) + 1) - 1)/6) AS INT), ka),
		IIF(k = kb, CAST(FLOOR((SQRT(24*(n+1) + 1) + 1)/6) AS INT) + 1, kb),
		CASE k WHEN kb THEN 0 WHEN 0 THEN ka WHEN -1 THEN 1 ELSE k + 1 END,
		CASE k WHEN kb THEN 0 WHEN 0 THEN acc ELSE (acc+1000000+CAST(SUBSTR(pstr, (n - k*(3*k-1)/2)*6+1, 6) AS INT)*IIF(k%2=0, -1, 1))%1000000 END
	FROM cte
	WHERE k != kb OR acc != 0
	--WHERE k != 0 OR n <= 100
)
SELECT n FROM cte WHERE k = kb AND acc = 0;

