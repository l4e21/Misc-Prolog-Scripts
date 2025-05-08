:- use_module(library(clpfd)).

%% Find the last element of a list.
my_last(X, [X]) :- !.
my_last(X, [_|Bs]) :-
    my_last(X, Bs).

% ?- call_time(my_last(X, [a, b, c, d]), T, R).

%% Find the last but one element of a list.
my_butlast(X, [X, _]) :- !.
my_butlast(X, [_, X, _]) :- !.
my_butlast(X, [_, _|Bs]) :-
    my_butlast(X, Bs).

my_butlast_2(X, [X, _]) :- !.
my_butlast_2(X, [_, A|Bs]) :-
    my_butlast_2(X, [A|Bs]).

%% We can reduce inferences and optimise for performance by skipping through two at once.
%% The definition is slightly more complex.

% ?- call_time(my_butlast(X, [a, b, c, d]), T, R).

% ?- call_time(my_butlast(X, [a, b, c, d, e]), T, R).

% ?- call_time(my_butlast_2(X, [a, b, c, d, e]), T, R).


%% Find the K'th element in a list

element_at(X, 0, [X|_]).
element_at(X, K, [_|Xs]) :-
    K #> 0,
    K1 #= K - 1,
    element_at(X, K1, Xs).

% ?- call_time(element_at(X, 3, [a, b, c, d, e]), T, R).

%% Find the number of elements in a list

my_count(0, []).
my_count(N, [_|Xs]) :-
    N #= N1 + 1,
    my_count(N1, Xs).

% ?- call_time(my_count(N, [1, 2, 3, 4, 5]), T, R).

%% Reverse a list

my_reverse([], []).
my_reverse([X|Xs], Ys) :-
    append(Ys1, [X], Ys),
    my_reverse(Xs, Ys1).

% Now tail recursive
my_reverse([], Acc, Acc).
my_reverse([X|Xs], Ys, Acc) :-
    my_reverse(Xs, Ys, [X|Acc]).

% ?- call_time(my_reverse([1, 2, 3], Ys), T, R).

% ?- call_time(my_reverse([1, 2, 3], Ys, []), T, R).

%% Find out whether a list is a palindrome

palindrome([]) :- !.
palindrome([_]) :- !.
palindrome([X|Xs]) :-
    append(Xs1, [X], Xs),
    palindrome(Xs1).

% ?- call_time(palindrome([1, X, 2, 1]), T, R).

%% Flatten a nested list structure

my_flatten([], []) :- !.

my_flatten([A|Xs], [A|Ys]) :-
    \+ is_list(A),
    my_flatten(Xs, Ys),
    !.

my_flatten([As|Xs], Ys) :-
    is_list(As),
    my_flatten(As, Bs),
    append(Bs, Ys1, Ys),
    my_flatten(Xs, Ys1).

% ?- call_time(my_flatten([[1, 2, 3], 2, 3], Ys), T, R).

% Now tail-recursive

my_flatten([], Acc, Acc).

my_flatten([A|Xs], Ys, Acc) :-
    \+ is_list(A),
    append(Acc, [A], Acc1),
    my_flatten(Xs, Ys, Acc1).

my_flatten([As|Xs], Ys, Acc) :-
    is_list(As),
    my_flatten(As, Acc1, Acc),
    my_flatten(Xs, Ys, Acc1).

% ?- trace(my_flatten/3).
% ?- my_flatten([[1, 2, 3], 2, 3], Ys, []).


% ?- [1, 2, 3] =.. T.

% ?- [] =.. T.

%% Eliminate consecutive duplicates of list elements

compress([X], [X]).

compress([Y, X|Xs], [Y|Ys]) :-
    not(Y = X),
    compress([X|Xs], Ys).

compress([X, X|Xs], Ys) :-
    compress([X|Xs], Ys).

% ?- compress([1, 2, 2, 3], Ys).

%% Pack consecutive duplicates of list elements into sublists

transfer([X], [], [X], []).
transfer([X|Xs], [], Acc, RestXs) :- transfer(Xs, [X], Acc, RestXs).

transfer([X|RestXs], [Y|Acc], [Y|Acc], [X|RestXs]) :- not(X==Y).
transfer([X|Xs], [X|Ys], Acc, RestXs) :-
    transfer(Xs, [X,X|Ys], Acc, RestXs).

pack([], []).
pack(Xs, [Dupes|Ys]) :-
    transfer(Xs, [], Dupes, Remainder),
    pack(Remainder, Ys).    

% ?- transfer([1, 1, 2, 3], [], D, R).

% ?- transfer([2, 3], [], D, R).

% ?- transfer([3], [], D, R).

% ?- pack([1, 1, 2, 3], Xs).

%% Run length-encoding of a list

encode([], []).
encode(Xs, Ys) :-
    pack(Xs, Packed),
    maplist([[A|As], L-A]>>length([A|As], L),
            Packed,
            Ys).

% ?- encode([1,1,2,3], Xs).

%% Modify run-length encoding

encodings([A], 1-A, []).

encodings([A|Bs], Encoding, Rest) :-
    encodings(Bs, A, 1, Encoding, Rest).

encodings([A|Bs], A, Acc, Encoding, Rest) :-
    Acc1 #= Acc + 1,
    encodings(Bs, A, Acc1, Encoding, Rest).

encodings([A|Rest], B, N, N-B, [A|Rest]) :-
    dif(A, B).

modified_encodings([], []).
modified_encodings(Xs, [X|Ys]) :-
    encodings(Xs, 1-X, Remainders),
    modified_encodings(Remainders, Ys).
modified_encodings(Xs, [N-X|Ys]) :-
    encodings(Xs, N-X, Remainders),
    dif(N, 1),
    modified_encodings(Remainders, Ys).

% ?- encodings([1, 1, 2, 3], Encoding, Rest).

% ?- encodings([3], R, S).

% ?- modified_encodings([1, 1, 2, 3], Ys).

%% Decode a run-length encoded list

my_repeat(1, X, [X]).
my_repeat(N, X, [X|Xs]) :-
    N #> 1,
    N1 #= N - 1,
    my_repeat(N1, X, Xs).
    

decodings([], []).
decodings([X|Xs], [X|RemainingEncodings]) :-
    X \= _-_,
    decodings(Xs, RemainingEncodings).
decodings(Xs, [N-X|RemainingEncodings]) :-
    my_repeat(N, X, Subs),
    append(Subs, Xs1, Xs),
    decodings(Xs1, RemainingEncodings).

decode_one(Xs, N-X, Remaining) :-
    my_repeat(N, X, Subs),
    append(Subs, Remaining, Xs).


% ?- decodings(Xs, [2-1, 2, 3]).

% ?- decodings([1, 1, 2, 3], Xs).


%% Duplicate elements of a list

% ?- decode_one(Xs, 1-4, [2, 3]).

% ?- decode_one([1,1,2,3], N-X, R).

%% This is why decoding can't be fully bidirectional in this case

