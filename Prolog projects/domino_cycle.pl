/*
PROBLEM: 
domino_cycle(+C)
An individual domino tile is represented as term (A, B) where A and B are its counts of pips that
the tile starts and ends with when it has been placed on the board. These pips must be integers
between 1 and 6, inclusive which is probably best enforced with the predicate between/3. A
domino cycle is a list of domino tiles whose every tile ends with the pips that its successor tile
starts with. To complete the cycle, the last tile must end with the pips that the first tile starts with.

---TRY BELOW INPUTS---
?- domino_cycle([(2, X)]).
X = 2.
?- domino_cycle([(4, 1), (1, 7), (7, 2)]).
false.
?- domino_cycle([(4, 5), (5, 2), (2, 3), (3, X)]).
X = 4.
?- domino_cycle([(A, 1), (1, 2), (2, A)]).
A = 1;
A = 2;
A = 3;
A = 4;
A = 5;
A = 6.
?- findall(C, (length(C, 5), domino_cycle(C)), _L), length(_L, L).
L = 7776.
*/


/*SOLUTION*/
use_module(library(clpfd)).

domino_cycle([ (A,A) ]) :- between(1,6,A).
domino_cycle([(A,B)|T1]):- check([(A,B)|T1]), buffering(T1,(B,C),T2), matching(A, T1).

matching(A, [ (B,C)|T2] ):- length([ (B,C)|T2],X),X>1, buffering(T2,(C,D),T3), matching(A,T2).
matching(A, [(_,A)]).

buffering( [(X,Y)|L], (X,Y), L  ). 

check( [(X,Y)|L] ) :- between(1,6,X), between(1,6,Y), check( L ).
check([]).

