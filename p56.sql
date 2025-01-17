WITH RECURSIVE bpow_vals(base, pow_str, e) AS (
	SELECT value, FORMAT('%09i', 1), 99
	FROM GENERATE_SERIES(2, 99)
	UNION ALL
	SELECT
		base,
		(WITH RECURSIVE pprods(tail, carry, i, k) AS (
			SELECT '', 0, 1, CAST(LENGTH(pow_str)/9 AS INT)
			UNION ALL
			SELECT
				FORMAT('%09i', (carry + SUBSTR(pow_str, -9*i, 9)*base)%1000000000) || tail,
				CAST((carry + SUBSTR(pow_str, -9*i, 9)*base)/1000000000 AS INT),
				i + 1,
				k
			FROM pprods WHERE i <= k
		) SELECT IIF(carry != 0, FORMAT('%09i', carry) || tail, tail) FROM pprods WHERE i > k LIMIT 1),
		e - 1
	FROM bpow_vals
	WHERE e > 0
), bpow_dsums(base, dsum, e) AS (
	SELECT
		base,
		(SELECT SUM(SUBSTR(pow_str, value, 1)) FROM GENERATE_SERIES(1, LENGTH(pow_str))),
		e
	FROM bpow_vals
)
SELECT MAX(dsum) FROM bpow_dsums;

