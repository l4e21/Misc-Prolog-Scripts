
:- dynamic rel_head/2.
:- dynamic rel_body/2.
:- dynamic rel_key/2.


rel_head(s, [attribute(id, int), attribute(name, string)]).
rel_key(s, [id]).

attribute_index(RelVar, Name, Idx) :-
    rel_head(RelVar, Attributes),
    nth0(Idx, Attributes, attribute(Name, _)).

attribute_indices(RelVar, Attributes, Indices) :-
    maplist(attribute_index(RelVar), Attributes, Indices).

rel_key_indices(RelVar, Indices) :-
    rel_key(RelVar, Key),
    attribute_indices(RelVar, Key, Indices).

% ?- rel_key_indices(s, I).

tuple_attribute(RelVar, Tuple, AttrName, AttrValue) :-
    attribute_index(RelVar, AttrName, AttrIdx),
    nth0(AttrIdx, Tuple, AttrValue).

% ?- tuple_attribute(s, [1, "John"], id, V).

tuple_attributes(RelVar, Tuple, Attrs, Vals) :-
    maplist(tuple_attribute(RelVar, Tuple), Attrs, Vals).

% ?- tuple_attributes(s, [1, "John"], [id, name], V).

tuple_key(RelVar, Tuple, KeyVal) :-
    rel_key(RelVar, Key),
    tuple_attributes(RelVar, Tuple, Key, KeyVal).

% ?- tuple_key(s, [1, "John"], V).

validate_attributes([], []) :- !.
validate_attributes([X|Xs], [attribute(_, Type)|Attributes]) :-
    call(Type, X),
    validate_attributes(Xs, Attributes).

%% add_to_relation(RelVar, Tup) :-
%%     rel_head(RelVar, Head),
%%     rel_key_indices(RelVar, Indices),
    
%%     %% rel_key_index(RelVar, KeyIdx),
%%     %% nth0(KeyIdx, Tup, KeyVal),
%%     length(Head, L),
%%     length(Tup, L),
%%     %% not((rel_body(RelVar, Body), nth0(KeyIdx, Body, KeyVal))),
%%     validate_attributes(Tup, Head),
%%     assertz(rel_body(RelVar, Tup)).

% ?- call(integer, 3).

% ?- trace(rel_key_index/2).
% ?- add_to_relation(s, [1, "john"]).

% ?- rel_body(s, Xs).
