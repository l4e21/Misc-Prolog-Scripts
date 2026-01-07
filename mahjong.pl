
kind(Kind, s) :- member(Kind, [sr, s]).
kind(Kind, p) :- member(Kind, [pr, p]).
kind(Kind, m) :- member(Kind, [mr, m]).
kind(w, w).
kind(d, d).

same_kind([], _).
same_kind([L|Ls], K) :-
    kind(L, K),
    same_kind(Ls, K).

has_red_five(seq(A, B, C)) :- member(5-sr, [A, B, C]).
has_red_five(seq(A, B, C)) :- member(5-pr, [A, B, C]).
has_red_five(seq(A, B, C)) :- member(5-mr, [A, B, C]).

has_red_five(triplet(A, B, C)) :- member(5-sr, [A, B, C]).
has_red_five(triplet(A, B, C)) :- member(5-pr, [A, B, C]).
has_red_five(triplet(A, B, C)) :- member(5-mr, [A, B, C]).

has_red_five(pair(A, B)) :- member(5-sr, [A, B]).
has_red_five(pair(A, B)) :- member(5-pr, [A, B]).
has_red_five(pair(A, B)) :- member(5-mr, [A, B]).

has_red_five([Shape|_Shapes]) :- has_red_five(Shape).
has_red_five([_Shape|Shapes]) :- has_red_five(Shapes).

shape_tiles(Shape, Tiles) :-
    Shape =.. [_Functor|Tiles].

hand_tiles([], []).
hand_tiles([Shape|Shapes], HandTiles) :-
    shape_tiles(Shape, Tiles),
    hand_tiles(Shapes, HandTiles1),
    append(Tiles, HandTiles1, HandTiles).

% Something one declares
yaku(_Wind, riichi, _Closed, [], _WinningTile, _WinningSeat, riichi).
    
% Closed hand and no triplets
yaku(_Wind, _Riichi, Closed, [], _WinningTile, _WinningSeat, pinfu) :-
    not(member(triplet(_, _, _), Closed)).

% Two of the same numerical sequence on the same suit
yaku(_Wind, _Riichi, Closed, [], _WinningTile, _WinningSeat, pure_double_seq) :-
    nth0(N, Closed, seq(Num1-K1, Num2-K2, Num3-K3)),
    N1 is N + 1,
    nth0(N1, Closed, seq(Num1-K4, Num2-K5, Num3-K6)),
    same_kind([K1, K2, K3, K4, K5, K6], _K).

% Triplet of dragons
yaku(_Wind, _Riichi, Closed, Open, _WinningTile, _WinningSeat, three_dragons) :-
    append(Closed, Open, Hand),
    member(triplet(D-d, D-d, D-d), Hand). 

% Triplet of winds matching seat
yaku(_Wind, _Riichi, Closed, Open, _WinningTile, WinningSeat, three_seat_wind) :-
    append(Closed, Open, Hand),
    member(triplet(WinningSeat-w, WinningSeat-w, WinningSeat-w), Hand).

% Triplet of winds matching round
yaku(Wind, _Riichi, Closed, Open, _WinningTile, _WinningSeat, three_round_wind) :-
    append(Closed, Open, Hand),
    member(triplet(Wind-w, Wind-w, Wind-w), Hand).

% Three of the same numerical sequence of differing suits
yaku(_Wind, _Riichi, Closed, Open, _WinningTile, _WinningSeat, mixed_triple_seq) :-
    append(Closed, Open, Hand),
    member(seq(Num1-K1, Num2-K2, Num3-K3), Hand),
    same_kind([K1, K2, K3], s),
    member(seq(Num1-K4, Num2-K5, Num3-K6), Hand),
    same_kind([K4, K5, K6], p),
    member(seq(Num1-K7, Num2-K8, Num3-K9), Hand),
    same_kind([K7, K8, K9], m).

% No terminals, no honours
yaku(_Wind, _Riichi, Closed, Open, _WinningTile, _WinningSeat, all_simples) :-
    append(Closed, Open, Hand),
    not((hand_tiles(Hand, Tiles), member(Tile, Tiles),
         (Tile = 1-_; Tile = 9-_; Tile = _-w; Tile = _-d))).

% sequences 1-3, 4-6, and 7-9 of same suit
yaku(_Wind, _Riichi, Closed, Open, _WinningTile, _WinningSeat, pure_straight) :-
    append(Closed, Open, Hand),
    member(seq(1-K, 2-K, 3-K), Hand),
    member(seq(4-K, 5-K2, 6-K), Hand),
    member(seq(7-K, 8-K, 9-K), Hand),
    same_kind([K, K2], K).

% Only tiles of the same suit or honours
yaku(_Wind, _Riichi, Closed, Open, _WinningTile, _WinningSeat, half_flush) :-
    append(Closed, Open, Hand),
    hand_tiles(Hand, Tiles),
    (forall(member(Tile, Tiles),
            (kind(Tile, w); kind(Tile, d); kind(Tile, s))
           );
     forall(member(Tile, Tiles),
            (kind(Tile, w); kind(Tile, d); kind(Tile, p))
           );
     forall(member(Tile, Tiles),
            (kind(Tile, w); kind(Tile, d); kind(Tile, m))
           )).
    
tenpai(Wind, Riichi, ClosedL, OpenL, Seat, Waits, Yaku) :-
    member(WinningTile, Waits),
    hand_tiles(Closed, ClosedL),
    print(Closed),
    hand_tiles(Open, OpenL),
    yaku(Wind, Riichi, Closed, Open, WinningTile, Seat, Yaku).


game(0).
date_played(0, date(2025, 12, 30)).
starting_seat(0, south).

won(round(0,
          east-1,
          0,
          [1-m]),
    winner(south,
           2000,
           tsumo,
           no_riichi,
           hand([seq(2-m, 3-m, 4-m),
                 pair(8-p, 8-p),
                 seq(5-sr, 6-s, 7-s)],
                [triplet(9-p, 9-p, 9-p),
                 triplet(g-d, g-d, g-d)]),
           5-sr)).
won(round(0,
          east-2,
          0,
          [3-s]),
    winner(south,
           3900,
           ron-north,
           no_riichi,
           hand([pair(2-p, 2-p),
                 seq(7-p, 8-p, 9-p),
                 seq(1-s, 2-s, 3-s)],
                [triplet(w-d, w-d, w-d),
                 triplet(5-m, 5-m, 5-mr)]),
           2-s)).

won(round(0,
          east-3,
          0,
          [6-s]),
    winner(east,
           11600,
           ron-west,
           no_riichi,
           hand([pair(5-m, 5-mr),
                 seq(3-p, 4-p, 5-p),
                 triplet(7-p, 7-p, 7-p),
                 seq(4-s, 5-sr, 6-s)],
                [triplet(8-m, 8-m, 8-m)]),
           7-p)).

% ?- won(round(Game, Wind-Round, Repeat, Doras), winner(WinningSeat, Points, By, Riichi, hand(Closed, Open), WinningTile)), yaku(Wind, Riichi, Closed, Open, WinningTile, WinningSeat, Yaku). 

% ?- yaku(RoundWind, IsRiichi, [pair(A, B), seq(3-s, 4-s, 5-s), seq(3-s, 4-s, C), triplet(E, E, E)], [], WinningTile, WinningSeat, Yaku).

% ?- won(A, B).
