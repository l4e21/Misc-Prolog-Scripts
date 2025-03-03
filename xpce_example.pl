
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
%@ D = @(11851468117472),
%@ W = 1920,
%@ H = 1080.

