:-include('solver.pl').

translate_element(-1,Points,' ').
translate_element(E,Points,Number,Xc,Yc):-
  nth1(E,Points,Xc-Yc-Number).

display_board([L|Ls],N,Points,Y):-
  display_space_line(N),
  write('|'),
  nl,
  display_line_board(L,Points,1,Y),
  write('|'),
  nl,
  display_space_line(N),
  write('|'),
  nl,
  write('   '),
  display_boundary(N),
  nl,
  Y1 is Y+1,
  display_board(Ls,N,Points,Y1).

display_board([],_,Points,_):-nl.

display_boundary(0).

display_boundary(N):-
  format('~t~p~4|',['------']),
  N1 is N-1,
  display_boundary(N1).

  display_line_board([E|Es],Points,X,Y):-
    translate_element(E,Points,Vis,Xc,Yc),
    Xc=X,
    Yc=Y,
    format('~t~p~4|*~t~d*~t~4+',['| ',Vis]),
    X1 is X+1,
    display_line_board(Es,Points,X1,Y).

display_line_board([E|Es],Points,X,Y):-
  translate_element(E,Points,Vis,Xc,Yc),
  format('~t~p~4|~t~d~t~4+',['| ',Vis]),
  X1 is X+1,
  display_line_board(Es,Points,X1,Y).

display_line_board([],Points,_,_).

display_space_line(0).

display_space_line(N):-
  format('~t~p~4|~t~p~t~4+',['| ',' ']),
  N1 is N-1,
  display_space_line(N1).

display_board(Board,Points):-
  nl,
  length(Board,N),
  write('   '),
  display_boundary(N),
  nl,
  display_board(Board,N,Points,1).

main:-
  write('------------------------------------------------------------------\n'),
  write('----------------------------- Four Winds -------------------------\n'),
  write('------------------------------------------------------------------\n'),
  write('------------- 1 - Visualizar solucao para puzzle 5x5. ------------\n'),
  write('------------- 2 - Visualizar solucao para puzzle 8x8. ------------\n'),
  write('------------- 3 - Visualizar solucao para puzzle 12x12 1. --------\n'),
  write('------------- 4 - Visualizar solucao para puzzle 12x12 2. --------\n'),
  write('------------- 5 - Visualizar solucao para puzzle 12x12 3. --------\n'),
  write('--------------------------- 6 - Sair.  ---------------------------\n'),
  read(Opt),
	(
		Opt = 1 -> board(Board,Opt),solve_prob(Board,Points,Result),display_board(Result,Points),main;
		Opt = 2 -> board(Board,Opt),solve_prob(Board,Points,Result),display_board(Result,Points),main;
		Opt = 3 -> board(Board,Opt),solve_prob(Board,Points,Result),display_board(Result,Points),main;
    Opt = 4 -> board(Board,Opt),solve_prob(Board,Points,Result),display_board(Result,Points),main;
    Opt = 5 -> board(Board,Opt),solve_prob(Board,Points,Result),display_board(Result,Points),main;
    Opt = 6;
    nl,
		write('Opção inválida. Selecione outra opção.\n'),
    main
	).
