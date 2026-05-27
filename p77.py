from sympy.ntheory import sieve
import itertools as itt

with open("p77.sql", "w") as f:
	ps = list(sieve.primerange(100))
	print("CREATE TABLE q(n INT, p INT, v INT);", file=f)
	print("INSERT INTO q SELECT value, 2, 1-value%2 FROM GENERATE_SERIES(0, 100);", file=f)
	for p1, p in itt.pairwise(ps):
		print("INSERT INTO q", file=f)
		print("WITH RECURSIVE cte(n, v) AS (", file=f)
		print(f"\tSELECT n, v FROM q WHERE n < {p} AND p={p1}", file=f)
		print("\tUNION ALL", file=f)
		print(f"\tSELECT cte.n+{p} AS nn, cte.v+q.v FROM cte", file=f)
		print("\tJOIN q ON nn = q.n", file=f)
		print(f"\tWHERE nn <= 100 AND q.p = {p1}", file=f)
		print(")", file=f)
		print(f"SELECT n, {p}, v FROM cte;", file=f)

