/*Retorno de simbolo de cada tipo de peça--------------------------------------------------------------------------------------------------------------------------------------------*/

  piece_simbol(queen,'A').
  piece_simbol(drone,'a').
  piece_simbol(pawn,'+').
  piece_simbol(empty,' ').

  /*Função para inicializar um tabuleiro de forma estática-----------------------------------------------------------------------------------------------------------------------------*/

  initialize_board(Board,Columns,Rows):-
    Columns is 4,
    Rows is 8,
    Board=[[queen,queen,drone,empty],
           [queen,drone,pawn,empty],
           [drone,pawn,pawn,empty],
           [empty,empty,empty,empty],
           [empty,empty,empty,empty],
           [empty,pawn,pawn,drone],
           [empty,pawn,drone,queen],
           [empty,drone,queen,queen]].

/*Funções responsáveis por gerar o tabuleiro vazio de forma dinámica-------------------------------------------------------------------------------------------------------------------*/
generate_line([],0).

generate_line([E|Es],N):-
 N > 0,
 N1 is N - 1,
 E=pawn,
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

  /*Funções responsáveis por identificar as peças de jogo e calcular os pontos totais numa só linha--------------------------------------------------------------------------------------*/

piece_value(queen, Value):-Value is 3.
piece_value(drone,Value):-Value is 2.
piece_value(pawn,Value):-Value is 1.
piece_value(Rest,Value):-Value is 0.


calc_players_points([L|Ls],NumLines,PlayerPoints1,PlayerPoints2):-
  calc_points([L|Ls],NumLines,0,PlayerPoints1,0,PlayerPoints2,0).

calc_points([L|Ls],NumLines,CurrPlayerPoints1,PlayerPoints1,CurrPlayerPoints2,PlayerPoints2,CurrLine):-
    CurrLine<NumLines,
    CurrLine>round(NumLines/2),
    CurrLine1 is CurrLine+1,
    calc_value_line(L,LinePoints),
    CurrPlayerPoints11 is CurrPlayerPoints1+LinePoints,
    calc_points(Ls,NumLines,CurrPlayerPoints11,PlayerPoints1,CurrPlayerPoints2,PlayerPoints2,CurrLine1).

calc_points([L|Ls],NumLines,CurrPlayerPoints1,PlayerPoints1,CurrPlayerPoints2,PlayerPoints2,CurrLine):-
    CurrLine<NumLines,
    CurrLine1 is CurrLine+1,
    calc_value_line(L,LinePoints),
    CurrPlayerPoints21 is CurrPlayerPoints2+LinePoints,
    calc_points(Ls,NumLines,CurrPlayerPoints1,PlayerPoints1,CurrPlayerPoints21,PlayerPoints2,CurrLine1).

calc_points([],NumLines,FinalPoints1,FinalPoints1,FinalPoints2,FinalPoints2,NumLines).

sum_line([], FinalValue, FinalValue).
sum_line([E|Es], CurrValue, FinalValue) :- piece_value(E,Val),CurrValue1 is CurrValue + Val, sum_line(Es, CurrValue1, FinalValue).

calc_value_line([], 0).
calc_value_line(L, Value) :- sum_line(L,0,Value).


  /*Funções responsáveis por mover peças de jogo e a sua verificação -------------------------------------------------------------------------------------------------------------------*/
move(Board,Xi,Yi,Xf,Yf,NewBoard):-
           % Para o caso da a célula para onde quer mexer a peça estar para trás da célula
    Yf<Yi, % onde se encontra.
    write('YF<YI\n'),
    verify_initial_cell(Board,0,0,Xf,Yf,CellFinal),
    write('Casa final: '), write(CellFinal),nl,
    verify_initial_cell(Board,0,0,Xi,Yi,CellInitial),
    write('Case inicial: '),write(CellInitial),nl,
    place_cell(Board,NewBoard,Xi,Yi,Xf,Yf,CellInitial),
    display_board(NewBoard,8,4,0).

move(Board,Xi,Yi,Xf,Yf):-
    Yi=Yf,
    Xf<Xi,
    write('XF<XI   YF<YI\n'),
    verify_initial_cell(Board,0,0,Xf,Yf,CellFinal),
    write('Casa final: '), write(CellFinal),nl,
    verify_initial_cell(Board,0,0,Xi,Yi,CellInitial),
    write('Case inicial: '),write(CellInitial),nl,
    place_cell(Board,NewBoard,Xi,Yi,Xf,Yf,CellInitial),
    display_board(NewBoard,8,4,0).

move(Board,Xi,Yi,Xf,Yf):-
    Yf>=Yi,
    verify_initial_cell(Board,0,0,Xf,Yf,CellInitial),
    write('Casa inicial: '), write(CellInitial),nl,
    verify_initial_cell(Board,0,0,Xi,Yi,CellFinal),
    write('Case final: '),write(CellFinal),nl,
    place_cell(Board,NewBoard,Xi,Yi,Xf,Yf,CellFinal),
    display_board(NewBoard,8,4,0).

verify_empty_path(Board, Xi, Yf, Xf, Yf):-          % Horizontal Movement %
    verify_empty_path(Board, Xi, Yf, Xf, Yf, 1, 0).

verify_empty_path(Board, Xf, Yi, Xf, Yf):-          % Vertical Movement %
    verify_empty_path(Board, Xf, Yi, Xf, Yf, 0, 1).

verify_empty_path(Board, Xi, Yi, Xf, Yf):-          % Diagonal Movement %
    verify_empty_path(Board, Xi, Yi, Xf, Yf, 1, 1).

verify_empty_path(Board, Xf-1, Yf-1, Xf, Yf, XInc, YInc).

verify_empty_path(Board, Xi, Yi, Xf, Yf, XInc, YInc):-
    X1 is Xi + XInc,
    Y1 is Yi + YInc,
    nth0(Y1, Board, Line),
    nth0(X1, Line, Elem),
    Elem = empty,
    verify_empty_path(Board, X1, Y1, Xf, Yf, XInc, YInc).

place_cell(Board,NewBoard,Xi,Yi,Xf,Yf,pawn):-
    XDif is Xf-Xi,
    YDif is Yf-Yi,
    XMod is XDif*XDif,
    YMod is YDif*YDif,
    XMod=1,
    YMod=1,
    write('VOU PARA O SWITCH\n'),
    putOnBoard(Yi,Xi,empty,Board,Board1),
    putOnBoard(Yf,Xf,pawn,Board1,NewBoard),
    Changed is 1,
    write('VALIDOU\n');
    NewBoard = Board.

place_cell(Board,NewBoard,Xf,Yi,Xf,Yf,drone):-
    Yf-Yi >= -2,
    Yf-Yi <= 2,
    verify_empty_path(Board, NewBoard, Xf, Yi, Xf, Yf),
    % TODO: verify if eats anything %
    putOnBoard(Yi, Xf, empty, Board, Board1),
    putOnBoard(Yf, Xf, drone, Board1, NewBoard).

place_cell(Board,NewBoard,Xi,Yf,Xf,Yf,drone):-
    Yf-Yi >= -2,
    Yf-Yi <= 2,
    verify_empty_path(Board, NewBoard, Xi, Yi, Xf, Yf),
    % TODO: verify if eats anything %
    putOnBoard(Yf, Xi, empty, Board, Board1),
    putOnBoard(Yf, Xf, drone, Board1, NewBoard).

place_cell(Board,NewBoard,Xi,Yi,Xf,Yf,queen):-
    XDif is Xf - Xi,
    YDif is Yf - Yi
    XDif * XDif = YDif * YDif,
    place_cell_any_movement(Board,NewBoard,Xi,Yi,Xf,Yf,queen).

place_cell(Board,NewBoard,Xf,Yi,Xf,Yf,queen):-
    place_cell_any_movement(Board,NewBoard,Xf,Yi,Xf,Yf,queen).

place_cell(Board,NewBoard,Xi,Yg,Xf,Yf,queen):-
    place_cell_any_movement(Board,NewBoard,Xi,Yf,Xf,Yf,queen).

place_cell_any_movement(Board,NewBoard,Xi,Yi,Xf,Yf,queen):-
    verify_empty_path(Board, Xi, Yi, Xf, Yf),
    % TODO: verify if eats anything %
    putOnBoard(Yi,Xi,empty,Board,Board1),
    putOnBoard(Yf,Xf,queen,Board1,NewBoard).


place_cell(Board,NewBoard,Xi,Yi,Xf,Yf,Cell):-
    write('CELULA: '),write(Cell),nl,
    write('Not a valid Cell.\n'),
    NewBoard = Board.

putOnBoard(0, ElemCol, NewElem, [RowAtTheHead|RemainingRows], [NewRowAtTheHead|RemainingRows]):-
  	putOnColumn(ElemCol, NewElem, RowAtTheHead, NewRowAtTheHead).

putOnBoard(ElemRow, ElemCol, NewElem, [RowAtTheHead|RemainingRows], [RowAtTheHead|ResultRemainingRows]):-
  	ElemRow > 0,
  	ElemRow1 is ElemRow - 1,
  	putOnBoard(ElemRow1, ElemCol, NewElem, RemainingRows, ResultRemainingRows).

putOnColumn(0, Elem, [_|L], [Elem|L]).

putOnColumn(I, Elem, [H|L], [H|ResL]):-
  	I > 0,
  	I1 is I - 1,
  	putOnColumn(I1, Elem, L, ResL).

verify_initial_cell([L|Ls],Xi,Yi,Xf,Yf,Cell):-
    Yi<Yf,
    Yi1 is Yi+1,
    verify_initial_cell(Ls,Xi,Yi1,Xf,Yf,Cell).

verify_initial_cell([],_,_,_,_,Cell):-
    write('Fim de lista de listas, valor de Y demasiado elevado.\n').

verify_initial_cell([L|Ls],Xi,Yi,Xf,Yf,Cell):-
    Yi=Yf,
    write('\nINTO row_cell.'),
    verify_row_cell(L,0,Xf,Cell).

verify_row_cell([E|Es],Xi,Xf,Cell):-
    Xi<Xf,
    Xi1 is Xi+1,
    verify_row_cell(Es,Xi1,Xf,Cell).

verify_row_cell([E|Es],Xf,Xf,Cell):-
    Cell=E.

verify_row_cell([],_,_,Cell):-
    write('Fim da lista de elementos, valor de X demasiado grande.\n').
