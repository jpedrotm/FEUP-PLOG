/* Identificar jogadores -----------------------------------------------------*/
translate_player_name(player1,'player top').
translate_player_name(player2,'player bottom').
% player_nr(player1,0).
% player_nr(player2,1).

/* Predicados para a interação do jogo com o utlizador -----------------------*/

askMenuOption(Option):-
  nl,
  write('Insert an option: '),
  !,
  read(Option).

receive_coordinates(Xi,Yi,Xf,Yf,Player):-
  nl,
  player_nr(Player,Num),
  translate_player_name(Player,Name),
  YMin is 4*Num,
  YMax is YMin+4,
  write('Time to play the '),write(Name),write('.'),nl,
  receive_coordinate(Xi,0,4,'Initial X: '),
  receive_coordinate(Yi,YMin,YMax,'Initial Y: '),
  receive_coordinate(Xf,0,4,'Final X: '),
  receive_coordinate(Yf,0,8,'Final Y: ').

cpu_coordinates(Xi,Yi,Xf,Yf,CPU):-
  nl,
  player_nr(CPU,Num),
  translate_player_name(CPU,Name),
  YMin is 4*Num,
  YMax is YMin+4,
  cpu_coordinate(Xi,0,4),
  write('| '),write(Xi),
  cpu_coordinate(Yi,YMin,YMax),
  write(Yi),
  cpu_coordinate(Xf,0,4),
  write(Xf),
  cpu_coordinate(Yf,0,8),
  write(Yf),write(' | '),nl.

cpu_coordinate(Coord,CoordMin,CoordMax):-
  Coord=_,
  random(CoordMin,CoordMax,Coord),
  Coord >=CoordMin,
  Coord<CoordMax.

cpu_coordinate(Coord,CoordMin,CoordMax):-
  nl,
  !,
  cpu_coordinate(Coord,CoordMin,CoordMax).







receive_coordinate(Coord,CoordMin,CoordMax,Line):-
  Coord=_,
  write(Line),
  read(Coord),
  Coord >=CoordMin,
  Coord<CoordMax.

receive_coordinate(Coord,CoordMin,CoordMax,Line):-
  nl,
  !,
  receive_coordinate(Coord,CoordMin,CoordMax,Line).
