
%% Message passing example
%% assertz_list([]).
%% assertz_list([H|T]) :-
%%     assertz(H),
%%     assertz_list(T).

%% a_new(X, Messages) :-
%%     assertz(instantiated(X)),
%%     assertz_list(Messages).

%% a_send(X, Method, Response) :-
%%     instantiated(X),
%%     call(Method, (X), Response).

%% a_new(obj, [print(obj, _) :- writeln("TEST"),
%%             get(obj, R) :- R = "TEST"]).

%% a_send(obj, get, R).
%% a_send(obj, get, "a").



layoutdemo1 :-
    new(D, dialog("Layout Demo 1")),
    send(D, append, new(BTS, dialog_group(buttons, group))),
    send(BTS, gap, size(0, 30)),
    send(BTS, append, button(add)),
    send(D, open).

% ?- layoutdemo1.

layoutdemo2(D, W, H) :-
    new(D, dialog("Layout Demo 2")),
    get(D, display, Display),
    get(Display, width, W),
    get(Display, height, H).

% ?- layoutdemo2(D, W, H), free(D).


% ?- manpce.

graph_example :-
    new(D, picture("Graph Example")),
    send(D, display, new(B1, box(200, 200)), point(20, 20)),
    send(D, display, new(B2, box(25, 25)), point(300, 300)),
    send(B1, handle, handle(w, h/2, in)),
    send(B2, handle, handle(w/2, 0, out)),
    new(L, link(in, out, line(arrows := second))),
    send(B1, connect, B2, L),
    send_list([B1, B2], recogniser, new(move_gesture)),
    send(D, open).

% ?- graph_example.
%@ true.
%@ true.
