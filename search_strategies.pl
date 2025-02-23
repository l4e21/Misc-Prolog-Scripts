:- use_module(library(clpfd)).

%% Cyclical DAG (a->b->c->a, a->b->d->a)
move(a, b).
move(b, c).
move(c, a).
move(b, d).
move(d, a).

path(Start, End, []) :- move(Start, End).

path(Start, End, Path) :-
    move(Start, A),
    path(A, End, Path1),
    Path = [A|Path1].


%% PROLOG uses DFS on choicepoints for backtracking, therefore it never finds the second cycle and keeps repeating the first.

% ?- path(a, b, Path).
%@ Path = [] ;
%@ Path = [b, c, a] ;
%@ Path = [b, c, a, b, c, a] ;
%@ Path = [b, c, a, b, c, a, b, c, a] ;
%@ Path = [b, c, a, b, c, a, b, c, a|...] .

path_with_depth(Start, End, [], _, _) :- move(Start, End).
path_with_depth(Start, End, Path, Depth, MaxDepth) :-
    Depth #< MaxDepth,
    Depth1 #= Depth + 1,
    move(Start, A),
    path_with_depth(A, End, Path1, Depth1, MaxDepth),
    Path = [A|Path1].

%% Iterative Deepening can help to solve this problem
% ?- path_with_depth(a, b, Path, 0, 3).
%@ Path = [] ;
%@ Path = [b, c, a] ;
%@ Path = [b, d, a] ;
%@ false.

path_bfs(_, End, Path, [move(_, End)-Path|_]).

path_bfs(Start, End, Path, [move(_, B)-PathAcc|Options]) :-
    findall(move(B, C)-NewPathAcc,
            (move(B, C), append(PathAcc, [B], NewPathAcc)),
            SubBranches),
    append(Options, SubBranches, NewOptions),
    path_bfs(Start, End, Path, NewOptions).

path_bfs(Start, End, Path) :-
    findall(move(Start, A)-[], move(Start, A), Options),
    path_bfs(Start, End, Path, Options).

%% Another solution is to change the search strategy entirely, but as you can see the structure of the program changes quite a lot

% ?- clause(move(b, X), _).
%@ X = c ;
%@ X = d.

% ?- path_bfs(a, c, Path).
%@ Path = [b] ;
%@ Path = [b, c, a, b] ;
%@ Path = [b, d, a, b] ;
%@ Path = [b, c, a, b, c, a, b] ;
%@ Path = [b, c, a, b, d, a, b] ;
%@ Path = [b, d, a, b, c, a, b] ;
%@ Path = [b, d, a, b, d, a, b] ;
%@ Path = [b, c, a, b, c, a, b, c, a|...] ;
%@ Path = [b, c, a, b, c, a, b, d, a|...] .
