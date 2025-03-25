
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

%% Connecting stuff together
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


%% Built-in tools using PCE
% ?- manpce(line).
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

example_term.
example_term("a").

%% Problem: Append-only, no prepend. Try device instead (like list_browser but uses graphicals instead of dict_items)
repl_run(CmdAtom, Log) :-
    %% Third arg is variable bindings
    atom_to_term(CmdAtom, Cmd, Bindings),
    %% term_string(Cmd, CmdStr),
    catch((Cmd,
           term_string(Bindings, BindingsStr),
           (BindingsStr == "[]"
           -> send(Log, append, "TRUE")
           ; send(Log, append, BindingsStr))),
          _,
          send(Log, append, "FAIL")).

repl :-
    new(D, dialog("REPL")),
    send(D, append, new(Align, dialog_group(aligner, group))),
    send(Align, append, new(N1, text_item('REPL'))),
    send(Align, append, new(Log, list_browser)),
    send(Log, font, font(courier, roman, 14)),
    send(D, append, button(enter, message(@prolog, repl_run, N1?selection, Log))),
    send(D, default_button, enter),
    send(D, open).

% ?- repl.

% ?- manpce(hash_table).

%% Display all built-in icons
%% Gross imperative loop required bc seemingly no way to just retrieve all hash table objs
display_img(D, Img, I, J) :-
    get(I, value, IVal),
    get(J, value, JVal),
    new(Bmp, bitmap(Img)),
    send(Bmp, resize, 20, 20),
    send(D, display, Bmp, point(IVal, JVal)),
    (IVal > 250
    -> I1 is 0, J1 is 40 + JVal
    ; I1 is 40 + IVal, J1 is JVal),
    send(I, value, I1),
    send(J, value, J1).

icons :-
    new(D, picture),
    new(StartX, number(0)),
    new(StartY, number(0)),
    send(@images, for_all, message(@prolog, display_img, D, @arg2, StartX, StartY)),
    
    get(@mark_image, size, S),
    get(S, width, W),
    writeln(W),
    
    send(D, open).

% ?- icons.

% ?- get(@mark_image, name, N).

% ?- send(@images, for_all, message(@display, inform, @arg1)).

% ?- manpce(number).

scrollbar_example :-
new(F, frame('Scrollable Dialog')),

% Scrollable window
new(W, window),
send(W, scrollbars, both),
send(F, append, W),

% Dialog with auto layout
new(D, dialog),
send(D, append, new(E1, editor)),
send(E1, size, size(1000, 500)),
send(D, append, new(_, text_item(email))),
send(D, append, new(E2, editor)),
send(E2, size, size(1000, 500)),
send(D, append, new(_, text_item(name))),
send(D, append, new(E3, editor)),
send(E3, size, size(1000, 500)),
send(D, append, new(_, button(ok))),
send(D, layout),
send(D, compute),
send(D, fit),

% Get dialog size after layout
%% get(D, area, area(_, _, Width, Height)),

% Wrap dialog in device with explicit scrollable size
%% new(Dev, device),
%% send(Dev, display, D, point(0, 0)),

% Show in scrollable window
send(W, display, D, point(0, 0)),
send(F, open).
% ?- manpce(area).
% ?- scrollbar_example.
%@ true.
