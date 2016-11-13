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

make_play(Board,NewBoard,Columns,Rows,ActivePlayerPoints,NewPoints,Player):-
  receive_coordinates(Xi1,Yi1,Xf1,Yf1,Player),!,
  (move(Board,Xi1,Yi1,Xf1,Yf1,NewBoard, Player, ActivePlayerPoints, NewPoints) ->
  (display_total_board(NewBoard,Rows,Columns));
  display_total_board(Board,Rows,Columns),
  make_play(Board,Columns,Rows,ActivePlayerPoints,NewPoints, Player)).


game_play(Board,NewBoard,Columns,Rows,PlayerTopPoints,PlayerBottomPoints):-
    make_play(Board,NewBoard,Columns,Rows,PlayerTopPoints,NewTopPoints,player1),
    calc_divisions_points(NewBoard,Rows,BottomPoints1,TopPoints1),
    verify_end_game(TopPoints1,BottomPoints1,NewTopPoints,PlayerBottomPoints),
    display_points_division(NewTopPoints,PlayerBottomPoints),
    make_play(NewBoard,NewBoard1,Columns,Rows,PlayerBottomPoints,NewBottomPoints,player2),
    calc_divisions_points(NewBoard,Rows,BottomPoints2,TopPoints2),
    verify_end_game(TopPoints2,BottomPoints2,NewBottomPoints,PlayerTopPoints),
    display_points_division(NewTopPoints,NewBottomPoints),
    game_play(NewBoard1,NewBoard2,Columns,Rows,NewTopPoints,NewBottomPoints).

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
