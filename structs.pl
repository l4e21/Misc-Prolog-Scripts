:- module(structs, [make_obj/2, class/2, set_slot/3]).

:- dynamic(object_counter/1).
:- dynamic(class/2).

object_counter(1).

add_slots(_, _, []) :- !.
add_slots(ObjId, Type, [(SlotName, SlotValue)|Slots]) :-
    atom_concat(Type, '_', TypePrefix),
    atom_concat(TypePrefix, SlotName, PredName),
    SlotTerm =.. [PredName, ObjId, SlotValue],
    asserta(SlotTerm),
    add_slots(ObjId, Type, Slots).

make_obj(Type, Slots) :-
    object_counter(Counter),
    atom_concat(o, Counter, ObjId),
    Existence =.. [Type, ObjId],
    Counter1 is Counter + 1,
    retractall(object_counter(_)),
    asserta(Existence),
    asserta(object_counter(Counter1)),
    asserta(class(ObjId, Type)),
    add_slots(ObjId, Type, Slots).

set_slot(ID, SlotName, SlotVal) :-
    class(ID, Class),
    atom_concat(Class, '_', Prefix),
    atom_concat(Prefix, SlotName, SlotPredName),
    SlotPred =.. [SlotPredName, ID, SlotVal],
    SlotPredToRetract =.. [SlotPredName, ID, _],
    retractall(SlotPredToRetract),
    asserta(SlotPred).

get_slot(ID, SlotName, SlotVal) :-
    class(ID, Class),
    atom_concat(Class, '_', Prefix),
    atom_concat(Prefix, SlotName, SlotPredName),
    SlotPred =.. [SlotPredName, ID, SlotVal],
    SlotPred.

find_obj(Type, ObjId) :-
    Existence =.. [Type, ObjId],
    Existence.


%% card(o1).
%% card_name(o1, a).
%% card_type(o1, water).

% ?- object_counter(N).

% ?- make_obj(card, [(name, a)]).
%@ true.

% ?- card(X).

% ?- card_name(A, B).

% ?- set_slot(o1, type, water).
%@ false.

% ?- card_type(A, B).
% ?- X = [1,2|[1, 2]].
%@ X = [1, 2, 1, 2].
