:- module(narwhal, [start_node/1, join/1, broadcast_batch_digest/2, certificate/2]).

:- use_module(library(socket)).
:- use_module(library(aggregate)).
:- use_module(library(apply)).

:- dynamic vertex/3.        % vertex(Round, Sender, Batches)
:- dynamic received_vote/3. % received_vote(Round, Sender, Voter)
:- dynamic round_quorum/2.  % round_quorum(Round, Quorum)
:- dynamic self/1.          % self(Port)
:- dynamic peer/1.          % peer(Port)

% --- DAG ---

%! add_vertex(+Round:integer, +Sender:integer, +Batches:list) is det
add_vertex(Round, Sender, Batches) :-
    assertz(vertex(Round, Sender, Batches)).

%! has_vertex(+Round:integer, +Sender:integer) is semidet
has_vertex(Round, Sender) :-
    vertex(Round, Sender, _).

%! peers(-Peers:list) is det
peers(Peers) :-
    findall(P, peer(P), Peers).

% --- Network ---

%! start_node(+Port:integer) is det
%  Bind to Port and start accepting connections.
start_node(Port) :-
    assertz(self(Port)),
    tcp_socket(Socket),
    tcp_bind(Socket, Port),
    tcp_listen(Socket, 5),
    thread_create(accept_loop(Socket), _, [detached(true)]).

%! join(+Port:integer) is det
%  Send hello to Port; register the reply as a peer.
join(Port) :-
    self(Self),
    catch(
        ( send_message(Port, hello(Self), hello(Peer)),
          assertz(peer(Peer)) ),
        _,
        true ).

accept_loop(ServerSocket) :-
    tcp_accept(ServerSocket, ClientSocket, _Peer),
    thread_create(handle_connection(ClientSocket), _, [detached(true)]),
    accept_loop(ServerSocket).

handle_connection(Socket) :-
    tcp_open_socket(Socket, In, Out),
    catch(
        ( read(In, Message),
          close(In),
          call(Message, Out) ),
        _Error,
        true
    ),
    close(Out).

% --- Broadcast ---

%! broadcast_batch_digest(+Round:integer, +Batches:list) is det
%  Snapshot peers, compute quorum (2f+1), assert self-vote, broadcast
%  concurrently, then block until certificate(Round, Self) holds.
broadcast_batch_digest(Round, Batches) :-
    self(Self),
    peers(Peers),
    length(Peers, N),
    Total is N + 1,
    Q is 2 * ((Total - 1) // 3) + 1,
    assertz(round_quorum(Round, Q)),
    add_vertex(Round, Self, Batches),
    assertz(received_vote(Round, Self, Self)),
    concurrent_maplist([Peer]>>send_batch_digest(Peer, Round, Batches), Peers),
    wait_for_certificate(Round, Self).

wait_for_certificate(Round, Sender) :-
    ( certificate(Round, Sender) -> true
    ; sleep(0.01), wait_for_certificate(Round, Sender) ).

%! send_batch_digest(+Port:integer, +Round:integer, +Batches:list) is det
send_batch_digest(Port, Round, Batches) :-
    self(Self),
    send_message(Port, batch_digest(Round, Self, Batches), vote(Round, Voter)),
    ( \+ received_vote(Round, Self, Voter) ->
        assertz(received_vote(Round, Self, Voter))
    ; true ).

%! send_message(+Port:integer, +Message:term, -Reply:term) is det
send_message(Port, Message, Reply) :-
    tcp_connect(localhost:Port, Stream, []),
    write_term(Stream, Message, [quoted(true)]),
    write(Stream, '.'), nl(Stream), flush_output(Stream),
    read(Stream, Reply),
    close(Stream).

% --- Message Handling ---

%! hello(+Sender:integer, +Out:stream) is det
hello(Sender, Out) :-
    ( \+ peer(Sender) -> assertz(peer(Sender)) ; true ),
    self(Self),
    write_term(Out, hello(Self), [quoted(true)]),
    write(Out, '.'), nl(Out), flush_output(Out).

%! batch_digest(+Round:integer, +Sender:integer, +Batches:list, +Out:stream) is det
batch_digest(Round, Sender, Batches, Out) :-
    ( \+ has_vertex(Round, Sender) -> add_vertex(Round, Sender, Batches) ; true ),
    self(Self),
    write_term(Out, vote(Round, Self), [quoted(true)]),
    write(Out, '.'), nl(Out), flush_output(Out).

%! certificate(+Round:integer, +Sender:integer) is semidet
%  True when received votes for (Round, Sender) meet the quorum for that round.
certificate(Round, Sender) :-
    round_quorum(Round, Q),
    aggregate_all(count, received_vote(Round, Sender, _), Count),
    Count >= Q.
