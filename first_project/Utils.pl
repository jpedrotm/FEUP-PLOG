/* Identificar jogadores -----------------------------------------------------*/
translate_player_name(player1,'player top').
translate_player_name(player2,'player bottom').
translate_player_num(player1,0).
translate_player_num(player2,1).

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
  write('Time to play the '),write(Name),write('.'),nl,
  write('Initial X: '),
  read(Xi),
  write('Initial Y: '),
  read(Yi),
  write('Final X: '),
  read(Xf),
  write('Final Y: '),
  read(Yf).
