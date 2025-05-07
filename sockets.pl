
:- use_module(library(socket)).

:- dynamic me/2.

%% Host:Port, Channel
:- dynamic peer/4.

start_peer(ListenPort, MyName) :-
    %% Make listener socket
    tcp_socket(ServerSocket),
    tcp_bind(ServerSocket, ListenPort),
    tcp_listen(ServerSocket, 5),
    tcp_open_socket(ServerSocket, AcceptFd, _),
    thread_create(peer_accept_loop(AcceptFd, MyName), _, [detached]),
    
    assertz(me(ListenPort, MyName)),
    format("Peer listening on port ~w~n", [ListenPort]).

peer_accept_loop(AcceptFd, MyName) :-
    %% Accept peer
    tcp_accept(AcceptFd, ClientSocket, _),
    tcp_open_socket(ClientSocket, In, Out),
    
    format(Out, "~s~n", [MyName]),
    flush_output(Out),
    read_line_to_string(In, TheirName),

    assertz(peer(MyName, TheirName, In, Out)),    
    thread_create(handle_incoming_message(MyName, In), _, [detached]),
    peer_accept_loop(AcceptFd).

handle_incoming_message(MyName, In) :-
    %% Format msg as response
    repeat,
    read_line_to_string(In, Line),
    format("~s Got: ~s~n", [MyName, Line]).

connect_to_peer(MyName, Host:Port) :-    
    %% Open outgoing connection socket
    tcp_socket(Socket),
    tcp_connect(Socket, Host:Port),
    tcp_open_socket(Socket, In, Out),

    %% Send Name
    format(Out, "~s~n", [MyName]),
    flush_output(Out),

    %% Receive Name
    read_line_to_string(In, TheirName),

    %% Associate with peer
    assertz(peer(MyName, TheirName, In, Out)),
    thread_create(handle_incoming_message(MyName, In), _, [detached]).

send_to_peer(MyName, Name, Message) :-
    peer(MyName, Name, _, Out),
    
    format("~s Sent: ~s~n", [MyName, Message]),
    
    format(Out, "~s~n", [Message]),
    flush_output(Out).

% ?- start_peer(4000, "Jam1").
% ?- start_peer(4001, "Jam2").

% ?- connect_to_peer("Jam1", 'localhost':4001).

% ?- peer(MyDetails, Details, In, Out).

% ?- send_to_peer("Jam1", "Jam2", "HI").

% ?- send_to_peer("Jam2", "Jam1", "HI").

% ?- me(Port, Name).
