
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

%% net([arity, #0#1=3, #0#2=4, #0_+,
%%      #1/3, ])

%% evals to true with X = 7

%% net([Rule|RuleRest], CompiledRules, [Vars|VarsRest]) :-
%%     compile_rule(Rule, CompiledRules, CompiledRulesNew, Vars),
%%     net(RuleRest, CompiledRest, VarsRest).

%% Maybe equals does not count as a rule of its own

%% add_assignments(_, []).
%% add_assignments(Term, [N-V|AssignRest]) :-
%%     arg(N, Term, V),
%%     add_assignments(Term, AssignRest).

%% compile_net_1(Rules, Terms) :-
%%     length(Rules, L),
%%     length(Terms, L),
%%     compile_net_1(Rules, Terms, 1, L).

%% compile_net_1(_, _, N, L) :-
%%     N > L.

%% compile_net_1(Rules, Terms, N, L) :-
%%     N =< L,
%%     nth1(N, Rules, Rule),
%%     nth1(N, Terms, Term),
%%     get_dict(assign, Rule, Assigns),
%%     get_dict(name, Rule, Name),
    
%%     length(Assigns, Arity),
%%     functor(Term, Name, Arity),
%%     add_assignments(Term, Assigns),
%%     N1 is N + 1,
%%     compile_net_1(Rules, Terms, N1, L).

gp_add(A, B, C) :- C is A + B.
gp_minus(A, B, C) :- C is A - B.

get_slot(Term, [], Term).
get_slot(Term, [N|Address], Slot) :-
    nth1(N, Term, Slot1),
    get_slot(Slot1, Address, Slot).

%% compile_net(Terms, Arrows, Result) :-
%%     %% Perform unification
%%     compile_net(Terms, Arrows),
%%     %% maplist(=.., Result, Terms).

compile_net(_, []).
compile_net(Terms, [Slot1Address=Slot2Address|Arrows]) :-
    get_slot(Terms, Slot1Address, Slot),
    get_slot(Terms, Slot2Address, Slot),
    compile_net(Terms, Arrows).

net([[gp_add, 3, 4, _],
     [gp_minus, 9, 2, _]],
   [[1, 4]=[2, 4]]).

% ?- net(Fns, Arrows), copy_term(Fns, Preds), compile_net(Preds, Arrows), maplist(=.., Program, Preds), maplist(call, Program).
%@ Fns = [[gp_add, 3, 4, _], [gp_minus, 9, 2, _]],
%@ Arrows = [[1, 4]=[2, 4]],
%@ Preds = [[gp_add, 3, 4, 7], [gp_minus, 9, 2, 7]],
%@ Program = [gp_add(3, 4, 7), gp_minus(9, 2, 7)] ;
%@ false.

