:- module(snap, []).
:- use_module(library(pce)).
:- use_module(library(clpfd)).

save(File) :-
    expand_file_name(File, [FileExpanded]),
    (exists_file(FileExpanded)
    -> write("Already exists. Overwrite? Y/N"),
       nl,
       (read('Y')
       -> true
       ; fail)
    ; true),
    open(FileExpanded, write, Stream),
    with_output_to(Stream,
                   (write(":- module(snap, []).\n:- use_module(library(pce)).\n:- use_module(library(clpfd)).\n"),
                    listing(snap:_))),
    close(Stream).

:- dynamic entry/4.

days_in_month(1, 31).
days_in_month(2, 28).
days_in_month(3, 31).
days_in_month(4, 30).
days_in_month(5, 31).
days_in_month(6, 30).
days_in_month(7, 31).
days_in_month(8, 31).
days_in_month(9, 30).
days_in_month(10, 31).
days_in_month(11, 30).
days_in_month(12, 31).

valid_time(Hr:Min) :-
    Hr in 0..23,
    Min in 0..59.    

before(Hr1:Min1, Hr2: Min2) :-
    Hr1 * 60 + Min1 #< Hr2 * 60 + Min2.

after(Hr1:Min1, Hr2: Min2) :-
    Hr1 * 60 + Min1 #> Hr2 * 60 + Min2.

same_time(Hr:Min, Hr: Min).

time_delta(Hr1:Min1, DeltaHr:DeltaMin, Hr2:Min2) :-
    Minutes #= Min1 + DeltaMin,
    Hours #= Hr1 + DeltaHr + (Minutes // 60),
    Min2 #= Minutes mod 60,
    Hr2 #= Hours mod 24.

overlapping_times(StartHr1:StartMin1, EndHr1:EndMin1, StartHr2:StartMin2, EndHr2:EndMin2) :-
    (after(EndHr1:EndMin1, StartHr2:StartMin2), before(StartHr1:StartMin1, EndHr2:EndMin2)
    -> true
    ; before(StartHr1:StartMin1, EndHr2:EndMin2), after(EndHr1:EndMin1, StartHr2:StartMin2)).


overlapping_entry(entry(Yr/Month/Day, StartHr:StartMin, EndHr:EndMin, _),
                  entry(Yr/Month/Day, StartHr1:StartMin1, EndHr1:EndMin1, Info1)) :-
    entry(Yr/Month/Day, StartHr1:StartMin1, EndHr1:EndMin1, Info1),
    overlapping_times(StartHr:StartMin, EndHr:EndMin, StartHr1:StartMin1, EndHr1:EndMin1).

valid_entry(entry(_Yr/_Month/_Day, StartHr:StartMin, EndHr:EndMin, _Info)) :-
    valid_time(StartHr:StartMin),
    valid_time(EndHr:EndMin),    
    before(StartHr:StartMin, EndHr:EndMin).

% ?- snap:save("~/prolog/examplesnap.pl").

% ?- assertz(snap:a).

% ?- assertz(snap:entry(2025/3/19, 10:0, 11:40, "See Doctor")).


%% We have to be very specific about the point at which we're instantiating the clpfd vars

% ?- member(Hr1, [9, 11]), T1 = Hr1:Min1, T2 = Hr2:Min2, snap:valid_time(T1), snap:valid_time(T2), snap:time_delta(T1, 0:30, T2), E = entry(2025/3/19, T1, T2, "Buy Soybeans"), snap:valid_entry(E), label([Min1, Min2]), \+ snap:overlapping_entry(E, E2).

%% We can also conditionally add conditional events!!!!!

% ?- assertz(snap:entry(2025/3/D, 13:50, 17:20, "Board Games") :- rainy(2025/3/D)).
%@ true.

% ?- assertz(rainy(2025/3/18)).
%@ true.

% ?- snap:entry(2025/3/17, S, E, "Board Games").
%@ false.

% ?- snap:entry(2025/3/18, S, E, "Board Games").
%@ S = 13:50,
%@ E = 17:20.

% ?- snap:overlapping_entry(entry(_/_/_, 11:35, 12:45, _), E2).

% ?- entry(_, _, S, "b"), entry(_, E, _, "c"), make_entry(_, S, E, "D").
