:- module(snap, []).
:- use_module(library(pce)).

save(F) :-
    expand_file_name(F, [F1]),
    (exists_file(F1)
    -> write("Already exists. Overwrite? Y/N"),
       nl,
       (read('Y')
       -> true
       ; fail)
    ; true),
    open(F1, write, Stream),
    with_output_to(Stream,
                   (write(":- module(snap, []).\n:- use_module(library(pce)).\n"),
                    listing(snap:_))),
    close(Stream).

predicate_editor :-
    new(D, dialog("Predicate Editor")),
    send(D, open).

% ?- snap:save("~/prolog/examplesnap.pl").
%@ Already exists. Overwrite? Y/N
%@ |: Y.
%@ 
%@ true.
%@ Already exists. Overwrite? Y/N
%@ |: Y.
%@ 
%@ true.


% ?- assertz(snap:a).
%@ true.
