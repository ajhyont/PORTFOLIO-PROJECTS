/*
PROBLEM: 
riffle(-Left, -Right, -Result, -Mode)
Unify Result with the list created by taking elements from Left and Right lists in alternating
fashion. Both Left and Right must have the same length, and Mode must be either left or right
to indicate which list the first element in Result comes from.

---TRY BELOW INPUTS---
?- riffle([bob, 42, foo(bar)], [99, hello, world], L, left).
L = [bob, 99, 42, hello, foo(bar), world].
?- riffle(L1, L2, [odd, number, of, elements, cannot, succeed, here], M).
false.
?- riffle([42, bob, 99], [55, jack, tom], [55|_], Mode).
Mode = right.
?- riffle(L1, L2, [A, B, C, D, E, F], M).
L1 = [A, C, E],
L2 = [B, D, F],
M = left ;
L1 = [B, D, F],
L2 = [A, C, E],
M = right ;
*/


/*SOLUTION*/
use_module(library(clpfd)).

riffle([],[],[],M).
add([],[],[],M, I).

riffle(L,R,Res,M):- add(L,R,Res,M,1), length(Res, X), length(L, Y), length(R, Z), X=:=2*Y, X=:=2*Z.
add( [H|L], R, [H|Res], left, Index):- 1 is Index mod 2, I is Index+1, add(L,R,Res,left,I).
add( L, [H|R], [H|Res], left, Index):- 0 is Index mod 2, I is Index+1, add(L,R,Res,left,I).
add( [H|L], R, [H|Res], right, Index):- 0 is Index mod 2, I is Index+1, add(L,R,Res,right,I).
add( L, [H|R], [H|Res], right, Index):- 1 is Index mod 2, I is Index+1, add(L,R,Res,right,I).


