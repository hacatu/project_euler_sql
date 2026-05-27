/*
We could use the pentagonal recurrence maybe, but sql hates to see a multiple recurrence.

Consider Rademacher's formula, which specialized to n=100 gives

p(100) = 1/(pi*sqrt(2)) * sum for k from 1 to infinity of A_k(100) * (
	-(24*sqrt(14394)*k*sinh(sqrt(2399)*pi/(6*k)) - 9596*sqrt(6)*pi*cosh(sqrt(2399)*pi/(6*k)))/(5755201*sqrt(k))
)

where A_k(n) is a really complicated function too:
A_k(n) = sum for 0 <= m < k with m coprime to k of e^(pi*i*(s(m, k) - 2*n*m/k))
where in turn
s(b, c) = -1/c * sum for w over ALL cth roots of unity besides 1 of 1/((1-w^b)(1-w)) + 1/4 - 1/(4c)
or equivalently
s(b, c) = 1/(4c) * sum for n from 1 to c-1 of cot(pin/c)cot(pinb/c)
.....

The first 4 terms suffice, and we can find that A1(100) = 1, A2(100) = 1, A3(100) = -2*sin(pi/9), A4(100) = sqrt(1 - 1/sqrt(2))
and use sympy to find the expansion:

p(100) ~= -(-9596*sqrt(3)*pi*cosh(sqrt(2399)*pi/6) - 4798*sqrt(6)*pi*cosh(sqrt(2399)*pi/12) - 2399*sqrt(6)*pi*sqrt(sqrt(2) + 2)*cosh(sqrt(2399)*pi/24) - 144*sqrt(2399)*sin(pi/9)*sinh(sqrt(2399)*pi/18) + 24*sqrt(14394)*sqrt(sqrt(2) + 2)*sinh(sqrt(2399)*pi/24) + 19192*pi*sin(pi/9)*cosh(sqrt(2399)*pi/18) + 24*sqrt(14394)*sinh(sqrt(2399)*pi/12) + 24*sqrt(7197)*sinh(sqrt(2399)*pi/6))/(5755201*pi)

*/

SELECT ROUND(-(-9596*sqrt(3)*pi()*cosh(sqrt(2399)*pi()/6) - 4798*sqrt(6)*pi()*cosh(sqrt(2399)*pi()/12) - 2399*sqrt(6)*pi()*sqrt(sqrt(2) + 2)*cosh(sqrt(2399)*pi()/24) - 144*sqrt(2399)*sin(pi()/9)*sinh(sqrt(2399)*pi()/18) + 24*sqrt(14394)*sqrt(sqrt(2) + 2)*sinh(sqrt(2399)*pi()/24) + 19192*pi()*sin(pi()/9)*cosh(sqrt(2399)*pi()/18) + 24*sqrt(14394)*sinh(sqrt(2399)*pi()/12) + 24*sqrt(7197)*sinh(sqrt(2399)*pi()/6))/(5755201*pi())) - 1;

