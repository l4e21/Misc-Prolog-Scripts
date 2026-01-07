:- use_module(library(clpfd)).


:- dynamic(class/2).
:- dynamic(super/2).
:- dynamic(defined_on/2).
:- dynamic(name/2).
:- dynamic(run/3).

:- discontiguous(super/2).
:- discontiguous(class/2).
:- discontiguous(defined_on/2).
:- discontiguous(name/2).
:- discontiguous(run/3).


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

%% The Object object
class(object, class).
name(object, object).

%% is_class method
class(object_is_class, class).
super(object_is_class, object).
name(object_is_class, is_class).
defined_on(object_is_class, object).
run(object_is_class, _Opts, [_Self]) :- fail.

% does_not_understand method
class(does_not_understand, class).
super(does_not_understand, object).
name(does_not_understand, does_not_understand).
defined_on(does_not_understand, object).
run(does_not_understand, _Opts, [Self, Method]) :-
    name(Self, Name),
    format("object ~w does not understand message `~w`", [Name, Method]),
    nl,
    fail.

% initialise method
class(initialise, class).
super(initialise, object).
name(initialise, initialise).
defined_on(initialise, object).
run(initialise, _MethodOpts, [Self, InstanceVars]) :-
    add_instance_vars(Self, InstanceVars).
    
add_instance_vars(_, []).
add_instance_vars(Obj, [(Key, Value)|Vars]) :-
    assertz(instance_var(Obj, Key, Value)),
    add_instance_vars(Obj, Vars).

%% The Class object
class(class, class).
super(class, object).
name(class, class).

% is_class method
class(class_is_class, class).
super(class_is_class, object).
name(class_is_class, is_class).
defined_on(class_is_class, class).
run(class_is_class, _Opts, [_Self]) :- true.

% allocate method
class(allocate, class).
super(allocate, object).
name(allocate, allocate).
defined_on(allocate, class).
run(allocate, MethodOpts, [Self, NewObject]) :-
    (ground(NewObject); gensym(o, NewObject)),
    assertz(class(NewObject, Self)),
    (get_dict(super, MethodOpts, Super); Super = object),
    assertz(super(NewObject, Super)).
    
% new method
class(new, class).
super(new, object).
name(new, new).
defined_on(new, class).
run(new, MethodOpts, [Self, NewObject]) :-
    send_message(MethodOpts, allocate(Self, NewObject)),
    (get_dict(instance_vars, MethodOpts, InstanceVars); InstanceVars = []),
    send_message(initialise(NewObject, InstanceVars)).

% define method
class(define, class).
super(define, object).
name(define, define).
defined_on(define, class).
run(define, _MethodOpts, [Self, Opts, Head, Body]) :-
    Head =.. [Name | Args],
    send_message(new(Self, NewMethod)),
    assertz(defined_on(NewMethod, Self)),
    assertz(name(NewMethod, Name)),
    assertz(run(NewMethod, Opts, Args) :- Body).    

:- send_message(new(class, number)).
:- send_message(new(number, 0)).

:- send_message(define(number, _, factorial(0, 1), true)).
:- send_message(define(number, _, factorial(Self, X), (Self #> 0, Self1 is Self - 1, send_message(Self1, factorial(Self1, X1)), X is X1 * Self))).

% ?- send_message(factorial(5, X)).


% o1 := (Class new) class.
% ?- send_message(new(class, NewClass)), !, class(NewClass, C).

% Inspecting o1 for methods.
% ?- clause(class(o1, C), B).

% o2 := o1 new.
% o2 class.
% ?- send_message(new(o1, O2)), !, class(O2, O2Class).

% Prove that `o2 new.` is impossible 
% ?- not(send_message(new(o2, O))).

% Let's look at all the class relations in the system
% ?- class(O, C).

% ?- super(O, S).

% What is a class- what isn't?
% ?- send_message(is_class(X)).

% Save Image
% ?- qsave_program(objvlisp, [stand_alone(true)]).


% Method definition example

% ?- send_message(new(class, NewClass)), send_message(define(NewClass, _Opts, val(Self, X), member(X, [1, 2, 3]))), !, send_message(new(NewClass, NewObject)), !.

% ?- send_message(val(o3, X)).

% ?- send_message(blah(o2, X)).

% Ground means we can make new classes with names
% ?- send_message(new(class, class_2)), !.

% ?- class(class_2, C).

% ?- send_message(does_not_understand(O, _)).

% Let's try instance vars

% ?- send_message(#{instance_vars: [(x, 1), (y, 2)], name: example}, new(class, O)), !.

% ?- instance_var(A,  B, C).

% ?- send_message()


