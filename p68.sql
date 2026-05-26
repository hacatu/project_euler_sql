WITH cands(a, b, c, d, e, total) AS (
	SELECT a.value, b.value, c.value, d.value, e.value, (a.value + b.value + c.value + d.value + e.value)/5 + 11
	FROM GENERATE_SERIES(1, 9) a
	JOIN GENERATE_SERIES(1, 9) b
	JOIN GENERATE_SERIES(1, 9) c
	JOIN GENERATE_SERIES(1, 9) d
	JOIN GENERATE_SERIES(1, 9) e
	WHERE (a.value + b.value + c.value + d.value + e.value)%5 = 0
)
SELECT MAX(CONCAT(total-a-b,a,b,total-b-c,b,c,total-c-d,c,d,total-d-e,d,e,total-e-a,e,a)) FROM cands
	WHERE total - a - b > 0 AND total - b - c > 0 AND total - c - d > 0 AND total - d - e > 0 AND total - e - a > 0
	AND (1 << a) | (1 << b) | (1 << c) | (1 << d) | (1 << e) | (1 << (total - a - b)) | (1 << (total - b - c)) | (1 << (total - c - d)) | (1 << (total - d - e)) | (1 << (total - e - a)) = 2046
	AND a > c AND a + b > c + d AND a + b > d + e AND b > e;

