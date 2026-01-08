event(0, set_class(object, class)).
event(1, set_class(class, class)).
event(2, set_super(class, object)).
event(3, set_class(new, class)).
event(4, set_super(new, object)).
event(5, set_method(class, new)).
event(6, set_run(new, [A, B], (gensym(o, B), write_event(set_class(B, A)), write_event(set_super(B, object)), apply_changes))).
event(7, set_class(o1, class)).
event(8, set_super(o1, object)).
