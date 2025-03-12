elem(x, 4).
elem(y, 5).
elem(z, 6).
elem(z, 5).

elem(union(S1, _), E) :- elem(S1, E).
elem(union(_, S2), E) :- elem(S2, E).

elem(product(S1, S2), E1-E2) :-
    elem(S1, E1), elem(S2, E2).

elem(intersection(S1, S2), E) :- elem(S1, E), elem(S2, E).

% ?- elem(X, 5).

expand_goal(Path, true, [true-Path]).

expand_goal(Path, Goal, Subgoals) :-
    Goal \== true,
    findall(Body-[Goal|Path], clause(Goal, Body), Subgoals).    

% ?- expand_goal([], true, S).

% ?- expand_goal([], elem(X, 5), S).

% ?- expand_goal([], (elem(X, 5), elem(Y, 5)), S).

mi_bfs(Goal, [true-Path|_]) :- reverse(Path, [Goal|_]).    

mi_bfs(Goal, [Subgoal-Path|Subgoals]) :-
    Subgoal \== true,
    expand_goal(Path, Subgoal, ExpandedSubgoals),
    append(Subgoals, ExpandedSubgoals, NewSubgoals),
    mi_bfs(Goal, NewSubgoals).

mi_bfs(Goal, [_|Bs]) :- mi_bfs(Goal, Bs).

mi_bfs(Goal) :-
    mi_bfs(Goal, [Goal-[]]).


% ?- clause(elem(intersection(X, Y), 5), B).

% ?- clause(elem(X, 5), B).

% ?- trace(mi_bfs/2).

% ?- trace(expand_goal/3).

% ?- trace(expand_tuple/3).

% ?- mi_bfs(elem(X, 5)).

% ?- mi_bfs(elem(intersection(y, y), 5)).

% ?- mi_bfs((elem(X, 5), elem(Y, 5))).

% ?- mi_bfs(elem(intersection(X, Y), 5)).

%% Easy Case
%% (elem(x,5); elem(y, 5)
%% ->
%% ([true, true, elem(X, 5)..], [true, true, elem(X, 5)...]
%% -> []
%% -> true

%% How do we deal with multiclause bodies?
%% (elem(x,5); elem(y, 5)
%% ->
%% ([elem(X, 5)..], [elem(X, 5)...]
%% -> In this case we do append all combinations to the queue?
%% -> Or, do we expand only the first element

%% Opt 1 Add all combinations
% (elem(x, 5); elem(5, 5))
%% ->
%% ([elem(X, 5), (elem(...1), elem(...2))], [elem(.., 5), elem(.., 5)]))
%% Append all possibilities to subqueue E.G., (elem(X, 5), elem(.., 5)), (elem(...1), elem(...2), elem(..., 5))
%% This could get extremely computationally expensive and wasteful

%% Opt 2 deal with one part at a time per expansion
%% (elem(x, 5); elem(y, 5))
%% ->
%% ([elem(X, 5), (elem(...1), elem(...2))], elem(y, 5))
%% ->
%% append (elem(X,5), elem(y, 5)) and (elem(...1), elem(..2), elem(y, 5)) etc?
%% There will be repeated work... for elem(y, 5)
%% Maybe we can do it in parallel/use combinations less wastefully?

%% Opt 3 Paralellising sub-queues
%% (elem(x, 5); elem(y, 5))
%% ->
%% ([elem(X, 5), (elem(...1), elem(...2))], [elem(.., 5), elem(.., 5)])
%% ->
%% ([elem(X, 5), (elem(...1), elem(...2))], [elem(.., 5), elem(.., 5)])
%% This would screw up BFS if we just try to append all of it. We could maybe treat these as two separate sub-queues. Kind of gross.
%% ->
%% (elem(X, 5) is expanded and sent to back of first sub-queue).. elem(..,5) is expanded and sent to the back of second sub-queue
%% ([(elem(..1), elem(...2))...true], [elem(..., 5), true])
%% Logic here would be quite tricky but I think it's worth exploring for optimisation. Also we need to know how this affects backtracking more.

mi_dfs(Goal, [true-Path|_]) :- reverse(Path, [Goal|_]).

mi_dfs(Goal, [Subgoal-Path|Subgoals]) :-
    Subgoal \== true,
    findall(Body-[Subgoal|Path], clause(Subgoal, Body), ExtendedSubgoals),
    append(ExtendedSubgoals, Subgoals, NewSubgoals),
    mi_dfs(Goal, NewSubgoals).

mi_dfs(Goal, [_|Bs]) :- mi_dfs(Goal, Bs).

mi_dfs(Goal) :-
    mi_dfs(Goal, [Goal-[]]).



% ?- clause(elem(X, 5), B).

% ?- mi_dfs(elem(X, 5), Path).




% ?- mi_dfs(elem(X, 3)).

% ?- mi_bfs(elem(X, Y)).

:- use_module(library(clpfd)).

mi(true, _).
mi(Goal) :-
    Goal \== true,
    clause(Goal, Body),
    mi(Body).

% ?- mi(elem(X, 5)).



mi_id(true, _).
mi_id(Goal, Depth) :-
    Depth #>= 0,
    Goal \== true,
    clause(Goal, Body),
    Depth1 #= Depth - 1,
    mi_id(Body, Depth1).

    
% ?- trace(mi_id/2).
% ?- mi_id(elem(X, 5), 2).


mi_iddfs(true-_, _, _, _).
mi_iddfs(Goal-Depth, Depth, MaxDepth, Visited) :-
    Depth #< MaxDepth,
    Goal \== true,
    clause(Goal, Body),
    %% write(Goal),
    \+ member(Goal-Depth, Visited),
    clause(Goal, Body),
    Depth1 #= Depth + 1,
    mi_iddfs(Body-Depth1, Depth1, MaxDepth, Visited).



mi_iddfs(Gs, Visited, N) :-
    findall(elem(X1, 5)-D, mi_iddfs(elem(X1, 5)-D, 0, N, Visited), NewFound),
    mi_iddfs_aux(Gs, NewFound, Visited, N).


mi_iddfs_aux(NewFound, NewFound, _, _).

mi_iddfs_aux(Gs, NewFound, Visited, N) :-
    N1 #= N + 1,
    append(NewFound, Visited, NextVisited),
    mi_iddfs(Gs, NextVisited, N1).


% ?- clause(elem(X, 5), B).

% ?- mi_iddfs(elem(X, 5)-D, 0, 2, []).

% ?- findall(elem(X1, 5)-D, mi_iddfs(elem(X1, 5)-D, 0, 1, []), Gs).
%@ Gs = [elem(y, 5)-0, elem(z, 5)-0].

% ?- findall(elem(X1, 5)-D, mi_iddfs(elem(X1, 5)-D, 0, 2, [elem(y, 5)-0, elem(z, 5)-0]), Gs).
%@ Gs = [elem(union(y, _), 5)-0, elem(union(z, _), 5)-0, elem(union(y, y), 5)-0, elem(union(z, z), 5)-0, elem(union(y, y), 5)-0, elem(union(z, z), 5)-0, elem(union(..., ...), 5)-0, elem(..., ...)-0].

% ?- findall(elem(X1, 5)-D, mi_iddfs(elem(X1, 5)-D, 0, 3, [elem(y, 5)-0, elem(z, 5)-0, elem(y, 5)-1]), Gs).



% ?- mi_iddfs(Gs, [], 0).
