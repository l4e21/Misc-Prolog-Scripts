
:- use_module(library(clpfd)).

opcode(0).
opcode(1).
opcode(2).
opcode(3).
opcode(4).
opcode(5).
opcode(6).
opcode(7).
opcode(8).
opcode(9).

cell([_|_], 0).
cell(N, 1) :- integer(N).

equal(X, Y, 0) :- X == Y.
equal(X, Y, 1) :- not(X == Y).

binary_address(Tree, N, N, Tree).

binary_address([X1|_], Acc, N, R) :-
    N #> 1,
    Acc #< N,
    N1 #= Acc*2,
    binary_address(X1, N1, N, R).

binary_address([_|X2], Acc, N, R) :-
    N #> 1,
    Acc #< N,
    N1 #= Acc*2 + 1,
    binary_address(X2, N1, N, R).

binary_address(Tree, N, R) :-
    integer(N),
    N #> 0,
    binary_address(Tree, 1, N, R).


% ?- binary_address([1|2], 1, R).

% ?- binary_address([1|2], 3, R).

% ?- binary_address([1, 2], 3, R).

prog_length(X, 1) :- not(compound(X)).
prog_length([_|Xs], N) :- N1 #= N - 1, prog_length(Xs, N1).

%% *[a 0 b] -> /[b a] (Addressing Rule)
nock(Subject, [0|N], Value) :-
    binary_address(Subject, N, Value).

% ?- nock([1|2], [0|3], R).
% ?- nock([1, 2, 3], [0|7], R).

%% *[a 1 b] -> b (Constant Reduction Rule)
nock(_, [1|B], B).

% ?- nock(5, [1, 4, 0 | 1], R).

%% *[a 2 b c] -> *[*[a b] *[a c]] (Application Rule)
nock(Subject, [2|[B|C]], Result) :-
    nock(Subject, B, NewSubject),
    nock(Subject, C, NewFn),
    nock(NewSubject, NewFn, Result).

% ?- nock(5, [2, [0|1]|[1, 4, 4, 0|1]], R).

%% *[a 3 b] -> ?*[a b] (Cell Test Rule)

nock(Subject, [3|B], Result) :-
    nock(Subject, B, N),
    cell(N, Result).

% ?- nock(5, [3, 0|1], R).

% ?- nock([5], [3, 0|1], R).

%% *[a 4 b] -> +*[a b] (Increment Rule)

nock(Subject, [4|B], R) :-
    nock(Subject, B, R1),
    R #= R1 + 1.

% ?- nock(5, [4, 4, 0|1], R).

%% *[a 5 b c] -> =[*[a b] *[a c]] (Equality Rule)

nock(Subject, [5|[B|C]], Result) :-
    nock(Subject, B, R1),
    nock(Subject, C, R2),
    equal(R1, R2, Result).

% ?- nock([5|5], [5, [0|1]|[0|1]], Result).

% ?- nock([5|5], [5, [0|1]|[0|2]], Result).

%% *[a 6 b c d] -> *[a *[[c d] 0 *[[2 3] 0 *[a 4 4 b]]]] (If-Then-Else Rule)

nock(Subject, [6|[B|[C|D]]], Result) :-
    nock(Subject, [4, 4|B], R1),
    nock([2|3], [0|R1], R2),
    nock([C|D], [0|R2], R3),
    nock(Subject, R3, Result).

% ?- nock(5, [6, [3, 0|1], [0|2]|[0|1]], R).

% ?- nock([5|5], [6, [3, 0|1], [0|2]|[0|1]], R).

%% *[a 7 b c] -> *[*[a b] c] (Simplified Application Rule)
nock(Subject, [7|[B|C]], Result) :-
    nock(Subject, B, R1),
    nock(R1, C, Result).

% ?- nock([5|5], [7, [0|2]|[4, 0|1]], Result).

%% *[a 8 b c] -> *[[*[a b] a] c] (Pin Subject Rule)
nock(Subject, [8|[B|C]], Result) :-
    nock(Subject, B, R1),
    nock([R1|Subject], C, Result).

% ?- nock(5, [8, [0|1]|[0|1]], Result).

%% *[a 9 b c] -> *[*[a c] 2 [0 1] 0 b] (Monotonic Subject Rule)
nock(Subject, [9|[B|C]], Result) :-
    nock(Subject, C, R1),
    nock(R1, [2, [0|1], 0|B], Result).

% ?- nock(45, [9, 2, [1, 4, 0|3], 0|1], R).
%@ R = 46 ;
%@ false.

% ?- [9, 2, [1, 4, 0|3], 0|1] = [9|[B|C]].

%%
%%
%% PLACEHOLDER RULE 10
%%
%%

%%
%%
%% PLACEHOLDER RULE 11
%%
%%

%% List Rule for generating multiple results
nock(Subject, [[A|B]|Xs], Result) :-
    nock(Subject, [A|B], R1),
    nock(Subject, Xs, R2),
    Result = [R1|R2].

% ?- nock(5, [[0|1]|[0|1]], Result).



% ?- listing(nock).

% ?- clause(nock(X, Y, R), Body).

lookup(Term, Doc, Body) :-
    clause(Term, Body),
    doc(Term, Doc).

%% Whyyy listing whyyyyyy
doc(nock(_, [0|_], _), "Addressing Rule").
doc(nock(_, [1|_], _), "Constant Rule").
doc(nock(_, [2|_], _), "Application Rule").
doc(nock(_, [3|_], _), "Cell Rule").
doc(nock(_, [4|_], _), "Increment Rule").
doc(nock(_, [5|_], _), "Equality Rule").
doc(nock(_, [6|_], _), "If-Then-Else Rule").
doc(nock(_, [7|_], _), "Simplified Application Rule").
doc(nock(_, [8|_], _), "Pin Subject Rule").
doc(nock(_, [9|_], _), "Monotonic Subject Rule").
doc(nock(_, [[_|_]|_], _), "Nested Programs").

% ?- lookup(nock(Subject, Program, Result), Doc, Body).

% ?- nock(5, [X, X, 0|1], 7).

% ?- prog_length([2, [0|1], 1, 1|7], 1).

% ?- prog_length(Program, N), N #< 4, nock(5, Program, 7), labeling([], [N]).

% ?- trace(nock/3).
