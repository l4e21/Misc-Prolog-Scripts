:- module(structs, []).

:- dynamic(object_counter/1).

object_counter(1).

:- dynamic(struct/1).

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
    asserta(Existence),
    Counter1 is Counter + 1,
    retractall(object_counter(_)),
    asserta(object_counter(Counter1)),
    add_slots(ObjId, Type, Slots).


%% card(o1).
%% card_name(o1, a).
%% card_type(o1, water).

% ?- object_counter(N).

% ?- make_obj(card, [(name, a)]).

% ?- card(X).

% ?- name(o1, Y).

% ?- card_name(A, B).
