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

% ?- decode_one(Xs, 1-4, [2, 3]).

% ?- decode_one([1,1,2,3], N-X, R).

% This is why decoding can't be fully bidirectional in this case

%% Duplicate the elements of a list

dupli([], []).
dupli([X|Xs], [X, X|Ys]) :- dupli(Xs, Ys).

% ?- dupli([1, 2, 3], Xs).

%% Duplicate elements of a list a given number of times

dupli([], _, []).
dupli([X|Xs], N, Ys) :-
    length(DupedX, N),
    maplist(=(X), DupedX),
    dupli(Xs, N, Ys1),
    append(DupedX, Ys1, Ys).

repeatit(X, 1, [X]) :- !.
repeatit(X, N, [X|Xs]) :-
    N1 #= N - 1,
    repeatit(X, N1, Xs).

repeat2(X, N, L) :-
    maplist(=(X), L),
    length(L, N).


% Note which is faster, compiler does not fuse map and length
% ?- call_time(repeatit(1, 7, L), D).
% ?- call_time(repeat2(1, 7, L), D).

% Drop every nth element of a list

drop(N, L1, L2) :- drop(N, 0, L1, L2).

drop(_, _, [], []) :- !.
drop(N, N, [_|L1], L2) :- drop(N, 0, L1, L2).
drop(N, I, [X|L1], [X|L2]) :-
    I #\= N,
    I1 #= I + 1,
    drop(N, I1, L1, L2).

% ?- drop(2, [1, 2, 3, 4, 5, 6], L).

%% Split a list into two parts, given the length of the first part

split(L, 0, [], L).
split([X|L], N, [X|L1], L2) :-
    N #> 0,
    N1 #= N - 1,
    split(L, N1, L1, L2).

% ?- split([1, 2, 3, 4], 3, L1, L2).

%% Extract a slice from a list

slice(0, 0, [X|_], [X]).
slice(0, End, [X|L], [X|S]) :-
    End #> 0,
    End1 #= End - 1,
    slice(0, End1, L, S).
slice(Start, End, [_|L], S) :-
    Start #> 0,
    End #> Start,
    Start1 #= Start - 1,
    End1 #= End - 1,
    slice(Start1, End1, L, S).

% ?- slice(1, 3, [1, 2, 3, 4, 5], S).

%% Rotate a list N places to the left

rotate(L1, X, L2) :-
    length(L1, Len),
    ModX #= X mod Len,
    split(L1, ModX, Start, Rest),
    append(Rest, Start, L2).

% ?- rotate([1, 2, 3, 4, 5, 6], 7, L).


%% Remove the K'th element of a list

remove_at([X|L], 0, X, L).
remove_at([_|L], N, X, R) :-
    N #> 0,
    N1 #= N - 1,
    remove_at(L, N1, X, R).

% ?- remove_at([1, 2, 3, 4], 2, X, R).
    
%% Insert an element at a given position of a list

