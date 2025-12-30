
%% Sets with bitmasks

bidx(a, 0).
bidx(b, 1).
bidx(c, 2).

set_encoding(empty, 0).

set_encoding(singleton(E), R) :-
    bidx(E, I),
    R is 1 << I.

set_encoding(union(S1, S2), R) :-
    set_encoding(S1, R1),
    set_encoding(S2, R2),
    R is R1 \/ R2.

set_encoding(intersection(S1, S2), R) :-
    set_encoding(S1, R1),
    set_encoding(S2, R2),
    R is R1 /\ R2.
    
orit(C) :- C is 101 \/ 010.
andit(C) :- C is 101 /\ 010.
shiftit(C) :- C is 1 << 3.

% ?- set_encoding(union(singleton(a), singleton(b)), R).

% ?- set_encoding(union(singleton(a), B), R).

% ?- clause(set_encoding(S, 3), R).

% ?- clause(set_encoding(S1, R1), B).
