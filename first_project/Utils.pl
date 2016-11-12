/* Identificar jogadores -----------------------------------------------------*/
translate_player_name(player1,'player top').
translate_player_name(player2,'player bottom').
player_nr(player1,0).
player_nr(player2,1).

/* Predicados para a interação do jogo com o utlizador -----------------------*/

askMenuOption(Option):-
  nl,
  write('Insert an option: '),
  !,
  read(Option).

askPlayerCoordinates(Xi,Yi,Xf,Yf,Player):-
  nl,
  translate_player_num(Player,Num),
  translate_player_name(Player,Name),
  YMin is 4*Num,
  YMax is YMin+4,
  write('Time to play the '),write(Name),write('.'),nl,
  write('Initial X: '),
  receive_coordinate(Xi,0,4),
  write('Initial Y: '),
  receive_coordinate(Yi,YMin,YMax),
  write('Final X: '),
  receive_coordinate(Xf,0,4),
  write('Final Y: '),
  receive_coordinate(Yf,0,8).

receive_coordinate(Coord,CoordMin,CoordMax):-
  Coord=_,
  read(Coord),
  Coord >=CoordMin,
  Coord<CoordMax.

receive_coordinate(Coord,CoordMin,CoordMax):-
  nl,
  !,
  receive_coordinate(Coord,CoordMin,CoordMax).
