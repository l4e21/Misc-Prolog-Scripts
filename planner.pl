:- module(planner, [now/1,
                    valid_date/1,
                    tomorrow/2,
                    before/2,
                    date_between/3,
                    done_task/2,
                    added_task/2,
                    add_task/2,
                    subtask/2]).

:- use_module(library(clpfd)).

now(Yr/Month/Day) :-
    get_time(Stamp),
    stamp_date_time(Stamp, DateTime, local),
    date_time_value(year, DateTime, Yr),
    date_time_value(month, DateTime, Month),
    date_time_value(day, DateTime, Day).

% ?- now(D).

month_name(1, "January").
month_name(2, "February").
month_name(3, "March").
month_name(4, "April").
month_name(5, "May").
month_name(6, "June").
month_name(7, "July").
month_name(8, "August").
month_name(9, "September").
month_name(10, "October").
month_name(11, "November").
month_name(12, "December").

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

valid_date(Yr/Month/Day) :-
    Yr #> 2020,
    Month in 1..12,
    days_in_month(Month, DaysInMonth),    
    Day in 1..DaysInMonth.

% ?- valid_date(2025/2/22).
    
tomorrow(Year1/Month1/Day1, Year2/Month2/Day2) :-
    days_in_month(Month1, DaysInMonth),
    days_in_month(Month2, DaysInMonth2),
    Day1 in 1..DaysInMonth,
    Day2 in 1..DaysInMonth2,
    Month1 in 1..12,
    Month2 in 1..12,
    
    Day1 #= DaysInMonth #<==> Carryover,

    Month1 + Carryover #= 13 #<==> Carryover2,

    Month1 + Day1 #= 43 #<==> Carryover3,

    Day2 #= Day1 mod DaysInMonth + 1,
    Month2 #= (Month1 + Carryover) mod 13 + Carryover2, 
    
    Year2 #= Year1 + Carryover3.

% ?- now(X), tomorrow(X, T).

% ?- tomorrow(2025/11/30, T).

% ?- tomorrow(2025/12/30, T).

% ?- tomorrow(2025/12/31, T).

% ?- tomorrow(Y/M/D, 2026/1/1).


before(Yr1/_/_, Yr2/_/_) :-
    Yr1 #< Yr2.

before(Yr1/Month1/_, Yr2/Month2/_) :-
    Yr1 #= Yr2,
    Month1 #< Month2.

before(Yr1/Month1/Day1, Yr2/Month2/Day2) :-
    Yr1 #= Yr2,
    Month1 #= Month2,
    Day1 #< Day2.

date_between(Date, Date2, Date) :-
    not(Date = Date2),
    valid_date(Date).

date_between(Date1, Date, Date) :-
    not(Date = Date1),
    valid_date(Date).

date_between(Date, Date, Date) :-
    valid_date(Date).

date_between(Date1, Date2, Date) :-
    valid_date(Date),
    before(Date, Date2),
    before(Date1, Date).


% ?- date_between(2025/12/31, 2026/1/2, Y/M/D).

% ?- tomorrow(2025/12/30, Y/M/D).

% ?- tomorrow(Y/M/D, 2026/1/1).

:- dynamic added_task/2.
:- dynamic done_task/2.
:- dynamic subtask/2.

add_task(Start, Desc) :-
    valid_date(Start),
    assertz(added_task(Start-Start, Desc)).

add_task(Start-Deadline, Desc) :-
    valid_date(Start),
    valid_date(Deadline),
    before(Start, Deadline),
    assertz(added_task(Start-Deadline, Desc)).

% ?- valid_date(2025/12/31).
% ?- add_task(2025/12/31, 'Walk Dogs').

% ?- add_task(2025/12/31-2026/1/1, 'Walk Dogs').

% ?- add_task(2026/1/3-2026/1/4, 'Walk Dogs').


active_task(Date, Desc, Start-Deadline) :-
    added_task(Start-Deadline, Desc),
    date_between(Start, Deadline, Date).

% ?- active_task(D, S, Y).

unfinished_task(Date, Desc, Start-Deadline) :-
    active_task(Date, Desc, Start-Deadline),
    \+ (done_task(DateFinished, Desc), date_between(Start, Deadline, DateFinished)).

% ?- unfinished_task(D, S, Y).

finish_task(Date, Desc) :-
    unfinished_task(Date, Desc, _-_),
    assertz(done_task(Date, Desc)).

% ?- finish_task(2025/12/31, 'Walk Dogs').

% ?- qsave_program("planner").
