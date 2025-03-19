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


time_delta(Hr1:Min1, Hr2:Min2, DeltaHr:DeltaMin) :-
    valid_time(Hr1:Min1),
    valid_time(Hr2:Min2),
    valid_time(DeltaHr:DeltaMin),
    
    Minutes #= Min1 + DeltaMin,
    Minutes #>= 60 #<==> Carryover,
    Hr2 #= Hr1 + DeltaHr + Carryover,
    Min2 #= Minutes - 60*Carryover.
    

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

make_entry(Entry, PreConditions, PostConditions) :-
    PreConditions,
    valid_entry(Entry),
    assertz(Entry :- PostConditions).

% ?- snap:save("~/prolog/examplesnap.pl").

% ?- use_module(library(clpfd)).

% ?- snap:make_entry(entry(2025/3/19, 10:0, 11:40, "See Doctor"), true, true).

% ?- snap:entry(Date, T1, T2, Info).

% ?- assertz(snap:a).



%% We have to be very specific about the point at which we're instantiating the clpfd vars

% ?- member(Hr1, [9, 11]), T1 = Hr1:Min1, T2 = Hr2:Min2, snap:valid_time(T1), snap:valid_time(T2), snap:time_delta(T1, 0:30, T2), E = entry(2025/3/19, T1, T2, "Buy Soybeans"), snap:valid_entry(E), label([Min1, Min2]), \+ snap:overlapping_entry(E, E2).

%% We can also conditionally add conditional events!

% ?- assertz(snap:entry(2025/3/D, 13:50, 17:20, "Board Games") :- rainy(2025/3/D)).

% ?- assertz(snap:rainy(2025/3/18)).

% ?- snap:entry(2025/3/17, S, E, "Board Games").

% ?- snap:entry(2025/3/18, S, E, "Board Games").

% ?- snap:overlapping_entry(entry(_/_/_, 11:35, 12:45, _), E2).

% ?- entry(_, _, S, "b"), entry(_, E, _, "c"), make_entry(_, S, E, "D").

%% Culminating in a beautiful general abstraction

% ?- snap:make_entry(entry(2025/3/D, T1, 17:20, "Board Games"), (valid_time(T1), T1 = H1:M1, label([H1, M1])), rainy(2025/3/D)).


%% Soft constraints example

% ?- valid_time(Hr1:Min1), P1 in 0..1, P2 in 0..2, E = entry(2025/3/19, Hr1:Min1, 23:59, "Blah"), Hr1 in 7..15 #\/ P1 #= 1, Min1 in 0..10 #\/ P2 #= P1 + 1, P2 #< 2, label([Hr1, Min1]).


%% Ideas for a GUI
%% - Calendar Page
%% - Daily Page
%% - Make an entry page
%% - Specifics 
