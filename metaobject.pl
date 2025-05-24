:- use_module(library(clpfd)).

:- dynamic(obj_counter/1).
:- dynamic(meta_obj/2).
:- dynamic(slot/2).

obj_counter(0).

increase_obj_counter(NewCounter) :-
    obj_counter(OldCounter),
    NewCounter #= OldCounter + 1,
    retractall(obj_counter(OldCounter)),
    asserta(obj_counter(NewCounter)).

make_obj(0, Slots) :-
    increase_obj_counter(ID),
    asserta(meta_obj(ID, 0)),
    asserta(slot(ID, meta_obj/2)),
    make_slots(0, ID, Slots).

make_slots(0, _, []).
make_slots(0, ID, [SlotHead:-SlotBody|Slots]) :-
    SlotHead =.. [Name, ID|_],
    functor(SlotHead, Name, Arity),
    asserta(SlotHead:-SlotBody),
    asserta(slot(ID, Name/Arity)),
    make_slots(0, ID, Slots).

slots(0, ID, Slots) :-
    findall(Name/Arity, slot(ID, Name/Arity), Slots).

call_slot(0, SlotHead) :-
    SlotHead =.. [_, ID|_],
    meta_obj(ID, 0),
    SlotHead.
call_slot(0, SlotHead) :-
    SlotHead =.. [_, ID|_],
    meta_obj(ID, MetaID),
    not(MetaID == 0),
    call_slot(MetaID, SlotHead).

% ?- make_obj(0, [make_obj(MetaID):-(asserta(slot(baloneyID, baloney/2)), asserta(baloney(baloneyID, baloneyVal)))]).

% ?- slot(X, Y).

% ?- meta_obj(X, Y).

% ?- call_slot(0, make_obj(1)).

% ?- slots(0, X, S).

% ?- baloney(X, Y).

% ?- make_obj(0, [make_obj(MetaID, Slots):-()])
