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
  calc_divisions_points(Board,Rows,BottomPoints,TopPoints),
  display_points_division(TopPoints,BottomPoints),
  verify_end_game(TopPoints,BottomPoints,PlayerTopPoints,PlayerBottomPoints,Continue),
  !,
  Continue=1,
  askPlayerCoordinates(Xi1,Yi1,Xf1,Yf1,player1),
  move(Board,Xi1,Yi1,Xf1,Yf1,NewBoard),
  display_total_board(NewBoard,Rows,Columns),
  askPlayerCoordinates(Xi2,Yi2,Xf2,Yf2,player2),
  move(NewBoard,Xi2,Yi2,Xf2,Yf2,NewBoard1),
  display_total_board(NewBoard1,Rows,Columns),
  game_play(NewBoard1,Columns,Rows,PlayerTopPoints,PlayerBottomPoints).

/* Menu fim de jogo ----------------------------------------------------------*/
end_menu(PlayerTopPoints,PlayerBottomPoints):-
  nl,nl,
  write('---------------------------\n'),
	write('-------- Game Over --------\n'),
	write('---------------------------\n'),
	nl.
