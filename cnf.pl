

reduce(implies(F1, F2), or(not(F1), F2)).

reduce(not(and(F1, F2)), or(not(F1), not(F2))).

reduce(not(or(F1, F2)), and(not(F1), not(F2))).

reduce(not(not(F)), F).

reduce(not(forall(X, F)), exists(X, not(F))).

reduce(not(exists(X, F)), forall(X, not(F))).

rewrite_once(T, N) :-
    reduce(L, R),
    subsumes_term(L, T),
    copy_term(L-R, L1-R1),
    L1 = T, N = R1.

normalise(Term, Term) :- (var(Term) ; atomic(Term)), !.
normalise(Term, Normalised) :-
    compound(Term),
    Term =.. [F|Args],
    normalise_args(Args, NormArgs),
    TermWithNormArgs =.. [F|NormArgs],
    (rewrite_once(TermWithNormArgs, NormalisedTerm) -> normalise(NormalisedTerm, Normalised)
    ; Normalised = TermWithNormArgs).

normalise_args([], []).
normalise_args([Arg|Args], [NormArg|NormArgs]) :-
    normalise(Arg, NormArg),
    normalise_args(Args, NormArgs).

% ?- trace(normalise/2).
% ?- trace(normalise_args/2).

% ?- normalise(implies(not(f1), f2), R).
%@ R = or(f1, f2).

% ?- normalise(A, or(not(f1), f2)).
%@ X = f1,
%@ Y = f2.
%@ X = f1,
%@ Y = f2.

% ?- normalise(implies(f1, f2), R).
%@ R = or(not(f1), f2).

% ?- subsumes_term((F), A).

%  ?- T = not(not(F1)), reduce(L, R), subsumes_term(L, T).


% ?- vm_list(rewrite_once/2).
