%% :- protocol(radical).
%%   :- public([char/1, pinyin/1]).
%% :- end_protocol.


%% :- object(one, implements(radical)).
%% char(一).
%% pinyin("yī").
%% :- end_object.

:- object(radical).
:- public(name/1).
:- public(char/1).
:- public(pinyin/1).
:- public(new/4).

new(Radical, Name, Char, Pinyin) :-
    self(Self),
    create_object(Radical, [extends(Self)], [], [name(Name),
                                                 char(Char),
                                                 pinyin(Pinyin)]).
:- end_object.


% ?- logtalk_load(chinese).
%@ % [ /home/jam/prolog/Misc-Prolog-Scripts/chinese.lgt loaded ]
%@ % (0 warnings)
%@ true.

% ?- radical::new(ID, one, 一, "yī").
%@ ID = o1.

% ?- o1::name(X).
%@ X = one.

% ?- qsave_program("radicals", [stand_alone(true)]).
