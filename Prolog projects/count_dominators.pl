/*
PROBLEM: 
count_dominators(+Items, -Result)
Define a dominator element inside a list to be an element that is strictly greater than all of the
elements that follow it in the list. (The last element of any list is therefore automatically a
dominator, by definition.) Unify Result with the count of how many dominator elements exist
inside the list of integer Items.

---TRY BELOW INPUTS---
?- count_dominators([42, 99, 17, 3, 9], D).
D = 3.
?- count_dominators([4, 3, 2, 1], D).
D = 4.
?- count_dominators([1, 2, 3, 4], D).
D = 1.
?- count_dominators([], D).
D = 0.
*/

/*SOLUTION*/
use_module(library(clpfd)).

count_dominators([],0).
count_dominators([A],1).
count_dominators( [H|L], D):- isDom(H,L), 
                count_dominators(L, Y), D is Y+1, !.
count_dominators( [H|L], D):- count_dominators(L, D).


isDom(H,[]).
isDom(H, [E|L]):- H>E, isDom(H, L).
