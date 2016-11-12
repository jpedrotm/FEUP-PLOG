%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Create initial board %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
initialize_board(Board):-
  Board=[['Q','Q','D',' '],
         ['Q','D','P',' '],
         ['D','P','P',' '],
         [' ',' ',' ',' '],
         [' ',' ',' ',' '],
         [' ','P','P','D'],
         [' ','P','D','Q'],
         [' ','D','Q','Q']].

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Board drawing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

display_board([],0):-nl.                   % Stops when the number of drawn lines is the given one
display_board([L|Ls],5):-                  %
    display_line(L),                       % Displays the 4th line
    write(' '),                            %
    display_horizontal_line(6),            % And then displays an horizontal line
    nl,                                    % Separating both parts of the board
    nl,                                    %
    display_board(Ls,4).                   %
display_board([L|Ls],N):-                  %
    N1 is N-1,                             % Step.
    display_line(L),                       % Displays the line
    nl,                                    %
    display_board(Ls,N1).                  % Recursive call to display other lines



display_line([E|Es]):-
    write(' | '),
    write(E),
    display_line(Es).
display_line([]):-
    write(' | '),
    nl.

display_horizontal_line(N):-
    N>=1,
    N1 is N-1,
    write('_'),
    write('_'),
    write('_'),
    display_horizontal_line(N1).
display_horizontal_line(0).
