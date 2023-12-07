/*
If we concatenate a, 2a, 3a, ..., na to get a 1-9 pandigital product,
then if a has k digits and na has l digits, l is either k or k + 1.
If there is no carry / l = k, then a, 2a, 3a, ..., na all have k digits,
and thus k*n = 9, so n = 3 or 9.  In the n = 9 case, a = 1 so the product
is 12345689, which is not larger than the example.  So if l = k,
n = k = 3.

If l = k + 1, then:
- If len(2a) = l: 9 = k + (n - 1)(k + 1) = nk + n - 1
    n >= 2 so n = 2 -> 2k + 1 = 9 -> k = 4
	          n = 3 -> 3k + 2 = 9 -> n/a
			  n = 4 -> 4k + 3 = 9 -> n/a
			  n = 5 -> 5k + 4 = 9 -> k = 1
- Elif len(3a) = l: 2k + (n - 2)(k + 1) = nk + n - 2
    n = 3 -> 3k + 1 = 9 -> n/a
	n = 4 -> 4k + 2 = 9 -> n/a
	n = 5 -> 5k + 3 = 9 -> n/a
- Elif len(4a) = l: nk + n - 3
    n = 4 -> 4k + 1 = 9 -> k = 2
	n = 5 -> 5k + 2 = 9 -> n/a
	n = 6 -> 6k + 3 = 9 -> k = 1
- Elif len(5a) = l: n/a
- Elif len(6a) = l: 2n - 5 = 9 -> n = 7, k = 1
- Elif len(7a) = l: n/a
- Elif len(8a) = l: n = 8, k = 1

So we can have:
1: a*(1, 2, 3) = (abc, def, ghi)
   a is 123 to 329.  But this means a cannot start with 9, so
   abcdefghi cannot exceed the given example.
2: a*(1, 2) = (abcd, efghi)
   a is 6173 to 9382, But to exceed the given example, it must be
   between 9183 and 9382, so 2a is between 18367 and 18764.
   This means we cannot have 1 or 8 in a though, so it is further
   limited to between 9234 and 9376, so 2a is between 18472 and 18752
   We can't go further without breaking into cases on the second digit of a.
   Case 9234 <= a <= 9276 -> 18476 <= 2a <= 18546
   9273, 18546
   Case 9324 <= a <= 9376 -> 18652 <= a <= 18752
3: a*(1, 2, 3, 4, 5) = (a, bc, de, fg, hi)
   6 <= a <= 9
   (6, 12, 18, 24, 30) - not pandigital
   (7, 14, 21, 28, 35) - not pandigital
   (8, 16, 24, 32, 40) - not pandigital
   (9, 18, 27, 36, 45) - YAY
4: a*(1, 2, 3, 4) = (ab, cd, ef, ghi)
   3a <= 96, 12 <= a, 124 <= 4a
   12, 31 <= a <= 32, but neither (31, 62, 93, 124) nor (32, 64, 96, 128)
   is pandigital
5: a*(1, 2, 3, 4, 5, 6) = (a, b, c, de, fg, hi)
   Since 3a = c is a single digit but 4a = de is two,
   a = 3, but (3, 6, 9, 12, 15, 18) is not pandigital.
6: a*(1, 2, 3, 4, 5, 6, 7) = (a, b, c, d, e, fg, hi)
   If a >= 2, e >= 10, so a = 1.  However, this means that fg should = 6,
   so this case is impossible
7: a*(1, 2, 3, 4, 5, 6, 7, 8) = (a, b, c, d, e, f, g, hi)
   This case is impossible for the same reason as (6)
*/
SELECT value as a, 2*value as b FROM GENERATE_SERIES(9376, 9234, -1)
WHERE (1<<a%10)|(1<<a/10%10)|(1<<a/100%10)|(1<<2*a%10)|(1<<2*a/10%10)|(1<<2*a/100%10) = 252
LIMIT 1;

