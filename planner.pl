
:- use_module(library(clpfd)).

now(Yr/Month/Day, Hr:Min) :-
    get_time(Stamp),
    stamp_date_time(Stamp, DateTime, local),
    date_time_value(year, DateTime, Yr),
    date_time_value(month, DateTime, Month),
    date_time_value(day, DateTime, Day),
    date_time_value(hour, DateTime, Hr),
    date_time_value(minute, DateTime, Min).

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

tasks(2024/_/_, []).

tasks(Y/M/D, Tasks) :-
    Y #> 2024,
    %% Manually added tasks
    findall(Task, added_task(Y/M/D, Task), AddedTasks),

    %% Plus carry over tasks from yesterday
    tomorrow(YesterYear/YesterMonth/YesterDay, Y/M/D),
    unfinished_tasks(YesterYear/YesterMonth/YesterDay, CarryoverTasks),
    append(CarryoverTasks, AddedTasks, Tasks).

unfinished_tasks(Y/M/D, Tasks) :-
    tasks(Y/M/D, AllTasks),
    exclude(done_task(Y/M/D), AllTasks, Tasks).

finish_task(Y/M/D, Task) :-
    tasks(Y/M/D, Tasks),
    member(Task, Tasks),
    assertz(done_task(Y/M/D, Task)).

% ?- tasks(2024/12/31, []).

% ?- tasks(2025/1/1, Tasks).

% ?- unfinished_tasks(2025/1/1, Tasks).

% ?- assertz(added_task(2025/1/1, 'Walk doggy')).

% ?- finish_task(2025/1/1, 'Walk doggy').
