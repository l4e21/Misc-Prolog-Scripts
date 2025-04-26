:- module(planner, [now/1, finish_task/2, unfinished_task/2, task/2, done_task/2, added_task/2]).

:- use_module(library(clpfd)).

now(Yr/Month/Day) :-
    get_time(Stamp),
    stamp_date_time(Stamp, DateTime, local),
    date_time_value(year, DateTime, Yr),
    date_time_value(month, DateTime, Month),
    date_time_value(day, DateTime, Day).

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

tomorrow(Year1/Month1/Day1, Year2/Month2/Day2) :-
    days_in_month(Month1, DaysInMonth),
    days_in_month(Month2, DaysInMonth2),
    Day1 in 1..DaysInMonth,
    Day1 in 1..DaysInMonth2,
    Month1 in 1..12,
    Month2 in 1..12,
    
    Day1 #= DaysInMonth #<==> Carryover,
    Month1 #= 12 #<==> Carryover2,

    Day2 #= Day1 mod DaysInMonth + 1,
    Month2 #= Month1 mod 12 + Carryover,
    Year2 #= Year1 + Carryover2.

% ?- tomorrow(2025/12/31, Y/M/D).
% ?- tomorrow(Y/M/D, 2026/1/1).

:- dynamic added_task/2.
:- dynamic done_task/2.

task(Y/M/D, Task) :-
    Y #> 2024,
    added_task(Y/M/D, Task).

task(Y/M/D, Task) :-
    Y #> 2024,
    \+ added_task(Y/M/D, Task),
    tomorrow(YesterYear/YesterMonth/YesterDay, Y/M/D),
    task(YesterYear/YesterMonth/YesterDay, Task),
    \+ done_task(YesterYear/YesterMonth/YesterDay, Task).

unfinished_task(Y/M/D, Task) :-
    task(Y/M/D, Task),
    \+ done_task(Y/M/D, Task).

finish_task(Y/M/D, Task) :-
    unfinished_task(Y/M/D, Task),
    assertz(done_task(Y/M/D, Task)).

% ?- use_module(library(clpfd)).

% ?- task(2024/12/31, T).

% ?- task(2025/4/26, Task).

% ?- unfinished_task(2025/4/26, Task).

% ?- assertz(added_task(2025/4/26, 'Walk doggy')).

% ?- finish_task(2025/4/26, 'Walk doggy').

% ?- task(2025/M/D, T).

% ?- qsave_program("planner").

% ?- between(24, 31, D), assertz(planner:added_task(2025/4/D, 'Walk Doggy')).

% ?- assertz(planner:added_task(2025/4/D, 'Walk Doggy')).

% ?- planner:added_task(2025/4/26, Task).

% ?- planner:unfinished_task(2025/4/D, Task).
% ?- planner:unfinished_task(2025/4/26, Task).
% ?- planner:unfinished_task(2025/3/22, Task).

% ?- assertz(planner:added_task(2025/4/D, 'Walk Doggy') :- between(24, 31, D)).
