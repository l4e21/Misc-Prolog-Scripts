:- module(twokki, [connection/2, route/3, depth/2]).

connection(nexus, deep_red_wilds).
connection(nexus, garden_world).
connection(nexus, urotsukis_dream_apartments).
connection(nexus, heart_world).
connection(nexus, lamp_puddle_world).
connection(nexus, blue_eyes_world).
connection(nexus, rock_world).
connection(nexus, night_world).

connection(rock_world, theatre_world).
connection(theatre_world, sweet_pink_docks).
connection(sweet_pink_docks, chocolate_world).
connection(chocolate_world, stone_maze).
connection(rock_world, entomophobia_realm).
connection(rock_world, rainbow_tiles_maze).
connection(blue_eyes_world, flower_pot_outlands).
connection(blue_eyes_world, archery_cavalry_world).
connection(blue_eyes_world, restored_character_world).
connection(archery_cavalry_world, cyan_relic_world).
connection(restored_character_world, pale_brick_basement).
connection(pale_brick_basement, burgundy_flats).
connection(burgundy_flats, dream_precinct).
connection(dream_precinct, gray_road).
connection(rainbow_tiles_maze, jumbotron_hub).
connection(jumbotron_hub, floral_crossroads).
connection(floral_crossroads, metallic_plate_world).
connection(metallic_plate_world, avian_statue_world).
connection(night_world, crossing_forest).
connection(night_world, lavender_office).
connection(lamp_puddle_world, under_around).
connection(deep_red_wilds, bleeding_mushroom_garden).
connection(deep_red_wilds, mask_folks_hideout).
connection(garden_world, snowy_apartments).
connection(garden_world, blue_forest).
connection(urotsukis_dream_apartments, unending_river).
connection(school, microbiome_world).

connection(under_around, floating_park).
connection(blue_forest, school).
connection(school, urotsukis_dream_apartments).
connection(auburn_villa, wetlands_of_tranquility).
connection(mask_folks_hideout, tricolor_passage).
connection(tricolor_passage_2, cactus_desert).
connection(cactus_desert, execution_ground).
connection(execution_ground, atelier).
connection(atelier, duality_wilds).
connection(valentine_land, elvis_masadas_place).
connection(elvis_masadas_place, forlorn_beach_house).
connection(forlorn_beach_house, apartments).
connection(apartments, fairy_tale_woods).
connection(fairy_tale_woods, broken_faces_area).
connection(balloon_park, bleeding_tree_disco).
connection(bleeding_tree_disco, dreary_harbor).
connection(dreary_harbor, nightmare_express).
connection(nightmare_express, underground_subway).
connection(nightmare_express, worksite).
connection(nightmare_express, legacy_of_ruin).
connection(legacy_of_ruin, tst_map).
connection(unending_river, amorphous_maroon_space).
connection(amorphous_maroon_space, black_sphere_world).
connection(black_sphere_world, colorful_sphere_world).
connection(colorful_sphere_world, floating_window_world).
connection(floating_window_world, low_tide_sands).
connection(low_tide_sands, crystal_waters).

connection(urotsukis_dream_apartments, nexus).
connection(garden_world, nexus).
connection(deep_red_wilds, nexus).
connection(heart_world, nexus).
connection(heart_world, spherical_space_labyrinth).
connection(heart_world, tricolor_passage_1).
connection(lamp_puddle_world, nexus).

route(X, Y, Path) :-
    route(X, Y, [X], Path).

route(X, Y, _, []) :- connection(X, Y).
route(X, Y, Visited, [Z|PathRest]) :- connection(X, Z), not(member(Z, Visited)), route(Z, Y, [Z|Visited], PathRest).

shortest_route(X, Y, Path) :- findall(Path, route(X, Y, Path), Paths), map_list_to_pairs(length, Paths, KeyedPaths), keysort(KeyedPaths, [_-Path|_]).

depth(X, Depth) :- shortest_route(nexus, X, Path), length(Path, Depth).

% ?- route(X, Y, Path), not(Path == []).

% ?- route(X, Y, Path), depth(Y, Depth), Depth > 3.

% ?- route(nexus, execution_ground, P).
%@ P = [deep_red_wilds, mask_folks_hideout, tricolor_passage, cactus_desert] ;
%@ P = [heart_world, tricolor_passage, cactus_desert] 

% ?- shortest_route(nexus, low_tide_sands, P).
