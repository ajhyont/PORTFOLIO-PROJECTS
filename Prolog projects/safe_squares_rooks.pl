/*
PROBLEM: 
safe_squares_rooks(+Rooks, +N, -S)
Unify S with the integer count of squares in a generalized N-by-N chessboard that are safe from the
list of Rooks positioned on that board. A square is safe if no rooks on the board lie in the same row
or column as that square. Positions of the individual rooks are expressed as terms of the form
(Row, Col) where both coordinates Row and Col are integers between 1 and N, inclusive.

---TRY BELOW INPUTS---
?- safe_squares_rooks([(2, 2), (3, 1), (5, 5), (2, 5)], 5, S).
S = 4.
?- safe_squares_rooks([(1, 1), (2, 2), (3, 3), (4, 4), (5, 5)], 5, S).
S = 0.
?- safe_squares_rooks([], 100, S).
S = 10000.
*/

/*SOLUTION*/
use_module(library(clpfd)).

safe_squares_rooks([],N,S):- S is N*N.
safe_squares_rooks(L,N,S_final):- ssr(L, N, S, Rows, Cols), 
    sort(Rows,R1), sort(Cols,C1), length(R1,Rcount), length(C1,Ccount),
    /*intersection(R1,C1,Intersect), length(Intersect, I), */
    S_final is S-((Rcount*N+Ccount*N)-Rcount*Ccount).

ssr([], N, S, [], []):- S is N*N. 
ssr( [ (A,B)|L], N, S, [A|Rows], [B|Cols]):-
    ssr(L, N, S, Rows, Cols).

