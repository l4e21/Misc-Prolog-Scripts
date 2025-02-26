elem(x, 4).
elem(y, 5).
elem(z, 6).
elem(z, 5).

elem(union(S1, _), E) :- elem(S1, E).
elem(union(_, S2), E) :- elem(S2, E).

elem(product(S1, S2), E) :-
    elem(S1, E1), elem(S2, E2), E = E1-E2.

elem(intersection(S1, S2), E) :- elem(S1, E), elem(S2, E).


mi_bfs(Goal, [true-Path|_]) :- reverse(Path, [Goal|_]).

mi_bfs(Goal, [B-P|Bs]) :-
    B \== true,
    findall(B1-[B|P], (clause(B, B1), \+ member(B, B1)), Bs1),
    append(Bs, Bs1, NewBs),
    mi_bfs(Goal, NewBs).

mi_bfs(Goal, [_|Bs]) :- mi_bfs(Goal, Bs).

mi_bfs(Goal) :-
    mi_bfs(Goal, [Goal-[]]).

% ?- clause(elem(X, 5), B).

% ?- mi_bfs(elem(X, 5)).
%@ X = y ;
%@ X = z ;
%@ X = union(y, _) ;
%@ X = union(z, _) ;
%@ X = union(_, y) ;
%@ X = union(_, z) ;
%@ X = union(union(y, _), _) ;
%@ X = union(union(z, _), _) ;
%@ X = union(union(_, y), _) ;
%@ X = union(union(_, z), _) ;
%@ X = union(_, union(y, _)) ;
%@ X = union(_, union(z, _)) ;
%@ X = union(_, union(_, y)) ;
%@ X = union(_, union(_, z)) ;
%@ X = union(union(union(y, _), _), _) 

mi_dfs(Goal, [true-Path|_]) :- reverse(Path, [Goal|_]).

mi_dfs(Goal, [B-P|Bs]) :-
    B \== true,
    findall(B1-[B|P], (clause(B, B1), \+ member(B, B1)), Bs1),
    append(Bs1, Bs, NewBs),
    mi_dfs(Goal, NewBs).

mi_dfs(Goal, [_|Bs]) :- mi_dfs(Goal, Bs).

mi_dfs(Goal) :-
    mi_dfs(Goal, [Goal-[]]).


% ?- clause(elem(X, 5), B).

% ?- mi_dfs(elem(X, 5)).
%@ X = y ;
%@ X = z ;
%@ X = union(y, _) ;
%@ X = union(z, _) ;
%@ X = union(union(y, _), _) ;
%@ X = union(union(z, _), _) ;
%@ X = union(union(union(y, _), _), _) ;
%@ X = union(union(union(z, _), _), _) ;
%@ X = union(union(union(union(y, _), _), _), _) ;
%@ X = union(union(union(union(z, _), _), _), _) ;
%@ X = union(union(union(union(union(y, _), _), _), _), _) ;
%@ X = union(union(union(union(union(z, _), _), _), _), _) 
