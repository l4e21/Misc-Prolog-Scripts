
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

induce(I, L, R) :- I -> L; R.
%% induce(I, L, R) :- TermI =.. I, TermL =.. L, TermR =.. R, TermI -> TermL; R.

gp_add(A, B, C) :- C #= A + B.
gp_minus(A, B, C) :- C #= A - B.

gp_gensym(Fn) :- gensym('gp_fn', Fn).

def_pred(LHS, RHS) :-
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
    [[gp_gensym, _],
     [=.., _, [_, _, _]],
     [compile_net, [[succ, _, _]] , [], _],
     [compile_net, [[=, _, _]], [], _],
     [compile_net, [[induce, _, _, _]], [], _],
     [compile_net, [[_, _, _]], [], _],
     [def_pred, _, _],
     [=.., _, [_, _, _]],
     [call, _],
     [print, _]],
    
    [[1, 2]=[2, 3, 1],
     [2, 2]=[5, 2, 1, 3],
     [2, 3, 1]=[6, 2, 1, 1],
     [2, 3, 1]=[8, 3, 1],
     [2, 3, 3]=[6, 2, 1, 3],
     [2, 3, 2]=[3, 2, 1, 3],
     [2, 3, 3]=[4, 2, 1, 3],
     [3, 2, 1, 2]=[6, 2, 1, 2],
     [3, 2, 1, 2]=[4, 2, 1, 2],
     [3, 4]=[5, 2, 1, 2],
     [4, 4]=[5, 2, 1, 4],
     [5, 4]=[7, 3],
     [6, 4]=[7, 2],
     [8, 2]=[9, 2],
     [8, 3, 3]=[10, 2]]).

succ(1, 2).
succ(2, 3).

% ?- net('Arithmetic', Fns, Arrows), compile_net(Fns, Arrows, Program), Program.

% ?- net('Subnet', Fns, Arrows), unify_slots(Fns, Arrows).

% ?- net('Subnet', Fns, Arrows), compile_net(Fns, Arrows, Program), Program.

% ?- compile_net('recursion', Program), Program, nl, print(Program), nl.
%@ 3
%@ gp_gensym(gp_fn1),gp_fn1(_10158,_10164)=..[gp_fn1,_10158,_10164],compile_net([[succ,_10200,_10158]],[],succ(_10200,_10158)),compile_net([[=,_10200,_10164]],[],_10200=_10164),compile_net([[induce,succ(_10200,_10158),gp_fn1(_10158,_10164),_10200=_10164]],[],induce(succ(_10200,_10158),gp_fn1(_10158,_10164),_10200=_10164)),compile_net([[gp_fn1,_10200,_10164]],[],gp_fn1(_10200,_10164)),def_pred(gp_fn1(_10200,_10164),induce(succ(_10200,_10158),gp_fn1(_10158,_10164),_10200=_10164)),gp_fn1(1,3)=..[gp_fn1,1,3],call(gp_fn1(1,3)),print(3)
%@ Program = (gp_gensym(gp_fn1), gp_fn1(_A, _B)=..[gp_fn1, _A, _B], compile_net([[succ, _C, _A]], [], succ(_C, _A)), compile_net([[=, _C, _B]], [], _C=_B), compile_net([[induce, succ(..., ...)|...]], [], induce(succ(_C, _A), gp_fn1(_A, _B), _C=_B)), compile_net([[gp_fn1|...]], [], gp_fn1(_C, _B)), def_pred(gp_fn1(_C, _B), induce(succ(..., ...), gp_fn1(..., ...), ... = ...)), gp_fn1(..., ...)=..[...|...], call(...), print(...)) 
