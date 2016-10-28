

main:-
  %Rows = 8, Columns = 4,
  %generate_board(Matrix,Rows,Columns),
  initialize_board(Matrix,Columns,Rows),
  %display_cols(0,Columns),
  %display_board(Matrix,Rows,Columns,0),
  calc_players_points(Matrix,Rows,0,0,0).

  /*Retorno de simbolo de cada tipo de peça--------------------------------------------------------------------------------------------------------------------------------------------*/

  piece_simbol('Queen',Simbol):-
    Simbol is 'A'.
  piece_simbol('Drone',Simbol):-
    Simbol is 'a'.
  piece_simbol('Pawn',Simbol):-
    Simbol is '.'.

  /*Função para inicializar um tabuleiro de forma estática-----------------------------------------------------------------------------------------------------------------------------*/

  initialize_board(Board,Columns,Rows):-
    Columns is 4,
    Rows is 8,
    Board=[['A','A','a',' '],
           ['A','a','+',' '],
           ['a','+','+',' '],
           [' ',' ',' ',' '],
           [' ',' ',' ',' '],
           [' ','+','+','a'],
           [' ','+','a','A'],
           [' ','a','A','A']].

/*Funções responsáveis por gerar o tabuleiro vazio de forma dinámica-------------------------------------------------------------------------------------------------------------------*/

generate_line([],0).
generate_line([E|Es],N):-
    N > 0,
    N1 is N - 1,
    E=' ',
    generate_line(Es, N1).

generate_board([],0,_).
generate_board([L|Ls],N,M):-
  generate_line(L,M),
  N1 is N - 1,
  generate_board(Ls, N1, M).

get_dimensions(Columns,Rows):-
  write('Indique o numero de colunas: \n'),
  read(Columns),
  write('Indique o numero de linhas: \n'),
  read(Rows).


/*Funções responsáveis por fazer display do tabuleiro----------------------------------------------------------------------------------------------------------------------------------*/
display_board([L|Ls],Rows,Columns,I):-
  TempRows is round(Rows/2),
  I=TempRows,
  I1 is I+1,
  write('  '),
  display_boundary(Columns),
  nl,
  display_line_elems(L,I),
  nl,
  display_board(Ls,Rows,Columns,I1).

display_board([L|Ls],Rows,Columns,I):-
  NumberCols is Columns*5,
  I1 is I+1,
  display_horizontal(NumberCols),
  display_line_elems(L,I),
  nl,
  display_board(Ls,Rows,Columns,I1).
display_board([],Rows,Columns,I):-
  NumberCols is Columns*5,
  display_horizontal(NumberCols).

/*Função responsável por dar display dos elementos das listas*/
display_line_elems([E|Es],I):-
  write('   '),
  write(I),
  write(''),
  display_elems([E|Es]).

display_elems([E|Es]):-
  write(' | '),
  write(E),
  display_elems(Es).
display_elems([]):-write(' | ').

/*Display dos indices das colunas*/
display_cols(Indice,Length):-
  write('    '),
  display_cols_indices(Indice,Length).

display_cols_indices(Indice,Length):-
  Indice<Length,
  Indice1 is Indice+1,
  write(' | '),
  write(Indice),
  display_cols_indices(Indice1,Length).
display_cols_indices(Length,Length):-write(' | '),nl.

/*Display das linhas separadoras horizontais*/
display_horizontal(N):-
  write('  '),
  display_horizontal_line(N).

display_horizontal_line(N):-
  N>=1,
  N1 is N-1,
  write(''),
  write('-'),
  write(''),
  display_horizontal_line(N1).
display_horizontal_line(0):-nl.

/*Display da fronteira entre ambos os quadrantes*/
display_boundary(N):-
  N>=1,
  N1 is N-1,
  write(''),
  write('_____'),
  write(''),
  display_boundary(N1).
display_boundary(0):-nl.


/*Funções responsáveis por identificar as peças de jogo e calcular os pontos totais numa só linha--------------------------------------------------------------------------------------*/

piece_value('A', Value):-Value is 3.
piece_value('a',Value):-Value is 2.
piece_value('+',Value):-Value is 1.
piece_value(Rest,Value):-Value is 0.

/*calc_players_points([L|Ls],NumLines,TotalValue1,TotalValue2,CurrLine):-
  CurrLine>round(NumLines/2),
  CurrLine1 is CurrLine+1,
  calc_value_line(L,Player1),
  TotalValue1 is TotalValue1+Player1,
  calc_players_points(Ls,NumLines,TotalValue1,TotalValue2,CurrLine1).

calc_players_points([L|Ls],NumLines,TotalValue1,TotalValue2,CurrLine):-
  CurrLine1 is CurrLine+1,
  calc_value_line(L,Player2),
  TotalValue2 is TotalValue2+Player2,
  calc_players_points(Ls,NumLines,TotalValue1,TotalValue2,CurrLine1).

calc_players_points([],_,_,_,_).
*/

sum_line([], FinalValue, FinalValue).
sum_line([E|Es], CurrValue, FinalValue) :- piece_value(E,Val),CurrValue1 is CurrValue + Val, sum_line(Es, CurrValue1, FinalValue).

calc_value_line([], 0).
calc_value_line(L, Value) :- sum_line(L,0,Value).
