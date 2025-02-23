
:- use_module(library(logtalk)).

:- protocol(set).
:- public([member/1]).
:- end_protocol.

:- object(empty_set, implements(set)).
member(_) :- false.
:- end_object.

:- object(evens, implements(set)).
member(X) :- (X mod 2) =:= 0.
:- end_object.


:- object(union(_S1_, _S2_), implements(set)).

member(X) :- (var(_S1) -> implements_protocol(_S1_, set); true), _S1_::member(X).
member(X) :- (var(_S2) -> implements_protocol(_S2_, set); true), _S2_::member(X).

:- end_object.

