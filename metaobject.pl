:- dynamic(slot/3).

call_slot(SlotHead) :-
    SlotHead =.. [_, ID|_],
    call_slot(ID, SlotHead).
    
call_slot(CallerID, SlotHead) :-
    (slot(CallerID, SlotHead, Body)
    -> Body
    ; (slot(CallerID, inherits(CallerID, InheritsID), Body),
       Body,
       call_slot(InheritsID, SlotHead))).

slot(root, make_obj(Self, Slots, ID),
     (gensym(obj_, ID),
      call_slot(make_slots(Self, ID, Slots)))).

slot(root, make_slots(_Self, _, []), true).
slot(root, make_slots(Self, ID, [(SlotHead, SlotBody)|Slots]),
     (asserta(slot(ID, SlotHead, SlotBody)),
      call_slot(make_slots(Self, ID, Slots)))).

% ?- trace(call_slot/1).
% ?- trace(call_slot/2).
% ?- trace(slot/3).

% ?- call_slot(make_obj(root, [(card_name(Self), true)], ID)).
%@ ID = obj_1.

% ?- slot(obj_1, Head, Body).
%@ Head = card_name(_),
%@ Body = true.

