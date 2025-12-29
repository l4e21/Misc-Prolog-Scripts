%% PARTIAL DEDUCTION OF STRATIFIED PROGRAMS
%% https://dl.acm.org/doi/pdf/10.1145/227595.227597

% Desired Execution Model
% 1. User calls q(X).
% 2. q(X) :- p(X) triggered, p/1 enters into the system of equations under consideration
% 3. p(X) :- q(X) triggered, notices q/1 already present, yields nothing.
% 4. p(a) discovered for q(X) yielding q(a).

q(X) :- p(X).

p(X) :- q(X).
p(a).

find_all_clauses(Goal, [Goal:-Bodys]) :-
    findall(Goal:-Body, clause(Goal, Body), Bodys).

% ?- find_all_clauses(q(X), Bs).

subgoal_rules(System, Subgoal, Rules) :-
    member(Subgoal:-Rules, System).

% ?- subgoal_rules([q(X):-[q(_A):-true, q(_A):-p(_A)]], q(B), R).

update_subgoal_rules([OtherSubgoal:-R|Subgoals], Subgoal, New, [OtherSubgoal:-R|System]) :-
    OtherSubgoal \= Subgoal,
    update_subgoal_rules(Subgoals, Subgoal, New, System).
update_subgoal_rules([Subgoal:-_|Subgoals], Subgoal, New, [Subgoal:-New|Subgoals]).

append_subgoal_rule([Other:-R|Subgoals], Subgoal:-New, [Other:-R|System]) :-
    Other \= Subgoal,
    append_subgoal_rules(Subgoals, Subgoal:-New, System).
append_subgoal_rule([Subgoal:-R|Subgoals], Subgoal:-New, [Subgoal:-NewRules|Subgoals]) :-
    append(R, [Subgoal:-New], NewRules).

% ?- update_subgoal_rules([q(X):-[q(_A):-true, q(_A):-p(_A)]], q(B), [], System).

% ?- append_subgoal_rule([q(X):-[q(_A):-true, q(_A):-p(_A)]], q(B):-true, System).

trigger_rules(_Subgoal:-[], System, System).
trigger_rules(Subgoal:-[(_RuleHead:-true)|Rules], Init, NewSystem) :-
    trigger_rules(Subgoal:-Rules, Init, NewSystem).
trigger_rules(Subgoal:-[(RuleHead:-RuleBody)|Rules], Init, NewSystem) :-
    RuleBody \= true,
    % IF the RuleBody refers to a predicate that's already pulled into the system
    (subgoal_rules(Init, RuleBody, ToUnify)
    % THEN take the ground facts of that predicate, and unify them with RuleHead, generating new rules for RuleHead
    -> findall(RuleHead:-true, (member(Base:-true, ToUnify), RuleBody = Base), RBs),
       subgoal_rules(Init, Subgoal, Rules1),
       append(Rules1, RBs, Rs),
       print(Rs),
       nl,
       update_subgoal_rules(Init, Subgoal, Rs, NewSystem)
    % OTHERWISE 
    ; find_all_clauses(RuleBody, ToAppend),
      append(Init, ToAppend, NewSystem1)
    ),
    trigger_rules(Subgoal:-Rules, NewSystem1, NewSystem).

trigger_subgoals([], System, System).
trigger_subgoals([Subgoal:-Rules|Subgoals], Init, NewSystem) :-
    trigger_rules(Subgoal:-Rules, Init, NewSystem1),
    trigger_subgoals(Subgoals, NewSystem1, NewSystem).

query(Goal, System) :-
    find_all_clauses(Goal, Init),
    trigger_subgoals(Init, Init, System).

pass(System, System1) :-
    trigger_subgoals(System, System, System1).

% ?- initial_system(q(X), Bs).

% ?- query(q(X), I), pass(I, I1).
%@ [(q(_6372):-p(_6372)),(q(a):-true)]
%@ [(p(_5730):-q(_5730)),(p(a):-true),(p(a):-true)]
%@ I = [(q(X):-[(q(_A):-p(_A))]), (p(_A):-[(p(X):-q(X)), (p(a):-true)])],
%@ I1 = [(q(X):-[(q(_A):-p(_A)), (q(a):-true)]), (p(_A):-[(p(X):-q(X)), (p(a):-true), (p(a):-true)])] 

% ?- functor(q(X), P, A).



