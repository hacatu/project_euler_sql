/*
If we fix the last k digits of x, we know EACH of 2x, 3x, 4x, 5x, and 6x
must contain ALL digits in the last k digits of ANY of 2x, ..., 6x.

Moreover, since 2x, ..., 6x all have the same digits, they must all be equal mod
9, so x must be a multiple of 9.

x cannot end in 0, because then x/10 would be a smaller solution and x would not be minimal.

If x ends in:
1: 2x must contain 23456, which sum to 2 mod 9, so if 2x has 6 digits it must be a permutation of 234567
2: 2x must contain 46802 (2 mod 9), minimal 2x is pi(468027)
3: 2x must contain 69258 (3 mod 9), minimal 2x is pi(692586)
4: 2x must contain 82604 (2 mod 9), minimal 2x is pi(826047)
5: 2x must contain 05 (5 mod 9), minimal 2x is pi(054), so 2x may have as few as 3 digits and we must return to this case
6: 2x must contain 28406 (2 mod 9), minimal 2x is pi(284067)
7: 2x must contain 41852 (2 mod 9), minimal 2x is pi(418527)
8: 2x must contain 64208 (2 mod 9), minimal 2x is pi(642087)
9: 2x must contain 87654 (3 mod 9), minimal 2x is pi(876546)

Now 5 is obviously trouble.  If x ends in any digit besides 5, we've shown 2x must have at least 6 digits and we know
which 6 digits each of 2x, ..., 6x must be a permutation of if 6x is 6 digits.

However, if x ends in 5, we do not yet know if 2x must be more than 3 digits even.  So now consider all 2 digit sequences
ending in 5:
05, 55: 2x must contain 05312 (2 mod 9), minimal 2x is pi(053127)
15, 65: 2x must contain 4057639, so no solution x where 2x is 6 digits can end with 15 or 65.
25, 75: 2x must contain 2705 (5 mod 9), minimal 2x is pi(27054), this is STILL a problematic case (ie a case where solutions under 6 digits are "possible")
35, 85: 2x must contain 40571 (8 mod 9), minimal 2x is pi(405711)
45, 95: 2x must contain 80579 (2 mod 9), minimal 2x is pi(805797)

The 25 and 75 cases:
025: 71502 (6 mod 9), pi(715023)
125: 763502 (5 mod 9), no 6 digit solution
225: 761354902, no 6 digit solution
325: 7635902, no 6 digit solution
425: 715802 (5 mod 9), no 6 digit solution
525: 761502 (3 mod 9), no 6 digit solution
625: 715802 (5 mod 9), no 6 digit solution
725: 761354902, no 6 digit solution
825: 761354902, no 6 digit solution
925: 765802 (1 mod 9), no 6 digit solution
075: 7135402, no 6 digit solution
175: 735802 (7 mod 9), no 6 digit solution
275: 76135802, no 6 digit solution
375: 715802 (5 mod 9), no 6 digit solution
475: 73549802, no 6 digit solution
575: 71354802, no 6 digit solution
675: 73502 (8 mod 9), pi(735021)
775: 76135802, no 6 digit solution
875: 763502 (5 mod 9), no 6 digit solution
975: 759802 (4 mod 9), no 6 digit solution

We now have 16 possible ending strings for x: 1, 2, 3, 4, 6, 7, 8, 9, 05, 35, 45, 55, 85, 95, 025, and 675.
So now let's try to eliminate the long annoying ones.

# 675 :
If x ends with 675, 2x, ..., 6x all must be permutations of 735021, and 2x ends with 350.  So if we focus on 2x, 4x, 6x,
we see 2x = pi(721)350, but 4x must end with 700, so this case is actually impossible (we only have one 0).

# 025 :
Similar to above, if x ends with 025, 4x must end with 100, which is impossible for a permutation of 715023

# 95 :
If x ends with 95, 2x, ..., 6x all must be permutations of 805797, and 2x ends with 90.
So 2x = pi(8577)90, 4x = pi(5797)80, 6x = pi(8597)70.  This hasn't revealed a contradiction yet, so we consider
all 3 possible 100s digits for 2x:
2x = pi(857)790: 4x = pi(797)580, but 6x must end with 370 which is impossible since there is no 3
2x = pi(877)590: 4x must end with 180 which is impossible
2x = pi(577)890: 4x = pi(597)780, but 6x must end with 670 which is impossible

# 85 :
2x = pi(4511)70, 4x = pi(5711)40, 6x = pi(4571)10
2x = pi(451)170: 4x must end with 340 which is impossible
2x = pi(411)570: 4x = pi(571)140, 6x = pi(451)710, so we must also consider 3x and 5x:
                 if x ends with 285, (3x, 5x) end with (855, 425), which is impossible,
				 and if x ends with 785, (3x, 5x) end with (355, 925), which is impossible
2x = pi(511)470: 4x must end with 940 which is impossible

# 55 :
2x = pi(5327)10, 4x = pi(5317)20, 6x = pi(5127)30
2x = pi(532)710: 4x must end with 420 which is impossible
2x = pi(537)210: 4x must end with 420 which is impossible
2x = pi(527)310: 4x must end with 620 which is impossible
2x = pi(327)510: 4x must end with 020 which is impossible

# 45 :
2x = pi(8577)90, 4x = pi(5797)80, 6x = pi(8597)70
This case is impossible for the same reason as 95.

# 35 :
2x = pi(4511)70, 4x = pi(5711)40, 6x = pi(4571)10
This case is impossible for the same reason as 85.
Note that in these impossibility proofs, we are working with 2x, 4x, and 6x, so we aren't actually
checking if there is any x for which 2x actually ends with some digit string because it's not
necessary.  For example, any digit string that ends with 570 will end with either 285 or 785,
so if x ends with 35 the case where 2x ends with 570 isn't even possible to begin with.  But it's fine
to include these unreachable cases as long as we are sure all reachable cases are covered, and this lets
us avoid checking if cases are actually reachable.

# 05 :
This case is impossible for the same reason as 55.

That was a lot of work, but now we have proved that if the minimal x yields 2x, ..., 6x with 6 digits,
then x must end with 1, 2, 3, 4, 6, 7, 8, or 9, and in each case we know which 6 digits 2x, ..., 6x must be
a permutation of.

So now we can check these cases:
1: 2x = pi(34567)2, 4x = pi(23567)4, 6x = pi(23457)6
   2x = pi(3456)72: 4x ends with 44 (impossible)
   2x = pi(3457)62: 4x = pi(3567)24, 6x ends with 86 (impossible)
   2x = pi(3467)52: 4x ends with 04 (impossible)
   2x = pi(3567)42: 4x ends with 84 (impossible)
   2x = pi(4567)32: 4x = pi(2357)64, 6x ends with 96 (impossible)
2: 2x = pi(68027)4, 4x = pi(46027)8, 6x = pi(46807)2
   2x = pi(6802)74: 4x = pi(6027)48, 6x ends with 22 (impossible)
   2x = pi(6807)24: 4x = pi(6027)48, 6x = pi(4680)72
                    if x ends with 12, (3x, 5x) end with (36, 60) (POSSIBLE)
					if x ends with 62, (3x, 5x) end with (86, 10) (POSSIBLE)
   2x = pi(6827)04: 4x = pi(4627)08, 6x  ends with 12 (impossible)
   2x = pi(6027)84: 4x = pi(4027)68, 6x ends with 52 (impossible)
   2x = pi(8027)64: 4x = pi(4607)28, 6x ends with 92 (impossible)
3: 2x = pi(92586)6, 4x = pi(69586)2, 6x = pi(69256)8
   2x = pi(9258)66: 4x ends with 32 (impossible)
   2x = pi(9256)86: 4x ends with 72 (impossible)
   2x = pi(9286)56: 4x ends with 12 (impossible)
   2x = pi(9586)26: 4x = pi(6986)52, 6x ends with 78 (impossible)
   2x = pi(2586)96: 4x = pi(6586)92, 6x endw with 88 (impossible)
4: 2x = pi(26047)8, 4x = pi(82047)6, 6x = pi(82607)4
   2x = pi(2604)78: 4x ends with 56 (impossible)
   2x = pi(2607)48: 4x ends with 96 (impossible)
   2x = pi(2647)08: 4x ends with 16 (impossible)
   2x = pi(2047)68: 4x ends with 36 (impossible)
   2x = pi(6047)28: 4x ends with 56 (impossible)
6: 2x = pi(84067)2, 4x = pi(28067)4, 6x = pi(28407)6
   2x = pi(8406)72: 4x ends with 44 (impossible)
   2x = pi(8407)62: 4x = pi(8067)24, 6x = pi(2407)86
                    this case is not actually reachable because if x ends with 6 then 2x must end with an odd digit followed by 2 (impossible)
   2x = pi(8467)02: 4x = pi(2867)04, 6x = pi(2847)06
                    this case is impossible (see note for 2x = pi(8407)62)
   2x = pi(8067)42: 4x = pi(2067)84, 6x = pi(8407)26
                    this case is impossible (see note for 2x = pi(8407)62)
   2x = pi(4067)82: 4x = pi(2807)64, 6x = pi(2807)46
                    this case is impossible (see note for 2x = pi(8407)62)
7: 2x = pi(18527)4, 4x = pi(41527)8, 6x = pi(41857)2
   2x = pi(1852)74: 4x = pi(1527)48, 6x ends with 22 (impossible)
   2x = pi(1857)24: (impossible) (see note for 6: 2x = pi(8407)62)
   2x = pi(1827)54: 4x ends with 08 (impossible)
   2x = pi(1527)84: (impossible) (see note for 6: 2x = pi(8407)62)
   2x = pi(8527)14: 4x = pi(4157)28, 6x = pi(1857)42
                    if x ends with 07, (3x, 5x) end with (21, 35) (impossible)
					if x ends with 57, (3x, 5x) end with (71, 85) (POSSIBLE)
8: 2x = pi(42087)6, 4x = pi(64087)2, 6x = pi(64207)8
   2x = pi(4208)76: 4x ends with 52 (impossible)
   (the remaining cases are impossible) (see note for 6: 2x = pi(8407)62)
9: 2x = pi(76546)8, 4x = pi(87546)6, 6x = pi(87656)4
   2x = pi(7646)58: 4x ends with 16 (impossible)
   2x = pi(6546)78: 4x = pi(8746)56, 6x ends with 34 (impossible)
   (the remaining cases are impossible) (see note for 6: 2x = pi(8407)62)

After even more work, we are now left with three cases:
1) x ends with 12 (and 2x = pi(6807)24)
2) x ends with 62 (and 2x = pi(6807)24)
3) x ends with 57 (and 2x = pi(8527)14)

In case 1, since x ends with 12, the 100s digit of 2x must be even:
- 2x = pi(687)024: 4x = pi(627)048, 6x = pi(468)072
                   if x ends with 012, (3x, 5x) end with (036, 060) (impossible)
				   if x ends with 512, (3x, 5x) end with (536, 560) (impossible)
- 2x = pi(607)824: 4x = pi(027)648, 6x = pi(680)472
                   if x ends with 412, (3x, 5x) end with (236, 060) (impossible)
				   if x ends with 912, (3x, 5x) end with (736, 560) (impossible)
- 2x = pi(807)624: 4x = pi(607)248, 6x = pi(460)872
                   if x ends with 312, (3x, 5x) end with (936, 560) (impossible)
				   if x ends with 812, (3x, 5x) end with (436, 060) (impossible)
In case 2, since x ends with 62, the 100s digit of 2x must be odd:
- 2x = pi(680)724: 4x ends with 896 (impossible)
In case 3, since x ends with 57, the 100s digit of 2x must be odd:
- 2x = pi(852)714: 4x = pi(157)428, 6x = pi(857)142
                   if x ends with 357, (3x, 5x) end with (071, 785) (impossible)
				   if x ends with 857, (3x, 5x) end with (571, 285) (POSSIBLE)
- 2x = pi(827)514: 4x ends with 028 (impossible)

There is only one case left: (3) x ends with 857 (and 2x = pi(852)714).
Because x ends with 857, the 1000s digit if 2x must be odd, so we must have
2x = pi(82)5714.  There are only 2 permutations of (82), so we can just try both:
if 2x = 825714, 4x would not have the same number of digits as 2x so this is impossible.
if 2x = 285714, we get x = 142857, 3x = 428571, 4x = 571428, 5x = 714285, and 6x = 857142.

All of 2x, ..., 6x are indeed permutations of each other, so x = 142857 is the only 6 digit x
with this property.  x must have at least 6 digits, so this is minimal.

UPDATE: there is a way to simplify this a bit: we can run the analysis forwards based on the first
digits of x.  This is not obvious at first since x itself is not required to be a permutation
of 2x, so it seems like x can either be between 100000... and 166666... inclusive, or be between 500000... and
999999... inclusive, where in the first case 2x, ..., 6x have the same number of digits as x
and in the second they all have one more digit.  However, if x starts with 5-9, 2x must start with 1,
which introduces an extra required digit if x does not end in 5 or 7.

Actually I don't see why x can't start with 5-9 if it ends with 5 or 7, so I will write about how the
analysis of x from 100000 to 166666 works but probably not use it.

If x is: these digits are forced in as the leading digits of 2x, ..., 6x (and this one via mod 9) (possible last digits)
100000-116666: 23456 (7) (1)
116667-119999: 23457 (6) (1)
120000-124999: 23467 (5) (1)
125000-133333: 23567 (4) (1)
133334-139999: 24567 (2) (impossible)
140000-149999: 24578 (1) (7)
150000-159999: 34679 (7) (impossible)
160000-166666: 34689 (6) (impossible)

So if we could prove x doesn't start with 5-9, then we could use this analysis to show that either x is from 100000-133333 and ends with 1
OR x is from 140000 to 149999 and ends with 7, and we would then only have to prove 1 is impossible and
proceed directly with the analysis of the last case.

We can try to do this anyway by replicating the x from 100000-166666 analysis: notice that the first digit of
kx ranges from k to floor(166666*k/100000) for that case, so we see floor((k + 1)*100000/k) through floor(floor(166666*k/100000)*100000/k)
for all k from 2-6.

If x starts with 5-9, then we consider the possible values of the first digit of 2x, ..., 6x:
2x: 100000-199998, so x from 50000-99999 yield a 1
3x: 150000-299997, so x from 50000-66666 yield a 1 and 66667-99999 yield a 2
4x: 200000-399996, so x from 50000-74999 yield a 2 and 75000-99999 yield a 3
5x: 250000-499995, so x from 50000-59999 yield a 2, 60000-79999 yield a 3, and 80000-99999 yield a 4
6x: 300000-599994, so x from 50000-66666 yield a 3, 66667-83333 yield a 4, and 83334-99999 yield a 5
50000-59999: 123 (since fewer than 5 digits are forced, we don't also force a fixup digit.)
(However, of the fully forcing last digits, only 7 allows 1, and it does not allow 3.)
(So this is only possible if x ends in 5, since 5 is the only non fully forcing digit)
60000-66666: 123 (again this is only possible if x ends in 5)
66667-74999: 1234 (if x ends in 5, 0 and 5 are forced, so in this case 012345 are forced, but this isn't permissible mod 9 so this case is impossible)
75000-79999: 1234 (this case is impossible)
80000-83333: 1234 (impossible)
83334-99999: 12345 (impossible)

So we could still in theory have x from 50000-66666 as long as the last digit is 5.
In this case, 2x, ..., 6x would all have to include 12305, which sums to 2 mod 9, so would have to
be permutations of 123057.  So one last time, let's break down 2x = pi(12357)0.  Since x ends in 5,
the 10s digit of 2x must be odd:
2x = pi(1235)70: 4x ends in 40 (impossible)
2x = pi(1237)50: 4x ends in 00 (impossible)
2x = pi(1257)30: 4x ends in 60 (impossible)
2x = pi(2357)10: this is actually impossible because for x in 50000-66666, 2x must start with 1, which cannot happen in this case

This fully rules out x not starting with 1, so in turn we prove x is from 100000-166666 and ends with 1 or 7,
for any 2x that's 6 digits.  If the minimal x is larger, it may not satisfy these constraints.
*/

CREATE TABLE min_digitcounts_by_end AS
WITH prod_ends(d, k, r) AS (
	SELECT
		d.value,
		k.value,
		d.value*k.value%10
	FROM GENERATE_SERIES(1, 9) d
	JOIN GENERATE_SERIES(2, 6) k
), min_strs(d, s) AS (
	SELECT
		d,
		REPLACE(GROUP_CONCAT(DISTINCT r), ',', '') || (SUM(DISTINCT 9-r)%9)
	FROM prod_ends
	GROUP BY d
), min_digitcounts(d, e, c) AS (
	SELECT
		d,
		value,
		LENGTH(s) - LENGTH(REPLACE(s, value, ''))
	FROM min_strs
	JOIN GENERATE_SERIES(0, 9)
)
SELECT
	d,
	REPLACE(GROUP_CONCAT(c ORDER BY e), ',', '') AS dcs
FROM min_digitcounts
GROUP BY d;

CREATE TABLE min_digitcounts_by_start AS
WITH cutoffs(cutoff) AS (
	SELECT DISTINCT CAST((100000*m.value + k.value - 1)/k.value AS INT) AS cutoff
	FROM GENERATE_SERIES(2, 6) k
	JOIN GENERATE_SERIES(3, 9) m
	WHERE k.value <= m.value AND CAST(166666*k.value/100000 AS INT) >= m.value
	ORDER BY cutoff
), cutoff_prods(cutoff, k, r) AS (
	SELECT
		cutoff,
		k.value,
		CAST(cutoff*k.value/100000 AS INT)
	FROM cutoffs
	JOIN GENERATE_SERIES(2, 6) k
), min_strs(cutoff, s) AS (
	SELECT
		cutoff,
		REPLACE(GROUP_CONCAT(DISTINCT r), ',', '') || (SUM(DISTINCT 9-r)%9)
	FROM cutoff_prods
	GROUP BY cutoff
), min_digitcounts(cutoff, e, c) AS (
	SELECT
		cutoff,
		value,
		LENGTH(s) - LENGTH(REPLACE(s, value, ''))
	FROM min_strs
	JOIN GENERATE_SERIES(0, 9)
)
SELECT
	cutoff,
	REPLACE(GROUP_CONCAT(c ORDER BY e), ',', '') AS dcs
FROM min_digitcounts
GROUP BY cutoff;

WITH RECURSIVE tails(tail, p10, mask2, mask4, mask6) AS (
	SELECT DISTINCT
		2*d%10,
		10,
		SUBSTR(mdbs.dcs, 1, 2*d%10) || (CAST(SUBSTR(mdbs.dcs, 2*d%10 + 1, 1) AS INT) - 1) || SUBSTR(mdbs.dcs, 2*d%10 + 2),
		SUBSTR(mdbs.dcs, 1, 4*d%10) || (CAST(SUBSTR(mdbs.dcs, 4*d%10 + 1, 1) AS INT) - 1) || SUBSTR(mdbs.dcs, 4*d%10 + 2),
		SUBSTR(mdbs.dcs, 1, 6*d%10) || (CAST(SUBSTR(mdbs.dcs, 6*d%10 + 1, 1) AS INT) - 1) || SUBSTR(mdbs.dcs, 6*d%10 + 2)
	FROM min_digitcounts_by_start mdbs
	JOIN min_digitcounts_by_end mdbe
	ON mdbs.dcs == mdbe.dcs
	UNION ALL
	SELECT
		value*p10 + tail,
		10*p10,
		SUBSTR(mask2, 1,           value                      )
			|| (CAST(SUBSTR(mask2, value                       + 1, 1) AS INT) - 1)
			|| SUBSTR(mask2,       value                       + 2),
		SUBSTR(mask4, 1,           (value*p10 + tail)*2/p10%10)
			|| (CAST(SUBSTR(mask4, (value*p10 + tail)*2/p10%10 + 1, 1) AS INT) - 1)
			|| SUBSTR(mask4,       (value*p10 + tail)*2/p10%10 + 2),
		SUBSTR(mask6, 1,           (value*p10 + tail)*3/p10%10)
			|| (CAST(SUBSTR(mask6, (value*p10 + tail)*3/p10%10 + 1, 1) AS INT) - 1)
			|| SUBSTR(mask6,       (value*p10 + tail)*3/p10%10 + 2)
	FROM tails
	JOIN GENERATE_SERIES(0, 9)
	WHERE
		mask2 != '0000000000' AND
		SUBSTR(mask2, value + 1, 1) != '0' AND
		SUBSTR(mask4, (value*p10 + tail)*2/p10%10 + 1, 1) != '0' AND
		SUBSTR(mask6, (value*p10 + tail)*3/p10%10 + 1, 1) != '0'
)
SELECT tail/2 FROM tails WHERE mask2 == '0000000000' AND tail <= 333333;

