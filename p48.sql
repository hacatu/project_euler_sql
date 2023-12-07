WITH RECURSIVE tmp_powers(b, p2, s2, p5, s5, t) AS (
	SELECT 1, 1, 1, 1, 1, 1
	UNION ALL
	SELECT
		IIF(t <= b, b, b + 1),
		IIF(t <= b, IIF(t&b != 0, s2*p2%1024, p2), 1),
		IIF(t <= b, s2*s2%1024, b + 1),
		IIF(t <= b, IIF(t&b != 0, s5*p5%9765625, p5), 1),
		IIF(t <= b, s5*s5%9765625, b + 1),
		IIF(t <= b, t << 1, 1)
	FROM tmp_powers
	WHERE b < 1000
), crt(p2, p5, p10, t) AS (
	SELECT SUM(p2)%1024, SUM(p5)%9765625, SUM(p5)%9765625, 1
	FROM tmp_powers WHERE t > b
	UNION ALL
	SELECT p2, p5, IIF(p10%t = p2%t, p10, t/2*9765625 + p10), 2*t
	FROM crt
	WHERE t <= 1024
)
SELECT p10 FROM crt WHERE t > 1024;