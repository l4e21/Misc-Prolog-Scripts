:- use_module(library(clpfd)).

n_queens(N, Rows) :-
    length(Rows, N),
    Rows ins 1..N,
    safe_queens(Rows).

safe_queens([]).
safe_queens([Q|Qs]) :- safe_queens(Qs, Q, 1), safe_queens(Qs).

safe_queens([], _, _).

safe_queens([Q0|Qs], Q, D) :-
    Q0 #\= Q,
    abs(Q0 - Q) #\= D,
    D1 #= D + 1 ,
    safe_queens(Qs, Q, D1).


% ?- n_queens(8, Qs), label(Qs).

% ?- n_queens(70, Xs), labelling([ff], Xs).

%% Ascii capitals from 65-90 IIRC
domain([65]).
domain([65, 68, 67]).
domain([65, 65, 69]).
domain([75, 75, 78, 69, 69]).

solve_matches([], _).
solve_matches([Idx11-Idx12=Idx21-Idx22|Matches], Words) :-
    nth0(Idx11, Words, Word1),
    nth0(Idx12, Word1, Letter1),
    nth0(Idx21, Words, Word2),
    nth0(Idx22, Word2, Letter2),
    Letter1 #= Letter2,
    solve_matches(Matches, Words).

crossword(N, Matches, Words) :-
    length(Words, N),
    maplist(domain, Words),
    solve_matches(Matches, Words).

% ?- crossword(3, [0-0=1-1, 1-2=2-4], Words).

k_colourable(Nodes, Edges, N) :-
    Nodes ins 1..N,
    maplist([A-B]>>(A #\= B), Edges).

% ?- k_colourable([A, B, C, D], [A-B, B-C, A-D, C-D], 2), label([A, B, C, D]).

% ?- k_colourable([A, B, C, D], [A-B, B-C, C-D, D-A, C-A], 3), label([A, B, C, D]).


%% combinations([], []).
%% combinations([Q|Qs], Combos) :-
%%     combinations(Q, Qs, Combos1),
%%     combinations(Qs, Combos2),
%%     append(Combos1, Combos2, Combos).

%% combinations(_, [], []).
%% combinations(Q0, [Q|Qs], [[Q0, Q]|Combos]) :-
%%     combinations(Q0, Qs, Combos).

combinations_aux(_, [], []).
combinations_aux(A, [B|Bs], [[A, B]|Combos]) :-
    combinations_aux(A, Bs, Combos).

combinations([], _, []).
combinations([A|As], Bs, Combos) :-
    combinations_aux(A, Bs, Combos1),
    combinations(As, Bs, Combos2),
    append(Combos1, Combos2, Combos).

