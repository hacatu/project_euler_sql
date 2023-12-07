/*
CREATE TABLE mats(a INT, b INT, c INT, d INT, e INT, f INT, g INT, h INT, i INT);
INSERT INTO mats SELECT * FROM (VALUES (-2, 1, 2, -1, 2, 2, -2, 2, 3), (2, 1, 2, 1, 2, 2, 2, 2, 3), (1, -2, 2, 2, -1, 2, 2, -2, 3));

WITH RECURSIVE xyz(x, y, z, depth) AS (
	SELECT 1, 1, 1, 0
	UNION ALL
	SELECT
		a*x + b*y + c*z as x1,
		d*x + e*y + f*z as y1,
		g*x + h*y + i*z as z1,
		depth + 1 as d1
	FROM xyz
	JOIN mats ON x != y OR mats.rowid < 3
	WHERE depth < 20 AND z1 < 10000000
), ijkls(i, j, k, l) AS (
	SELECT
		(x + 1)/6 as i,
		(y + 1)/6 as j,
		(z + 1)/6 as k,
		(CAST(SQRT(y*y + z*z - 1) AS INT) + 1)/6 as l
	FROM xyz
	WHERE x%6 = 5 AND y%6 = 5 AND z%6 = 5 AND y*y + z*z = 1 + (6*l - 1)*(6*l - 1)
)
SELECT i, j, k, l FROM ijkls;
*/

/*
for(uint64_t k = 3, Pk = 12;; Pk += 3*++k - 2){
	for(uint64_t j = k - 1, Pj = Pk - 3*k + 2; j; Pj -= 3*j-- - 2){
		uint64_t Pd = Pk - Pj;
		uint64_t base, exp;
		if(!nut_u64_is_perfect_power(24*Pd + 1, 2, &base, &exp) || base%6 != 5){
			continue;
		}
		uint64_t Pl = Pj + Pk;
		if(!nut_u64_is_perfect_power(24*Pl + 1, 2, &base, &exp) || base%6 != 5){
			continue;
		}
		printf("%"PRIu64" + %"PRIu64"\n", Pd, Pj);
		return 0;
	}
}
*/

WITH RECURSIVE cte(k, Pk, j, Pj, pd, pdr, pl, plr) AS (
	SELECT 2, 5, 0, 0, 169, 13, 1, 1
	UNION ALL
	SELECT
		IIF(j > 0, k, k + 1),
		IIF(j > 0, Pk, Pk + 3*k + 1),
		IIF(j > 0, j - 1, k),
		IIF(j > 0, Pj - 3*j + 2, Pk),
		IIF(j > 0, pd + 72*j - 48, 72*k + 25),
		CAST(SQRT(IIF(j > 0, pd + 72*j - 48, 72*k + 25)) AS INT),
		IIF(j > 0, pl - 72*j + 48, 48*Pk + 72*k + 25),
		CAST(SQRT(IIF(j > 0, pl - 72*j + 48, 48*Pk + 72*k + 25)) AS INT)
	FROM cte
	WHERE NOT (j > 0 AND pdr*pdr = pd AND pdr%6 = 5 AND plr*plr = pl AND plr%6 = 5)
)
SELECT Pk - Pj FROM cte WHERE j > 0 AND pdr*pdr = pd AND pdr%6 = 5 AND plr*plr = pl AND plr%6 = 5;

