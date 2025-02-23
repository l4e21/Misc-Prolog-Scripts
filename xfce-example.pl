:- module(xpce_example, []).

layoutdemo1 :-
    new(D, dialog("Layout Demo 1")),
    send(D, append, new(BTS, dialog_group(buttons, group))),
    send(BTS, gap, size(0, 30)),
    send(BTS, append, button(add)),
    send(D, open).

%% ask_name(Name) :-
%%     new(D, dialog('Prompting for Name')),
%%     send(D, 

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
