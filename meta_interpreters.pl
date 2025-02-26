elem(x, 4).
elem(y, 5).
elem(z, 6).
elem(z, 5).

elem(union(S1, _), E) :- elem(S1, E).
elem(union(_, S2), E) :- elem(S2, E).

elem(product(S1, S2), E) :-
    elem(S1, E1), elem(S2, E2), E = E1-E2.

elem(intersection(S1, S2), E) :- elem(S1, E), elem(S2, E).

% ?- elem(X, 5).

mi_bfs(Goal, [true-Path|_]) :- reverse(Path, [Goal|_]).

mi_bfs(Goal, [Subgoal-Path|Subgoals]) :-
    Subgoal \== true,
    findall(Body-[Subgoal|Path], (clause(Subgoal, Body)), ExtendedSubgoals),
    append(Subgoals, ExtendedSubgoals, NewSubgoals),
    mi_bfs(Goal, NewSubgoals).

mi_bfs(Goal, [_|Bs]) :- mi_bfs(Goal, Bs).

mi_bfs(Goal) :-
    mi_bfs(Goal, [Goal-[]]).



% ?- clause(elem(X, 5), B).

% ?- mi_bfs(elem(X, 5)).



mi_dfs(Goal, [true-Path|_]) :- reverse(Path, [Goal|_]).

mi_dfs(Goal, [Subgoal-Path|Subgoals]) :-
    Subgoal \== true,
    findall(Body-[Subgoal|Path], (clause(Subgoal, Body)), ExtendedSubgoals),
    append(ExtendedSubgoals, Subgoals, NewSubgoals),
    mi_dfs(Goal, NewSubgoals).

mi_dfs(Goal, [_|Bs]) :- mi_dfs(Goal, Bs).

mi_dfs(Goal) :-
    mi_dfs(Goal, [Goal-[]]).



% ?- clause(elem(X, 5), B).

% ?- mi_dfs(elem(X, 5)).





% ?- mi_dfs(elem(X, 3)).

% ?- mi_bfs(elem(X, Y)).
