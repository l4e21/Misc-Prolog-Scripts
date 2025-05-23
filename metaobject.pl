:- use_module(library(clpfd)).

:- dynamic(obj_counter/1).
:- dynamic(slot/4).

obj_counter(1).

slot(0, 0, make_obj(Slots, Lamport),
     (obj_counter(ID),
      Counter1 #= ID + 1,
      retractall(obj_counter(Counter1)),
      asserta(obj_counter(Counter1)),
      
      asserta(slot(ID, Lamport, version(Lamport), true)),
      call_slot(0, 0, make_slots(ID, Lamport, Slots)))).

slot(0, 0, make_slots(_, _, []),
     true).
slot(0, 0, make_slots(ID, Lamport, [SlotHead:-SlotBody|Slots]),
     (Slot = slot(ID, Lamport, SlotHead, SlotBody),
      asserta(Slot),
      call_slot(0, 0, make_slots(ID, Lamport, Slots)))).

slot(0, 0, get_slots(ID, Lamport, Slots),
    findall(SlotHead:-SlotBody, slot(ID, Lamport, SlotHead, SlotBody), Slots)).

call_slot(0, 0, SlotHead) :-
    slot(0, 0, SlotHead, SlotBody),
    SlotBody.


% ?- call_slot(0, 0, make_obj([name(a):-true], 1)).
%@ true ;
%@ false.

% ?- slot(A, B, name(a), D).
%@ A = B, B = 1,
%@ D = true.

% ?- call_slot(0, 0, get_slots(1, 1, S)).
%@ S = [(name(a):-true), (version(1):-true)].

% ?- call_slot(0, 0, get_slots(0, 0, S)).
%@ S = [(make_obj(_A, _B):-obj_counter(_C), _D#=_C+1, retractall(obj_counter(_D)), asserta(obj_counter(_D)), asserta(slot(_C, _B, version(...), true)), call_slot(0, 0, make_slots(_C, _B, _A))), (make_slots(_, _, []):-true), (make_slots(_E, _F, [(_G:-_H)|_I]):-_J=slot(_E, _F, _G, _H), asserta(_J), call_slot(0, 0, make_slots(_E, _F, _I))), (get_slots(_K, _L, _M):-findall((_N:-_O), slot(_K, _L, _N, _O), _M))].

% ?- call_slot(0, 0, update_slot(1, name(a)))
