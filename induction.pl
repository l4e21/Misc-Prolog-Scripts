:- module(induction, []).

%% induce(
%%     [
%%     =(hasbeak(X), bird(X)),
%%     =(haswings(X), bird(X)),
%%     =(bird(X), vulture(X)),
%%     =(carnivore(X), vulture(X)),
%%     ],    
%%     [
%%     haswings(tweety),
%%     hasbeak(tweety)
%%     ]).

:- table generalise/2.

copy_and_generalise_args(0, _, _, _).

copy_and_generalise_args(N, N, G, T) :-
    arg(N, T, TA),
    generalise(TA, GA),
    arg(N, G, GA),
    I1 is N - 1,
    copy_and_generalise_args(I1, N, G, T).

copy_and_generalise_args(I, N, G, T) :-
    not(I == N),
    arg(I, G, A),
    arg(I, T, A),
    I1 is I - 1,
    copy_and_generalise_args(I1, N, G, T).

generalise(T, G) :-
    callable(T),
    functor(T, Functor, Arity),
    functor(G, Functor, Arity),
    between(1, Arity, N),
    copy_and_generalise_args(Arity, N, G, T).

generalise(T, _).

%% induce(B, Eplus, Eminus, H) :-
%%     append(B, Eplus, QH),
%%     induce(QH, B, Eplus, Eminus, H).

%% induce([F|QH], B, Eplus, Eminus, Hs) :-
%%     generalise(F, Hs).

