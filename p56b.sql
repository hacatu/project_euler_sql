WITH RECURSIVE bpow_vals(base, pow_str, e) AS (
	SELECT value, '1', 99
	FROM GENERATE_SERIES(2, 99)
	UNION ALL
	SELECT
		base,
		DECIMAL_MUL(base, pow_str),
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

