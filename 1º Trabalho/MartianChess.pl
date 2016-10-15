

main:-
  Rows = 8, Columns = 4,
  generate_board(Matrix,Rows,Columns),
  display_cols(0,Columns),
  display_board(Matrix,Rows,Columns,0).

  /*Função para inicializar um tabuleiro de forma estática-----------------------------------------------------------------------------------------------------------------------------*/

  initialize_board(Board):-
    Board=[['Q','Q','D',' '],
           ['Q','D','P',' '],
           ['D','P','P',' '],
           [' ',' ',' ',' '],
           [' ',' ',' ',' '],
           [' ','P','P','D'],
           [' ','P','D','Q'],
           [' ','D','Q','Q']].

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

piece_value('Q', Value):-Value is 3.
piece_value('D',Value):-Value is 2.
piece_value('P',Value):-Value is 1.
piece_value(Rest,Value):-Value is 0.

calc_value_line(Value,[E|Es]):-piece_value(E,Val),Value1 is Val+Value,calc_value_line(Value1,Es).
calc_value_line(Value,[]):-write(Value).
