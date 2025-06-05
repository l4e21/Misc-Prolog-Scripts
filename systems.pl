
:- use_module(library(clpfd)).
:- use_module(library(pce)).
:- use_module(library('plot/plotter')).
:- use_module(library(autowin)).

on_off(E, 0) :- E #< 50.
on_off(E, 100) :- E #>= 50.

plot_on_off(_) :-
    To is 100,
    new(W, auto_sized_picture('Plotter demo')),
    send(W, display, new(P, plotter)),
    send(P, axis, plot_axis(x, 0, To, @default, To)),
    send(P, axis, plot_axis(y, 0, To*2, @default, To*2)),
    send(P, graph, new(G, plot_graph)),
    plot_on_off(G, 0, To),
    send(W, open).

plot_on_off(_G, X, To) :-
    X #>= To, !.
plot_on_off(G, X, To) :-
    on_off(X, Y),
    send(G, append, X, Y),
    X1 #= X + 1,
    plot_on_off(G, X1, To).

% ?- plot_on_off(_).

proportional(Err, Gain, V) :- Err #> 100, V #= 100 * Gain.
proportional(Err, _, 0) :- Err #< 50.
proportional(Err, Gain, V) :-
    Err #=< 100, Err #>= 50, V #= Err*Gain.

% ?- proportional(40, X).

plot_proportional(Gain) :-
    To is 150,
    new(W, auto_sized_picture('Plotter demo')),
    send(W, display, new(P, plotter)),
    send(P, axis, plot_axis(x, 0, To, @default, To)),
    send(P, axis, plot_axis(y, 0, To*2, @default, To*2)),
    send(P, graph, new(G, plot_graph)),
    plot_proportional(G, 0, To, Gain),
    send(W, open).

plot_proportional(_G, X, To, _) :-
    X #>= To, !.
plot_proportional(G, X, To, Gain) :-
    proportional(X, Gain, Y),
    send(G, append, X, Y),
    X1 #= X + 1,
    plot_proportional(G, X1, To, Gain).

% ?- plot_proportional(5).

error(Desired, Actual, Error) :- Error is Desired - Actual.

error_integral(Timestep, Error, ErrorIntegral1, ErrorIntegral2) :-
    ErrorIntegral2 is ErrorIntegral1 + (Timestep*Error).

error_derivative(Timestep, PrevError, Error, D) :-
    D is (Error - PrevError) / Timestep.

plot_pid(PGain, IGain, DGain) :-
    To is 50,
    new(W, auto_sized_picture('Plotter demo')),
    send(W, display, new(P, plotter)),
    send(P, axis, plot_axis(x, 0, To, @default, To)),
    send(P, axis, plot_axis(y, 0, To*5, @default, To*2)),
    send(P, graph, new(G, plot_graph)),
    plot_pid(G, 0, To, 0, 0, 0, PGain, IGain, DGain),
    send(W, width, 1000),
    send(W, height, 1000),
    send(W, open).

plot_pid(_G, T, To, _Actual, _PrevError, _IntegralError, _PGain, _IGain, _DGain) :-
    T #>= To, !.

plot_pid(G, T, To, Actual, PrevError, IntegralError1, PGain, IGain, DGain) :-
    error(100, Actual, Error),
    error_integral(1, Error, IntegralError1, IntegralError2),
    error_derivative(1, PrevError, Error, D),
    Actual2 is (PGain * Error) + (IGain * IntegralError2) + (DGain * D) + Actual, 
    %% format('~50f ~50f ~50f ~50f', [Error, IntegralError2, D, Actual2]),
    %% nl,
    send(G, append, T, Actual2),
    T1 is T + 1,
    plot_pid(G, T1, To, Actual2, Error, IntegralError2, PGain, IGain, DGain).
    
% ?- plot_pid(0.5, 0, 0).
%@ true.

