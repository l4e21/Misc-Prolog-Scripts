
%% Idea for graphical prolog

%% Graphical Program Example
%% Program w 2 slots
%% 1 var
%% 1st slot named +
%% 1st slot first arg 1
%% 1st slot second arg 2
%% 2nd slot named -
%% 2nd slot first arg 9
%% 2nd slot second arg 2
%% 3rd slot of first slot = 3rd slot of second slot (by arrow?)

%% gp_add(A, B, C).
%% gp_minus(A, B, C).

%% compiles to
%% net((gp_add(3, 4, X),
%%      gp_minus(9, 2, X))).

%% Or maybe to
%% net([[gp_add, 3, 4, _],
%%      [gp_minus, 9, 2, _]],
%%    [[1, 4]=[2, 4]]).

%% which then gets compiled to the first using a reduction on = which is a special syntax operator

:- use_module(library(clpfd)).

get_slot(Term, [], Term).
get_slot(Term, [N|Address], Slot) :-
    nth1(N, Term, Slot1),
    get_slot(Slot1, Address, Slot).

unify_slots(_, []).
unify_slots(Terms, [Slot1Address=Slot2Address|Arrows]) :-
    get_slot(Terms, Slot1Address, Slot),
    get_slot(Terms, Slot2Address, Slot),
    unify_slots(Terms, Arrows).

construct_program([T1], T2) :- T2 =.. T1.
construct_program([T1|Terms], (T2,Rest)) :- T2 =.. T1, construct_program(Terms, Rest).

compile_net(Name, Program) :-
    net(Name, Fns, Arrows),
    compile_net(Fns, Arrows, Program).

compile_net(Fns, Arrows, Program) :-
    unify_slots(Fns, Arrows),
    construct_program(Fns, Program).

induce(I, L, R) :-
    TermI =.. I,
    TermL =.. L,
    TermR =.. R,
    (TermI -> TermL; TermR).

gp_add(A, B, C) :- C #= A + B.
gp_minus(A, B, C) :- C #= A - B.

gp_gensym(Fn) :- gensym('gp_fn', Fn).

def_pred(Params, Body, Fn) :-
    gp_gensym(Fn),
    LHS =.. [Fn|Params],
    RHS =.. Body,
    assertz(LHS :- RHS).

:- dynamic(net/3).

net('Arithmetic',
    [[gp_add, 3, 4, _],
     [gp_minus, 9, 2, _]],
    [
        [1, 4]=[2, 4]
    ]).

net('Subnet',
    [[compile_net, [[gp_add, 3, 4, _], [print, _], [nl]], [[1, 4]=[2, 2]], _],
     [print, _],
     [nl],
     [call, _]],
    [[1, 4]=[2, 2],
     [1, 4]=[4, 2]]).

net('recursion',
    [[def_pred, [_, _], [induce, [succ, _, _], [_, _, _], [=, _, _]], _],
     [=.., _, [_, _, _]],
     [call, _],
     [print, _]],    
    [[1, 2, 1]=[1, 3, 2, 2],
     [1, 2, 1]=[1, 3, 4, 2],
     [1, 2, 2]=[1, 3, 4, 3],
     [1, 2, 2]=[1, 3, 3, 3],
     [1, 3, 2, 3]=[1, 3, 3, 2],
     [1, 3, 3, 1]=[1, 4],
     [1, 4]=[2, 3, 1],
     [2, 3, 3]=[4, 2],
     [2, 2]=[3, 2]]).


succ(1, 2).
succ(2, 3).

% ?- net('Arithmetic', Fns, Arrows), compile_net(Fns, Arrows, Program), Program.

% ?- net('Subnet', Fns, Arrows), unify_slots(Fns, Arrows).

% ?- net('Subnet', Fns, Arrows), compile_net(Fns, Arrows, Program), Program.

% ?- compile_net('recursion', Program), Program, nl, print(Program), nl.
%@ 3
%@ def_pred([_10128,_10134],[induce,[succ,_10128,_10170],[gp_fn1,_10170,_10134],[=,_10128,_10134]],gp_fn1),gp_fn1(1,3)=..[gp_fn1,1,3],call(gp_fn1(1,3)),print(3)
%@ Program = (def_pred([_A, _B], [induce, [succ, _A, _C], [gp_fn1, _C, _B], [=, _A, _B]], gp_fn1), gp_fn1(1, 3)=..[gp_fn1, 1, 3], call(gp_fn1(1, 3)), print(3)) 

% ?- compile_net('recursion', Program).

% ?- compile_net([[def_pred, [fac, N, X], [induce, [succ, N, N1], [succ, N1, X], [=, N, X]]]], [], P), P.

% ?- clause(fac(A, B), Body).
