/*
PROBLEM: 
only_odd_digits(+N)
Succeeds if the base ten representation of the positive integer N contains only odd digits. To
organize the checking activity inside this recursion, note how the integer arithmetic operators div
and mod in Prolog can be used to extract the last digit from an integer.

---TRY BELOW INPUTS---
?- only_odd_digits(0).
false.
?- only_odd_digits(135797531).
true.
?- only_odd_digits(7755334119955).
false.
?- findall(N, (between(1, 1000, N), only_odd_digits(N)), _L), length(_L,
L).
L = 155.
?- findall(N, (between(1, 100000, N), only_odd_digits(N)), _L), length(_L,
L).
L = 3905.
*/

/*SOLUTION*/
use_module(library(clpfd)).

only_odd_digits(N) :- number_chars(N,L), odd(L), !.
odd([]).
odd([H|L]):- atom_number(H,Num), mod(Num,2) =:= 1, odd(L).
