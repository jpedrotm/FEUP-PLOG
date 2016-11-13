/* Menu inicial --------------------------------------------------------------*/
initial_menu:-
  display_menu,
  askMenuOption(Opt),
	(
		Opt = 1 -> player_vs_player;
		Opt = 2 -> player_vs_player;
		Opt = 3 -> player_vs_player;
    Opt = 4;
    nl,
		write('Not a valid input. Choose again.\n'),
    main
	).

player_vs_player:-
  nl,
  initialize_board(Board,Columns,Rows),
  display_total_board(Board,Rows,Columns),
  game_play(Board,Columns,Rows,0,0).


game_play(Board,Columns,Rows,PlayerTopPoints,PlayerBottomPoints):-
  receive_coordinates(Xi1,Yi1,Xf1,Yf1,player1),!,
  write(Xi1),write(Yi1),nl,
  (move(Board,Xi1,Yi1,Xf1,Yf1,NewBoard, player1, PlayerTopPoints, NewPTPoints) ->
  (display_total_board(NewBoard,Rows,Columns),
  calc_divisions_points(NewBoard,Rows,BottomPoints1,TopPoints1),
  verify_end_game(TopPoints1,BottomPoints1,NewPTPoints,PlayerBottomPoints),
  display_points_division(NewPTPoints,PlayerBottomPoints),
  receive_coordinates(Xi2,Yi2,Xf2,Yf2,player2),
  move(NewBoard,Xi2,Yi2,Xf2,Yf2,NewBoard1, player2, PlayerBottomPoints, NewPBPoints),
  display_total_board(NewBoard1,Rows,Columns),
  calc_divisions_points(NewBoard1,Rows,BottomPoints2,TopPoints2),
  verify_end_game(TopPoints2,BottomPoints2,PlayerTopPoints,PlayerBottomPoints),
  display_points_division(NewPTPoints,NewPBPoints),
  game_play(NewBoard1,Columns,Rows,NewPTPoints,NewPBPoints));
  display_total_board(Board,Rows,Columns),
  game_play(Board,Columns,Rows,PlayerTopPoints,PlayerBottomPoints)).

/* Menu fim de jogo ----------------------------------------------------------*/
end_menu(PlayerTopPoints,PlayerBottomPoints):-
  PlayerTopPoints>PlayerBottomPoints,
  nl,nl,
  write('---------------------------------\n'),
	write('----------- Game Over -----------\n'),
	write('---------------------------------\n'),
  write('Player top won the game ! -------\n'),
	nl.

  end_menu(PlayerTopPoints,PlayerBottomPoints):-
    nl,nl,
    write('----------------------------------\n'),
  	write('----------- Game Over ------------\n'),
  	write('----------------------------------\n'),
    write('---Player bottom won the game ! --\n'),
  	nl.
