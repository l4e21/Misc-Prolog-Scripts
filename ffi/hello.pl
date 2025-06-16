%% swipl-ld hello.c -shared -o hello.so
%% OR for diff project
%% gcc -I /lib/swipl/include -shared -o hello.so -fPIC hello.c
%% This will need to be used when linking multifiles and dependencies like openGL

%% swipl hello.pl
%% hello(X).
%% factorial(N, R).

:- use_foreign_library('./hello.so').
