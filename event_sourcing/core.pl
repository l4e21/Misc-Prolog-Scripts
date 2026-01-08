:- use_module(library(clpfd)).

:- dynamic event/2.
:- dynamic pending/2.

:- nb_setval(system_time, 0).
:- nb_setval(snapshot_time, 0).
    
max_event_time(MaxT) :-
    (   aggregate_all(max(T), event(T,_), MaxT0)
    ->  MaxT = MaxT0
    ;   MaxT = -1
    ).

reset_clock_from_log :-
    max_event_time(MaxT),
    nb_setval(system_time, MaxT),
    nb_setval(snapshot_time, MaxT).

%% CLONE
% To load an image, find the max event time, set the system time and snapshot time, after consulting all the events.
load_image(File) :-
    retractall(event/2),
    consult(File),
    reset_clock_from_log.

%% PUSH
% Saving an image means printing the event log to a file, that's all.
save_image(File) :-
    setup_call_cleanup(
        open(File, write, S, [encoding(utf8)]),
        with_output_to(S, listing(event/2)),
        close(S)
    ).

% To hydrate the object events
hydrate_event(set_class, ID, [IDClass]) :-
    assertz(class(ID, IDClass)).

hydrate_event(set_super, ID, [IDSuper]) :-
    assertz(super(ID, IDSuper)).

hydrate_event(set_method, IDClass, [IDMethod]) :-
    assertz(defined_on(IDMethod, IDClass)).

hydrate_event(set_run, ID, [MethodArgs, MethodBody]) :-
    assertz(run(ID, MethodArgs) :- MethodBody).

% Hydrating the image
hydrate_image :-
    forall(event(_T, Event),
           (
               Event =.. [Event_Name, ID|Args],
               hydrate_event(Event_Name, ID, Args)
           )
          ).

% When writing, we inc system time (like a lamport clock)
inc_system_time :-
    nb_getval(system_time, T),
    T1 is T + 1,
    nb_setval(system_time, T1).

write_event(Event) :-
    inc_system_time,
    nb_getval(system_time, T),
    assertz(pending(T, Event)).

% To apply pending changes to the system, we take the changes that were made and now the new snapshot is at current system time. I think this may have issues, it's not well-thought-out.
apply_changes :-
    !,
    nb_getval(snapshot_time, SnapT),
    forall((pending(T, Event), T #> SnapT),
           (
               Event =.. [Event_Name, ID|Args],
               hydrate_event(Event_Name, ID, Args)
           )
          ),
    nb_getval(system_time, SysT),
    nb_setval(snapshot_time, SysT).

%% COMMIT
% To 'save' add the pending events to the proper event log. A more git-like structure would be immensely beneficial.
save :-    
    nb_getval(system_time, SysT),
    nb_getval(snapshot_time, SysT),
    forall(pending(T, Event), assertz(event(T, Event))),
    retractall(pending/2).

%% Find the class of the object
send_message(Method) :- send_message(#{}, Method).
send_message(Opts, Method) :-
    Method =.. [Name, Self|Args],

    % Debug Only
    print(Method), nl,
    
    (class(Self, ObjectClass); ObjectClass = number),

    (find_method(ObjectClass, Name, MethodID),
     run(MethodID, Opts, [Self|Args])
    ;
    not(find_method(ObjectClass, Name, _MethodID)),
    send_message(does_not_understand(Self, Method))
    ).

%% Follow inheritance chain up until method is found
%% Note bc PROLOG we have backtracking on this. We could do diff kinds of sends.
find_method(ObjectClass, Name, MethodID) :-
    defined_on(MethodID, ObjectClass),
    name(MethodID, Name).
    
find_method(ObjectClass, Name, MethodID) :-
    super(ObjectClass, SuperClass),
    find_method(SuperClass, Name, MethodID).

% ?- load_image("image.pl").

% ?- nb_getval(system_time, N), nb_getval(snapshot_time, N1).

% ?- event(T, E).

% ?- hydrate_image.

% ?- class(ID1, ID2).

% ?- run(new, [class, O]).

% ?- pending(T, E).

% ?- save.

% ?- event(T, E).

% ?- class(o1, C).

% ?- save_image("image2.pl").
