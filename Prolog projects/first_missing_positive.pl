/*
PROBLEM: 
first_missing_positive(+Items, -Result)
Unify Result with the smallest positive integer that is not a member of Items. The argument
Items is guaranteed to be a list, but it can contain any bound Prolog terms as its elements, not
merely integers. However, this predicate does not need to recursively look into the elements that
are lists, but treat such elements as non-integers.

---TRY BELOW INPUTS---
?- first_missing_positive([6, 8, 2, 999, 1, 4, 7], N).
N = 3.
?- first_missing_positive([42, 99, 123456, -3, 777], N).
N = 1.
?- first_missing_positive([bob, jack, foo(bar, baz, qux)], N).
N = 1.
?- first_missing_positive([2, 3, 4, [1, 1, 1, 1]], N).
N = 1.
*/


/*SOLUTION*/
use_module(library(clpfd)).

make_integer([], []).
make_integer([H|L],[Int|L_int]):- Int is ceil(H), make_integer(L, L_int ).
is_positive(I):- I>0.

first_missing_positive(L,N):-include(is_Num,L,Li), make_integer(Li,L_int), sort(L_int,Int_N_Sorted), include(is_positive, Int_N_Sorted, Int_Sorted_Pos), find(Int_Sorted_Pos,1,N), !.

find( [] ,Lp,N):- N is Lp.
find( [Last] ,Lp,N):- Lp>Last, N is Lp.
find( [H|L],Lp,N):- H-Lp=:=0, Ln is Lp+1, find( L,Ln,N).
find( [H|L],Lp,N):- H-Lp >=1, N is Lp.

is_Num(X):- integer(X) ; float(X).
