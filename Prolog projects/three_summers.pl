/*
PROBLEM: 
three_summers(+Items, +Goal, -A, -B, -C)
Given a list of positive integer Items whose elements are guaranteed to be in sorted ascending
order, and a positive integer Goal, unify A, B, and C with three elements taken from Items that
together add up to Goal. The elements A, B, and C must occur inside the Items list in that order.

---TRY BELOW INPUTS---
?- three_summers([3, 7, 9, 10, 12, 14], 30, A, B, C).
A = 7, B = 9, C = 14.
?- three_summers([1, 2, 3, 4, 5, 6], 12, A, B, C).
A = 1, B = 5, C = 6;
A = 2, B = 4, C = 6;
A = 3, B = 4, C = 5.
*/


/*SOLUTION*/
use_module(library(clpfd)).

three_summers( [H|L1], Sum, A,B,C):- buf(L1,L2), member(A, [H|L1]), member(B,L1), member(C,L2), A<B, B<C, Sum=:=A+B+C. 

buf( [H|L_sub],L_sub).

