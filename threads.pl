
%% Erlang style genserver

:- dynamic server/2.

start_server(Name, InitialState) :-
    message_queue_create(Queue),
    assertz(server(Name, Queue)),
    thread_create(server_loop(Name, Queue, InitialState), _, [detached]).

server_loop(Name, Queue, State0) :-
    thread_get_message(Queue, Msg),
    handle_message(Msg, Name, State0, State1),
    server_loop(Name, Queue, State1).

handle_message(inc, _Name, N0, N1) :-
    N1 is N0 + 1.

handle_message(print, _Name, N0, N0) :-
    print(N0).

% ?- start_server("Jam", 0).

% ?- server("Jam", Queue), thread_send_message(Queue, inc).

% ?- server("Jam", Queue), thread_send_message(Queue, print).
