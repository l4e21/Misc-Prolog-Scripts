:- use_module(library(clpfd)).

:- dynamic(obj_counter/1).
:- dynamic(meta_obj/2).
:- dynamic(slot/2).

obj_counter(0).

make_obj(0, Slots) :-
    obj_counter(Counter),
    ID #= Counter + 1,
    retractall(obj_counter(Counter)),
    asserta(obj_counter(ID)),
    
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
%@ MetaID = 1.

% ?- slot(X, Y).
%@ X = 1,
%@ Y = make_obj/1 ;
%@ X = 1,
%@ Y = meta_obj/2.

% ?- meta_obj(X, Y).
%@ X = 1,
%@ Y = 0.

% ?- call_slot(0, make_obj(1)).
%@ true ;
%@ false.

% ?- slots(0, X, S).
%@ S = [baloney/2, make_obj/1, meta_obj/2].

% ?- baloney(X, Y).
%@ X = baloneyID,
%@ Y = baloneyVal.

% ?- make_obj(0, [
