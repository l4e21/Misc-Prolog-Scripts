
%% Compile with gplc 

add_two(A, B, X) :- X is A + B.

add_three(A, B, C, X) :- X is A + B + C.


edge(a, b).
edge(b, c).
edge(c, a).

path(A, B, [A-B]) :- edge(A, B).
path(A, C, [A-B|Path]) :- edge(A, B), path(B, C, Path).

more_than_3(A) :- A > 3.
between(A) :- more_than_3(A), A < 6.

arg(X) :- gensym(obj_, X).
