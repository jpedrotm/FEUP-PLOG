:-include('Logic.pl').
:-include('Interface.pl').

main:-
  write('-------------------------------------------------\n'),
  write('----------------- MARTIAN CHESS -----------------\n'),
  write('-------------------------------------------------\n'),
  write('------------- 1 - Player vs Player. -------------\n'),
  write('--------------- 2 - Player vs cpu. --------------\n'),
  write('--------------- 3 - cpu vs cpu. -----------------\n'),
  write('------------------ 4 - Exit.  -------------------\n'),
  write('-------------------------------------------------\n'),
  !,
  nl,
  write('Insert an option: '),
  read(Opt),
	(
		Opt = 1 -> player_vs_player;
		Opt = 2 -> player_vs_player;
		Opt = 3 -> player_vs_player;
    Opt = 4;
    nl,
		write(Opt), nl,
		write('Not a valid input. Choose again.\n'),
    main
	).


player_vs_player:-
  nl,
  initialize_board(Matrix,Columns,Rows),
  display_cols(0,Columns),
  display_board(Matrix,Rows,Columns,0),
  calc_players_points(Matrix,Rows,PlayerPoints1,PlayerPoints2),
  write('Player 1: '),
  write(PlayerPoints1),
  nl,
  write('Player 2: '),
  write(PlayerPoints2),
  nl,
  move(Matrix,2,2,2,3).
