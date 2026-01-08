% Suppose we are reading an event log, here's a minimal event log for a reflective object kernel.
event(0, set_class(object, class)).
event(1, set_class(class, class)).
event(2, set_super(class, object)).
event(3, set_class(new, class)).
event(4, set_super(new, object)).
event(5, set_method(class, new)).
event(6, set_run(new, [Self, NewObject],
                 (
                     gensym(o, NewObject),
                     write_event(set_class(NewObject, Self)),
                     write_event(set_super(NewObject, object)),
                     apply_changes
                 )
                )).
