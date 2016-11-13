% :-include('Logic.pl').

%%%%%%%%%%%%%%% FUNCTIONS TO CHECK IF THERE IS ANY MOVEMENT A PIECE CAN MAKE AND EAT ANOTHER %%%%%%%%%%%%%%%%%%

% eats(Board, Player, Xf, Yf, Elem):-
%     crosses_board_half(Yf, Player),
%     get_board_element(Board, Xf, Yf, Elem),
%     Elem \= empty.
%
% has_eating_direction(Board, Xi, Yi, Xf, Yf, player1, pawn):-        % Assumes bot is always player1
%     Xf is Xi + 1,
%     Yf is Yi + 1,
%     can_eat(Board, Xi, Yi, Xf, Yf, player1);
%     Xf is Xi - 1,
%     Yf is Yi + 1,
%     can_eat(Board, Xi, Yi, Xf, Yf, player1).
%
% can_eat(Board, Xi, Yi, Xf, Yf, Player):-
%     verify_empty_path(Board, Xi, Yi, Xf, Yf),
%     eats(Board, Player, Xf, Yf, Elem).
%
% has_eating_direction(Board, Xi, Yi, Xf, Yf, player1, drone):-        % Assumes bot is always player1
%     Xf is Xi,
%     Yf is Yi + 1,
%     can_eat(Board, Xi, Yi, Xf, Yf, player1);
%     Xf is Xi,
%     Yf is Yi + 2,
%     can_eat(Board, Xi, Yi, Xf, Yf, player1).
%
% has_eating_direction(Board, Xi, Yi, Xf, Yf, player1, queen):-        % Assumes bot is always player1
%     has_eating_vertical_movement(Board, Xi, Yi, Xf, Yf, player1, 1). % Vertical Movement
%
% has_eating_direction(Board, Xi, Yi, Xf, Yf, player1, queen):-        % Assumes bot is always player1
%     has_eating_pos_diagonal_movement(Board, Xi, Yi, Xf, Yf, player1, 1). % Diagonal Movement with positive slope
%
% has_eating_direction(Board, Xi, Yi, Xf, Yf, player1, queen):-        % Assumes bot is always player1
%     has_eating_neg_diagonal_movement(Board, Xi, Yi, Xf, Yf, player1, 1). % Diagonal Movement with negative slope
%
% has_eating_vertical_movement(Board, Xi, Yi, Xf, Yf, player1, N):-
%     Xf is Xi,
%     Yf is Yi + N,
%     Yf < 8,
%     can_eat(Board, Xi, Yi, Xf, Yf, player1);
%     Yf < 8,
%     N1 is N+1,
%     has_eating_vertical_movement(Board, Xi, Yi, Xf, Yf, player1, N1).
%
% has_eating_pos_diagonal_movement(Board, Xi, Yi, Xf, Yf, player1, N):-
%     Xf is Xi + N,
%     Yf is Yi + N,
%     Yf < 8,
%     Xf < 4,
%     Xf >= 0,
%     can_eat(Board, Xi, Yi, Xf, Yf, player1).
%
% has_eating_neg_diagonal_movement(Board, Xi, Yi, Xf, Yf, player1, N):-
%     Xf is Xi - N,
%     Yf is Yi + N,
%     Yf < 8,
%     Xf < 4,
%     Xf >= 0,
%     can_eat(Board, Xi, Yi, Xf, Yf, player1).
%
% has_eating_pos_diagonal_movement(Board, Xi, Yi, Xf, Yf, player1, N):-
%     Yf < 8,
%     Xf < 4,
%     Xf >= 0,
%     N1 is N + 1,
%     has_eating_pos_diagonal_movement(Board, Xi, Yi, Xf, Yf, player1, N1).
%
% has_eating_neg_diagonal_movement(Board, Xi, Yi, Xf, Yf, player1, N):-
%     Yf < 8,
%     Xf < 4,
%     Xf >= 0,
%     N1 is N + 1,
%     has_eating_neg_diagonal_movement(Board, Xi, Yi, Xf, Yf, player1, N1).

is_valid_movement(Board, Xi, Yi, Xf, Yf, Piece, Player):-
    verify_empty_path(Board, Xi, Yi, Xf, Yf),
    check_post_movement_events(Board, Xf, Yf, Player, 0, X, Piece, NewPiece).

add_valid_movement(Board, Xi, Yi, XInc, YInc, Piece, Player, Movs, [[Xi, Yi, Xf, Yf] | Movs]):-
    Xf is Xi + XInc,
    Yf is Yi + YInc,
    is_valid_movement(Board, Xi, Yi, Xf, Yf, Piece, Player).

add_valid_movement(_, _, _, _, _, _, _, Movs, Movs).


valid_movements(Board, Xi, Yi, pawn, Player, Movs, NewMovs):-
    add_valid_movement(Board, Xi, Yi, 1, 1, pawn, Player, Movs, Movs1),
    add_valid_movement(Board, Xi, Yi, 1, -1, pawn, Player, Movs1, Movs2),
    add_valid_movement(Board, Xi, Yi, 1, -1, pawn, Player, Movs2, Movs3),
    add_valid_movement(Board, Xi, Yi, -1, -1, pawn, Player, Movs3, NewMovs).

valid_movements(Board, Xi, Yi, drone, Player, Movs, NewMovs):-
    add_valid_movement(Board, Xi, Yi, 0, 1, pawn, Player, Movs, Movs1),
    add_valid_movement(Board, Xi, Yi, 1, 0, pawn, Player, Movs1, Movs2),
    add_valid_movement(Board, Xi, Yi, 0, -1, pawn, Player, Movs2, Movs3),
    add_valid_movement(Board, Xi, Yi, -1, 0, pawn, Player, Movs3, Movs4),
    add_valid_movement(Board, Xi, Yi, 0, 2, pawn, Player, Movs4, Movs5),
    add_valid_movement(Board, Xi, Yi, 2, 0, pawn, Player, Movs5, Movs6),
    add_valid_movement(Board, Xi, Yi, 0, -2, pawn, Player, Movs6, Movs7),
    add_valid_movement(Board, Xi, Yi, -2, 0, pawn, Player, Movs7, NewMovs).

queen_odd_quadrant_diagonal_movements(Board, Xi, Yi, queen, Player, Movs, NewMovs, N, NInc):-
    Xf is Xi + N,
    Yf is Yi + N,
    Xf >= 0,
    Xf =< 3,
    Yf >= 0,
    Yf =< 7,
    add_valid_movement(Board, Xi, Yi, N, N, queen, Player, Movs, Movs1),
    N1 is N + NInc,
    queen_odd_quadrant_diagonal_movements(Board, Xi, Yi, queen, Player, Movs1, NewMovs, N1, NInc).

queen_odd_quadrant_diagonal_movements(_, _, _, _, _, Movs, Movs, _, _).

queen_even_quadrant_diagonal_movements(Board, Xi, Yi, queen, Player, Movs, NewMovs, N, NInc):-
    Xf is Xi + N,
    Yf is Yi - N,
    Xf >= 0,
    Xf =< 3,
    Yf >= 0,
    Yf =< 7,
    N2 is -N,
    add_valid_movement(Board, Xi, Yi, N, N2, queen, Player, Movs, Movs1),
    N1 is N + NInc,
    queen_even_quadrant_diagonal_movements(Board, Xi, Yi, queen, Player, Movs1, NewMovs, N1, NInc).

queen_even_quadrant_diagonal_movements(_, _, _, _, _, Movs, Movs, _, _).

queen_vertical_movements(Board, Xi, Yi, queen, Player, Movs, NewMovs, N, NInc):-
    Yf is Yi + N,
    Yf >= 0,
    Yf =< 7,
    add_valid_movement(Board, Xi, Yi, 0, N, queen, Player, Movs, Movs1),
    N1 is N + NInc,
    queen_vertical_movements(Board, Xi, Yi, queen, Player, Movs1, NewMovs, N1, NInc).

queen_vertical_movements(_, _, _, _, _, Movs, Movs, _, _).

queen_horizontal_movements(Board, Xi, Yi, queen, Player, Movs, NewMovs, N, NInc):-
    Xf is Xi + N,
    Xf >= 0,
    Xf =< 3,
    add_valid_movement(Board, Xi, Yi, N, 0, queen, Player, Movs, Movs1),
    N1 is N + NInc,
    queen_horizontal_movements(Board, Xi, Yi, queen, Player, Movs1, NewMovs, N1, NInc).

queen_horizontal_movements(_, _, _, _, _, Movs, Movs, _, _).

valid_movements(Board, Xi, Yi, queen, Player, Movs, NewMovs):-
    queen_even_quadrant_diagonal_movements(Board, Xi, Yi, queen, Player, Movs, Movs1, 1, 1),
    queen_even_quadrant_diagonal_movements(Board, Xi, Yi, queen, Player, Movs1, Movs2, -1, -1),
    queen_odd_quadrant_diagonal_movements(Board, Xi, Yi, queen, Player, Movs2, Movs3, 1, 1),
    queen_odd_quadrant_diagonal_movements(Board, Xi, Yi, queen, Player, Movs3, Movs4, -1, -1),
    queen_vertical_movements(Board, Xi, Yi, queen, Player, Movs4, Movs5, 1, 1),
    queen_vertical_movements(Board, Xi, Yi, queen, Player, Movs5, Movs6, -1, -1),
    queen_horizontal_movements(Board, Xi, Yi, queen, Player, Movs6, Movs7, 1, 1),
    queen_horizontal_movements(Board, Xi, Yi, queen, Player, Movs7, Movs8, -1, -1),
    NewMovs = Movs8.

% valid_movements_on_board_half(Board, Player, PlayerNr, Moves, NewMoves, 0):-
%     LineNr is N1 + 4*PlayerNr,
%     nth0(LineNr, Board, Line),
%     valid_movements_on_line(Board, Player, PlayerNr, Moves, Moves1, LineNr, Line, 0).

valid_movements_on_board_half(Board, Player, PlayerNr, Moves, NewMoves):-
    % N > 0,
    % N1 is N -1,
    % LineNr is N1 + 4*PlayerNr,
    % nth0(LineNr, Board, Line),
    % valid_movements_on_line(Board, Player, PlayerNr, Moves, Moves1, LineNr, Line, 0),
    % valid_movements_on_board_half(Board, Player, PlayerNr, Moves1, NewMoves, N1).
    % trace,
    Line1 is 4 * PlayerNr,
    Line2 is 1 + 4 * PlayerNr,
    Line3 is 2 + 4 * PlayerNr,
    Line4 is 3 + 4 * PlayerNr,
    valid_movements_on_line(Board, Player, PlayerNr, Moves, Moves1, Line1, 0),
    valid_movements_on_line(Board, Player, PlayerNr, Moves1, Moves2, Line2, 0),
    valid_movements_on_line(Board, Player, PlayerNr, Moves2, Moves3, Line3, 0),
    valid_movements_on_line(Board, Player, PlayerNr, Moves3, NewMoves, Line4, 0).

% valid_movements_on_line(Board, Player, PlayerNr, Moves, NewMoves, Yi, Line, 3):-
%   nth0(Xi, Line, Elem),
%   Elem\=empty,
%   valid_movements(Board, Xi, Yi, Elem, Player, Moves, NewMoves),
%   Xi1 is Xi +1.

valid_movements_on_line(Board, Player, PlayerNr, Moves, Moves, Yi, 8).

valid_movements_on_line(Board, Player, PlayerNr, Moves, NewMoves, Yi, Xi):-
    get_board_element(Board, Xi, Yi, Elem),
    valid_movements(Board, Xi, Yi, Elem, Player, Moves, Moves1),
    Xi1 is Xi +1,
    valid_movements_on_line(Board, Player, PlayerNr, Moves1, NewMoves, Yi, Xi1).

valid_movements_on_line(Board, Player, PlayerNr, Moves, NewMoves, Yi, Xi):-
    Xi1 is Xi + 1,
    valid_movements_on_line(Board, Player, PlayerNr, Moves, NewMoves, Yi, Xi1).

valid_moves(Board, Player, Moves):-
    player_nr(Player, PlayerNr),
    valid_movements_on_board_half(Board, Player, PlayerNr, [], Moves).

move_value(Board, Player, Move, Value):-
    nth0(2, Move, Xf),
    nth0(3, Move, Yf),
    crosses_board_half(Yf, Player),
    get_board_element(Board, Xf, Yf, EatenCell),
    piece_value(EatenCell, Value).

move_value(Board, Player, Move, Value):-
    nth0(0, Move, Xf),
    nth0(1, Move, Yf),
    nth0(2, Move, Xf),
    nth0(3, Move, Yf),
    is_in_own_half(Yf, Player),
    get_board_element(Board, Xi, Yi, MergeCell1),
    get_board_element(Board, Xf, Yf, MergeCell2),
    MergeCell1 \= empty,
    MergeCell2 \= empty,
    piece_value(MergeCell1, Val1)
    piece_value(MergeCell2, Val2),
    Value is Val1 + Val2.


move_value(_, _, _, 0).

list_size([L|Ls], Size):-
  list_size(Ls, Size1),
  Size is Size1 + 1.
list_size([], 0).




%%%%%%%%%%%% FUNCTIONS TO CHECK IF THE PLAYER HAS ANY MOVEMENT THAT EATS A PIECE %%%%%%%%%%%%%%%%%%%%%%%%%%%

% has_eating_movement_on_line(Board, [Piece|Ls], Xi, Yi, Xf, Yf, player1):-
%     has_eating_direction(Board, Xi, Yi, Xf, Yf, player1, Piece).
%
% has_eating_movement_on_line(Board, [_|Ls], Xi, Yi, Xf, Yf, player1):-
%     has_eating_movement_on_line(Board, Ls, Xi, Yi, Xf, Yf, player1).
%
% has_any_eating_movement(Board, Xi, Yi, Xf, Yf, player1, N):-
%     nth0(N, Board, Line),
%     has_eating_movement_on_line(Board, Line, Xi, Yi, Xf, Yf, player1).
%
% has_any_eating_movement(Board, Xi, Yi, Xf, Yf, player1, N):-
%     N > 0,
%     N1 is N-1,
%     has_any_eating_movement(Board, Xi, Yi, Xf, Yf, player1, N1).
%
% has_any_eating_movement(Board, Xi, Yi, Xf, Yf, player1):-
%     has_any_eating_movement(Board, Xi, Yi, Xf, Yf, player1, 4).
