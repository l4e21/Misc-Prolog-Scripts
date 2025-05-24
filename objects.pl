:- use_module(library(clpfd)).

:- dynamic(slot/3).

make_slots(_, []).
make_slots(ID, [SlotHead:-SlotBody|Slots]) :-
    SlotHead =.. [Name, ID|Args],
    SlotHeadWithVersion =.. [Name, ID, Version|Args],
    (clause(SlotHeadWithVersion, _)
    -> Version1 #= Version + 1
    ; Version1 = 1),
    SlotHeadWithVersion1 =.. [Name, ID, Version1|Args],
    asserta(SlotHeadWithVersion1:-SlotBody),
    asserta(slot(ID, Version1, SlotHeadWithVersion1)),
    make_slots(ID, Slots).


% ?- make_slots(o, [card_name(ID):-true]).

% ?- make_slots(card_factory, [create(ID, Name) :- make_slots(Name, [card_name(Name):-true])]).
%
% ?- create(C, V, A).

% ?- slot(X, Y, Z).

% ?- make_card
