/*Q-Queen-3
  D-Drones-2
  P-Peão-1
*/

main:-
  initialize_board(Board),
  display_board(Board,8).

initialize_board(Board):-
  Board=[['Q','Q','D',' '],
         ['Q','D','P',' '],
         ['D','P','P',' '],
         [' ',' ',' ',' '],
         [' ',' ',' ',' '],
         [' ','P','P','D'],
         [' ','P','D','Q'],
         [' ','D','Q','Q']].

display_board([L|Ls],N):-N\=5,N1 is N-1,display_line(L),nl,display_board(Ls,N1).
display_board([L|Ls],N):-N1 is N-1,display_line(L),write(' '),display_horizontal(6),nl,nl,display_board(Ls,N1).
display_board([],0):-nl.

display_line([E|Es]):-write(' | '),write(E),display_line(Es).
display_line([]):-write(' | '),nl.

display_horizontal(N):-
  N>=1,
  N1 is N-1,
  write(' '),
  write('_'),
  write(' '),
  display_horizontal(N1).
display_horizontal(0).

piece_value('Q', Value):-Value is 3.
piece_value('D',Value):-Value is 2.
piece_value('P',Value):-Value is 1.
piece_value(Rest,Value):-Value is 0.

calc_value_line(Value,[E|Es]):-piece_value(E,Val),Value1 is Val+Value,calc_value_line(Value1,Es).
calc_value_line(Value,[]):-write(Value).
