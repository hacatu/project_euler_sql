/*
This problem doesn't really require all these optimizations because the number
of permutations of 9 items is not too large, but there are still a lot of
observations we can make that lead to these optimizations.
Simpler code that just loops over all the numbers might be faster, but that's ok.

First, we know that a k digit number times an l digit number is either k + l - 1
or k + l if there is "carry".  However, if the product is k + l digits,
the total number of digits will be even so the equation cannot be 1-9 pandigital,
thus there cannot be "carry".

Further, we can assume wlog that a < b.  So if a has k digits and b has l digits,
a*b = c has k + l - 1 digits, so 2*k + 2*l - 1 = 9 <-> k + l = 5.
Thus not only is a < b but k < l (a has fewer digits).

So a can have either 1 or 2 digits, in which case b will have 4 or 3 respectively.

Next, we can check a*b = c mod 9: since a*b = c must be 1-9 pandigital,
digitsum(a) + digitsum(b) + digitsum(c) = 45, giving
a + b + a*b = 0 mod 9.
We can solve this for b to get: b = -a*(a + 1)**-1 mod 9.
Not only does this lock b down to one possible residue mod 9 for any fixed a,
it excludes a where a + 1 isn't invertable mod 9, ie a must not be 2 mod 3.
Since the equation a + b + a*b = 0 mod 9 is symmetric, this restriction also
holds for b.

Moreover, a and b cannot end in 1 (or 0) or else the last digit of c would be
the same as the last digit of the other term.

To check if a*b=c is actually pandigital, we can use bitmasks, where the ith
lowest bit (starting from 1) is set if the digit i occurs in the number.
This lets us check if a k digit number has no repeated digits by checking if
the number of set bits BIT_COUNT(dmask) = k.

Finally, we can set some limits on a and b.
In the case where a is 1 digit, we know that this digit must be
0, 1, 3, 4, 6, 7, 9 based on the restriction that a cannot be 2 mod 3.
But a also cannot be 0 or 1, or else the last digit of c would be a repeat.
Lastly, a cannot be 9, since if c is maximized at 8765, b = c/a still will not
be 4 digits since 8765/9 = 973.(8).
This limits the candidate one digit values of a to 3, 4, 6, and 7.

The minimal value for b is at least 1234, and the maximal value is at most
9876/3 = 3292.  Since this limit is assuming a = 3, b must be 6 mod 9.
If we bump a up to 4, the limit would go down to 2469, and if we bump c down to
8976, the limit would go down to 2992.  So we can apply logic assuming a=3 and c starts
with 9 to reduce 3292 as long as we don't push it below 2992.
But if a=3, b can't start with 3, so the maximal b is at most 2987 and we will have
to check c starting with 8 as well as 9.
If c starts with 9, the maximum goes down to 2876, and by the modular condition down to
2868, and by digit restrictions down to 2814.
On the other hand if c starts with 8, we can push 2992 down to 2976.  BUT we have to check
if this is still possible with c = 8541, and indeed it isn't, so by the modular condition
we can push it to 2967 which will suffer the same problem, and then digit restrictions
actually let us push this down to 2796, which now is compatible with c = 8541.

So overall we get 1234 < b < 2814 for 1 digit a.

In the case where a is 2 digits, we start with an upper bound on a:
9876/123 >= 80 starts the upper bound at 79, but that's not compatible
with c = 9876 so we check if it's compatible with c = 8654, and indeed it isn't since
8654/123 >= 70.  Thus a <= 78.  Is this compatible with c = 9654?  Yes, so
78 is the upper bound on a.

And for b, 123 <= b <= 9876/12 = 823.  Similar to the 1 digit a case, this is incompatible.
If a = 13 instead, 9876/13 >= 759, or 751 taking modularity into account, then 742
since 1 cannot be the last digit.  But staying with 12, b can't start with 8
unless 9765/12 = 813 is compatible, but it isn't since the 1 repeats in 12 and 813.
So with a = 12, we can lower the max b to 798.  8765/12 = 730, so lower to 786.
By modularity, lower to 780, then 753 by digit restrictions

So overall we get 12 <= a <= 78 and 123 <= b <= 753 for 2 digit a
*/
WITH a1s(a, r, dmask) AS (
	SELECT column1, column1, 1<<column1>>1 FROM (VALUES (3), (4), (6), (7))
), a2s(a, r, dmask) AS (
	SELECT n, r, (1<<n%10)|(1<<n/10)>>1
	FROM (
		SELECT k.value*9 + r.value as n, r.value as r
		FROM (
			SELECT value
			FROM GENERATE_SERIES(0, 8)
			WHERE value%3 != 2
		) r
		CROSS JOIN GENERATE_SERIES(0, 78/9) k
		WHERE (n BETWEEN 12 AND 78) AND n%10 > 1 AND n%11 != 0
		ORDER BY n
	)
), b4s(a, r, dmask) AS (
	SELECT n, r, (1<<n%10)|(1<<n/10%10)|(1<<n/100%10)|(1<<n/1000)>>1 as dmask
	FROM (
		SELECT k.value*9 + r.value as n, r.value as r
		FROM (
			SELECT value
			FROM GENERATE_SERIES(0, 8)
			WHERE value%3 != 2
		) r
		CROSS JOIN GENERATE_SERIES(0, 2814/9) k
		WHERE (n BETWEEN 1234 AND 2814) AND n%10 > 1
	)
	-- This bit twiddling counts the bits set in dmask.  The magic constant 59796 has 2 lowest bits set to 00 (0)
	-- representing the bit count of 000 (0), the next 2 bits set to 01 (1) representing the bit count of 001 (1), and so on,
	-- up to the last group of 2 bits which is 11 (3) representing the bit count of 111 (7)
	-- note that * has higher precedence than + which has higer precedence than & and >>, and operators in the same precedence are left associative (left to right)
	WHERE (59796>>2*(dmask&7)&3) + (59796>>2*(dmask>>3&7)&3) + (59796>>2*(dmask>>6&7)&3) = 4
	ORDER BY n
), b3s(a, r, dmask) AS (
	SELECT n, r, (1<<n%10)|(1<<n/10%10)|(1<<n/100)>>1 as dmask
	FROM (
		SELECT k.value*9 + r.value as n, r.value as r
		FROM (
			SELECT value
			FROM GENERATE_SERIES(0, 8)
			WHERE value%3 != 2
		) r
		CROSS JOIN GENERATE_SERIES(0, 753/9) k
		WHERE (n BETWEEN 123 AND 753) AND n%10 > 1
	)
	WHERE (59796>>2*(dmask&7)&3) + (59796>>2*(dmask>>3&7)&3) + (59796>>2*(dmask>>6&7)&3) = 3
	ORDER BY n
), products(c) AS (
	SELECT DISTINCT a2s.a*b3s.a as c
	FROM a2s
	JOIN b3s ON (a2s.dmask&b3s.dmask) = 0 AND (a2s.r + b3s.r + a2s.r*b3s.r)%9 = 0
	WHERE (c BETWEEN 1234 AND 9876) AND ((1<<c%10)|(1<<c/10%10)|(1<<c/100%10)|(1<<c/1000)>>1|a2s.dmask|b3s.dmask) = 511
	UNION
	SELECT DISTINCT a1s.a*b4s.a as c
	FROM a1s
	JOIN b4s ON (a1s.dmask&b4s.dmask) = 0 AND (a1s.r + b4s.r + a1s.r*b4s.r)%9 = 0
	WHERE (c BETWEEN 1234 AND 9876) AND ((1<<c%10)|(1<<c/10%10)|(1<<c/100%10)|(1<<c/1000)>>1|a1s.dmask|b4s.dmask) = 511
)
SELECT SUM(c) FROM products;

