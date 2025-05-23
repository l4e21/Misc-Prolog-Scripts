:- module(structs, [make_obj/2, class/2, set_slot/2, slot/2]).

:- dynamic(object_counter/1).
:- dynamic(class/2).
:- dynamic(slot/2).

object_counter(1).

add_slots(_, _, []) :- !.
add_slots(ObjId, Type, [SlotHead|Slots]) :-
    SlotHead =.. [SlotName, ObjId|RestArgs],
    atom_concat(Type, '_', TypePrefix),
    atom_concat(TypePrefix, SlotName, PredName),
    SlotTerm =.. [PredName, ObjId|RestArgs],
    asserta(SlotTerm),
    (slot(ObjId, SlotName) -> true; asserta(slot(ObjId, SlotName))),
    add_slots(ObjId, Type, Slots).
add_slots(ObjId, Type, [SlotHead:-SlotBody|Slots]) :-
    SlotHead =.. [SlotName, ObjId|RestArgs],
    atom_concat(Type, '_', TypePrefix),
    atom_concat(TypePrefix, SlotName, PredName),
    SlotHeadTerm =.. [PredName, ObjId|RestArgs],
    SlotTerm = (SlotHeadTerm:-SlotBody),
    asserta(SlotTerm),
    (slot(ObjId, SlotName) -> true; asserta(slot(ObjId, SlotName))),
    add_slots(ObjId, Type, Slots).

make_obj(Type, Slots) :-
    object_counter(Counter),
    atom_concat(o, Counter, ObjId),
    ExistencePredicate =.. [Type, ObjId],
    Counter1 is Counter + 1,
    retractall(object_counter(_)),
    asserta(ExistencePredicate),
    asserta(object_counter(Counter1)),
    asserta(class(ObjId, Type)),
    add_slots(ObjId, Type, Slots).

set_slot(ObjId, SlotHead) :-
    class(ObjId, Class),
    SlotHead =.. [SlotName, ObjId|RestArgs],
    atom_concat(Class, '_', Prefix),
    atom_concat(Prefix, SlotName, SlotPredName),
    SlotPred =.. [SlotPredName, ObjId|RestArgs],
    asserta(SlotPred).
set_slot(ObjId, SlotHead:-SlotBody) :-
    class(ObjId, Class),
    SlotHead =.. [SlotName, ObjId|RestArgs],
    atom_concat(Class, '_', Prefix),
    atom_concat(Prefix, SlotName, SlotPredName),
    SlotHeadPred =.. [SlotPredName, ObjId|RestArgs],
    SlotPred = (SlotHeadPred:-SlotBody),
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

% ?- make_obj(card, [name(ID, A):-A=water, type(ID, water):-true]).

% ?- card(X).
%@ Correct to: "structs:card(X)"? yes
%@ X = o1.

% ?- card_name(A, B).
%@ Correct to: "structs:card_name(A,B)"? yes
%@ A = o1,
%@ B = water.

% ?- set_slot(o1, type(ID, water):-true).
%@ ID = o1.

% ?- card_type(A, B).
%@ Correct to: "structs:card_type(A,B)"? yes
%@ A = o1,
%@ B = water ;
%@ A = o1,
%@ B = water.
