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

pid_correction(PGain, IGain, DGain, P, I, D, Correction) :-
    Correction is (PGain * P) + (IGain * I) + (DGain * D).

euler(Pos, Vel, Timestep, Force, NewPos, NewVel) :-
    NewVel is Vel + Force*Timestep - (Vel*0.1),
    NewPos is Pos + NewVel*Timestep.

plot_pid(G, StartT, EndT, Timestep, Expected, Gains) :-
    plot_pid(G, StartT, EndT, Timestep, Expected, Gains, 0, 0, 0, 0).

plot_pid(_G, T, EndT, _Timestep, _Expected, _Gains, _Pos, _Vel, _PrevError, _IntegralError) :-
    T #>= EndT, !.

plot_pid(G, T, EndT, Timestep, Expected, [PGain, IGain, DGain], Pos, Vel, Error, I) :-
    send(G, append, T, Pos),
    error(Expected, Pos, NewError),
    error_integral(Timestep, NewError, I, NewI),
    error_derivative(Timestep, Error, NewError, D),
    pid_correction(PGain, IGain, DGain, NewError, NewI, D, Correction),
    euler(Pos, Vel, Timestep, Correction, NewPos, NewVel), 
    T1 is (T + 1),
    format("T=~2f E=~2f D=~2f V=~2f Pos=~2f Corr=~2f~n",
           [T, NewError, D, Vel, Pos, Correction]),
    plot_pid(G, T1, EndT, Timestep, Expected, [PGain, IGain, DGain], NewPos, NewVel, Error, NewI).

plot_term(Term, StartX, EndX, StartY, EndY) :-
    new(W, auto_sized_picture('Plotter demo')),
    send(W, display, new(P, plotter)),
    send(P, axis, plot_axis(x, StartX, EndX, @default, 1800)),
    send(P, axis, plot_axis(y, StartY, EndY, @default, 1200)),
    send(P, graph, new(G, plot_graph)),
    Term =.. [_, G|_],
    Term,
    send(W, open).

% ?- plot_term(plot_pid(G, 0, 50, 1, 100, [0.01, 0, 0]), 0, 50, 0, 250).
