
:- use_module(library(pce)).

%% https://eu.swi-prolog.org/packages/xpce/UserGuide/

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


%% Built-in tools using PCE
% ?- manpce.
% ?- emacs.

%% Fileviewer

fileviewer(Dir) :-
        new(DirObj, directory(Dir)),
        new(F, frame('File Viewer')),
        send(F, append(new(B, browser))),
        send(new(D, dialog), below(B)),
        send(D, append(button(view,
                              message(@prolog, view,
                                      DirObj, B?selection?key)))),
        send(D, append(button(quit,
                              message(F, destroy)))),
        send(B, members(DirObj?files)),
        send(F, open).

view(DirObj, F) :-
        send(new(V, view(F)), open),
        get(DirObj, file(F), FileObj),
        send(V, load(FileObj)).

% ?- fileviewer(".").

editing :-
    new(Dialog, dialog("Editor Test")),
    get(Dialog, display, Display),
    send(Display, layout, size(400, 400)),
    send(Dialog, append(new(_, editor))),
    send(Dialog, open).

% ?- editing.

% ?- get(dialog, class, Class), get(Class, send_methods, Methods).

% ?- get(dialog, get_method(layout), Get).

get_method(Obj, Name, Type, Summary) :-
    get(Obj, class, Class),
    (get(Class, get_methods, MethodChain), Type="get"; get(Class, send_methods, MethodChain), Type="send"),
    chain_list(MethodChain, Methods),
    member(Method, Methods),
    get(Method, name, Name),
    get(Method, summary, SummaryObj),
    get(SummaryObj, value, Summary).
    
    
% ?- new(@demo, chain), get_method(@demo, Name, Type, Summary).
% ?- new(@demo, frame), get_method(@demo, Name, Type, Summary).
% ?- new(@demo, chain), findall(Name-Type-Summary, get_method(@demo, Name, Type, Summary), Methods).

:- pce_begin_class(method_searcher, frame, "an app to search methods").

variable(stored_obj, object, both, "object").

initialise(F, Obj:object) :->
    findall(Name, get_method(Obj, Name, _, _), Names),
    send_super(F, initialise, 'Window'),
    send(F, slot, stored_obj, Obj),
    new(B, browser),
    send(F, append, B),
    send(B, members(Names)).

    
:- pce_end_class(method_searcher).

% ?- new(@demo, chain), new(W, method_searcher(chain)), send(W, open).


%% Example of keybindings
keybinder :-
    new(D, dialog("Layout Demo 1")),
    %% get(D, display, Display),
    send(D, recogniser, new(K, key_binding)),
    send(K, function, 'a', message(@prolog, ok)),
    send(D, open).

ok :- writeln("TEST").

% ?- keybinder.
% ?- manpce.

% ?- emacs.


% ?- writeln("Ok").
