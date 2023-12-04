WITH RECURSIVE factorials(n, f) AS (
	SELECT 1, 1
	UNION ALL
	SELECT n + 1, (n + 1)*f FROM factorials
	WHERE n < 9
), idxs(n, i, r) AS (
	SELECT 10, 0, 999999
	UNION ALL
	SELECT idxs.n - 1, r/f, r%f
	FROM idxs
	JOIN factorials ON idxs.n - 1 = factorials.n
), tmp_digits(n, res, rem) AS (
	SELECT 9, '', '0123456789'
	UNION ALL
	SELECT
		tmp_digits.n - 1,
		res || substr(rem, idxs.i + 1, 1),
		substr(rem, 1, idxs.i) || substr(rem, idxs.i + 2)
	FROM tmp_digits
	JOIN idxs ON tmp_digits.n = idxs.n
)
SELECT res || rem FROM tmp_digits WHERE n = 0;

