/*
PROBLEM: 
running_median(+Items, -Medians)
Unify Medians with a list of integers acquired by replacing each element with the median of that
element and the two immediately preceding elements in Items. The first two elements of Medians
should equal the first two elements of Items.

---TRY BELOW INPUTS---
?- running_median([1, 2, 3, 4, 5], M).
M = [1, 2, 2, 3, 4].
?- running_median([99, 42, 17, 55, -4, 18, 77], M).
M = [99, 42, 42, 42, 17, 18, 18].
?- running_median([42, 42, 99, 42, 42], M).
M = [42, 42, 42, 42, 42].
*/


/*SOLUTION*/
running_median(L,N):- test0(L,N1), test(L,N2, 3), append([ N1,N2 ], N), 
    length(L,Size1), length(N,Size2), Size2=<Size1.


test(L, [X|N], Index):- S2 is Index-2, nth1(S2,L,E1), 
    S1 is Index-1, nth1(S1,L,E2), 
    S is Index, nth1(S,L,E3), 
    msort([E1,E2,E3],Lsorted), nth1(2,Lsorted,X), 
    test(L,N, Index+1).
    
test(L,[], Index):- length(L,X), Index >= X, !.


test0(L,N):- nth1(1,L,E1), nth1(2,L,E2), append([ [E1],[E2] ], N).
