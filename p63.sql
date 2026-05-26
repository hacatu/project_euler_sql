/*
If an n-digit number x is an n-th power, we must have
x = b^n, 10^n > x >= 10^(n-1)
10^n > b^n >= 10^(n-1)
10 > b AND b^n >= 10^(n-1).

If b=1, x=1, so this is only an option for n=1.  Otherwise, we can have 2 <= b <= 9,
and the first inequality will be trivially true, so we just need to consider
b^n >= 10^(n-1).  In SQL, LOG is base 10, so we have
n * LOG(b) >= n - 1
1 >= (1 - LOG(b)) * n
1/(1 - LOG(b)) >= n >= 1

Does this also hold for b=1?

1/(1 - 0) = 1

yes.
*/

SELECT SUM(CAST(1/(1-LOG(value)) AS INT)) FROM GENERATE_SERIES(1, 9);

