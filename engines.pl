
%% Interleaving search with engines

blah(a).
blah(b).
blah(c).
blah(X-Y) :- blah(X), blah(Y).

interleave(S1, S2, Answers) :-
    engine_create(S1, clause(blah(S1), B), E1),
    engine_create(S2, clause(blah(S2), B), E2),
    engine_next(E1, E1Next),
    engine_next(E2, E2Next),
    answers(E1, E2, [E1Next-E2Next], Answers).
    

answers(E1, E2, Acc, Answers) :-
    Acc = [E1Last-E2Last|_],
    (engine_next(E1, E1Next)
    -> (engine_next(E2, E2Next)
       -> Es = [E1Next-E2Next, E1Last-E2Next, E1Next-E2Last]
       ; Es = [E1Next-E2Last]
        ),
       append(Es, Acc, Next),
       answers(E1, E2, Next, Answers)
    ; Answers = Acc).

% ?- interleave(S1, S2, Answers).
%@ Answers = [_A-_B-(_C-_D), c-(_C-_D), _A-_B-c, c-c, b-c, c-b, b-b, a-b, ... - ...|...].

% ?- trace(answers/4).

% ?- trace(gather_next/5).

% ?- engine_create(S1, blah(S1), E1), engine_next(E1, _), engine_next(E1, E).

%% a -- b - - d
%%  \    \
%%   ---- c
%%


edge(a, b).
edge(b, c).
edge(b, d).
edge(c, a).

path(A, B, Acc, Path) :- edge(A, B), reverse([A-B|Acc], Path).

path(A, C, Acc, Path) :-
    edge(A, B),
    path(B, C, [A-B|Acc], Path).

path(A, B, E1) :-
    engine_create(Path, path(A, B, [], Path), E1).

smallest(E1, E2, Smallest) :-
    engine_next(E1, E1Next),
    engine_next(E2, E2Next),
    length(E1Next, L1),
    length(E2Next, L2),
    (L1 < L2, E1 = Smallest; E2 = Smallest).
    

% ?- path(a, b, P), engine_next(P, E), engine_next(P, E2).

% ?- path(a, b, P1), path(b, b, P2), smallest(P1, P2, Smallest).
