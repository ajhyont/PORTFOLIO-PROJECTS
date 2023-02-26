/*
PROBLEM:
extract_increasing(+Digits, -Nums)
Unify Nums with the list of strictly increasing numbers extracted from the string of Digits by
reading its digits from left to right. The leftover digits that do not form a sufficiently large integer
larger than the previous number are discarded.

---TRY BELOW INPUTS---
?- extract_increasing("1234567890987654321", Nums).
Nums = [1, 2, 3, 4, 5, 6, 7, 8, 9, 98, 765, 4321].
?- extract_increasing("122333444455555666666", Nums).
Nums = [1, 2, 23, 33, 44, 445, 555, 566, 666].
?- extract_increasing("3141592653589793238462643383279502884", Nums).
Nums = [3, 14, 15, 92, 653, 5897, 9323, 84626, 433832, 795028]
*/


/*SOLUTION*/
extract_increasing(S,Ln):- string_chars(S,Ls), toNumList(Ls,L_num),     addToList(L_num, Ln, 0, 0), !.

addToList( [], [], _, _).
addToList( [H|Ls], Ln, C, SubStr):- 
    C >= SubStr, 
    string_concat(SubStr,H,SubStr1), 
    atom_number(SubStr1, Subnum),
    addToList(Ls, Ln, C, Subnum).

addToList( Ls, [ Finished_subnum|Ln], C,Finished_subnum):- 
    C < Finished_subnum, C1 is Finished_subnum,
    addToList( Ls, Ln, C1, 0).

toNumList( [], []).
toNumList( [H|Ls], [Num|L_num]):- toNumList(Ls, L_num), atom_number(H,Num).
