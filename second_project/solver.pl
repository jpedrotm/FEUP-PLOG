:-use_module(library(clpfd)).
:-use_module(library(lists)).

board:- [[-1,-1,-1,-1,10,-1,-1,-1,-1,-1,-1,-1],
 [2,-1,-1,-1,-1,-1,5,-1,-1,-1,-1,-1],
 [-1,-1,6,-1,-1,-1,-1,-1,-1,-1,7,-1],
 [-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,12],
 [-1,-1,-1,9,-1,-1,-1,-1,-1,-1,1,-1],
 [-1,-1,-1,-1,-1,-1,-1,-1,7,-1,-1,-1],
 [-1,4,-1,-1,-1,-1,-1,8,-1,-1,-1,-1],
 [9,-1,-1,-1,1,-1,-1,-1,-1,-1,4,-1],
 [-1,5,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1],
 [-1,-1,-1,-1,-1,-1,6,-1,-1,1,-1,-1],
 [-1,-1,8,-1,-1,-1,-1,-1,-1,-1,-1,6],
 [-1,-1,-1,-1,-1,-1,-1,-1,13,-1,-1,-1]].

 get_board([5-1-10,
          1-2-2,
          7-2-5,
          3-3-6,
          11-3-7,
          12-4-12,
          4-5-9,
          11-5-1,
          9-6-7,
          2-7-4,
          8-7-8,
          1-8-9,
          5-8-1,
          11-8-4,
          2-9-5,
          7-10-6,
          10-10-1,
          3-11-8,
          12-11-8,
          9-12-13]).

get_board_points(Board,Points):-
  get_board_points(Board,1,[],Points).

get_board_points([M|Ms],LineNumber,CurrPoints,FinalPoints):-
  get_line_points(M,LineNumber,1,LinePoints),
  append(CurrPoints,LinePoints,CurrPoints1),
  LineNumber1 is LineNumber+1,
  get_board_points(Ms,LineNumber1,CurrPoints1,FinalPoints).

get_board_points([],_,FinalPoints,FinalPoints).

get_line_points([],_,_,[]).

get_line_points([-1|Tail], LineNr, ColNr, Points):-
  NextColNr is ColNr + 1,
  get_line_points(Tail, LineNr, NextColNr, Points).

get_line_points([Head|Tail], LineNr, ColNr, [ColNr-LineNr-Head|Rest]):-
  Head \= -1,
  NextColNr is ColNr + 1,
  get_line_points(Tail, LineNr, NextColNr, Rest).

force_solution_size([S|Ss],N,NoIndexes):-
  length(S,N),
  domain(S,0,NoIndexes),
  force_solution_size(Ss, N,NoIndexes).
force_solution_size([],_,_).

get_line(List, LineNr, Line):-
  get_line(List, LineNr, 1, Line).
get_line([Head|_], LineNr, LineNr, Head).
get_line([_|Rs], LineNr, N, Line):-
  LineNr \= N,
  N1 is N + 1,
  get_line(Rs, LineNr, N1, Line).

matrix_to_list([M|Ms],CurrList,FinalList):-
  is_list(M),
  append(M,CurrList,CurrList1),
  matrix_to_list(Ms,CurrList1,FinalList).

matrix_to_list([],FinalList,FinalList).

display_board([L|Ls],N):-
  display_line_board(L),
  write('|'),
  nl,
  write('   '),
  display_boundary(N),
  nl,
  display_board(Ls,N).

display_board([],_).

display_boundary(0).

display_boundary(N):-
  format('~t~p~4|',['-----']),
  N1 is N-1,
  display_boundary(N1).

display_line_board([E|Es]):-
  format('~t~p~4|~t~d~t~4+',['|',E]),
  display_line_board(Es).

display_line_board([]).

display_board(Board):-
  nl,
  length(Board,N),
  write('   '),
  display_boundary(N),
  nl,
  display_board(Board,N).

force_adjacency(Line, InitialNr, Rep):-
  force_adjacency(Line, InitialNr, Rep, 1).

force_adjacency(Line, InitialNr, Representation, Pos):-
  Pos < InitialNr,
  NextPos is Pos + 1,
  element(Pos, Line, Elem),
  element(NextPos, Line, NextElem),
  (NextElem #= Representation #/\ Elem #= Representation)
  #\/
  (Elem #\= Representation),
  force_adjacency(Line, InitialNr, Representation, NextPos).

force_adjacency(Line, InitialNr, Representation, Pos):-
  Pos > InitialNr,
  PrevPos is Pos - 1,
  NextPos is Pos + 1,
  element(Pos, Line, Elem),
  element(PrevPos, Line, PrevElem),
  (PrevElem #= Representation #/\ Elem #= Representation)
  #\/
  (Elem #\= Representation),
  force_adjacency(Line, InitialNr, Representation, NextPos).

force_adjacency(Line,InitialNr,Representation,InitialNr):-
  NextPos is InitialNr + 1,
  force_adjacency(Line, InitialNr, Representation, NextPos).

force_adjacency(Line, InitialNr, Representation, Pos):-
  length(Line, N),
  Pos > N.

make_no_appearances(Solution, LineNr, ColNr, Representation, NoAppearances):-
  get_line(Solution, LineNr, Line),
  transpose(Solution, Transposed),
  get_line(Transposed, ColNr, Col),
  element(ColNr, Line, Representation),
  count(Representation, Line, #=, LineAppearances),
  count(Representation, Col, #=, ColAppearances),
  force_adjacency(Line, ColNr, Representation),
  force_adjacency(Col, LineNr, Representation),
  TotalAppearances is NoAppearances+1,
  LineAppearances #= TotalAppearances+1-ColAppearances, %+1 because the line and column have the element repeated
  matrix_to_list(Solution,[],Flattened),
  count(Representation, Flattened, #=, TotalAppearances). % make the nr of appearances on other lines and columns 0

go_through_board([], _, _, _).
go_through_board([Head|Rest], Result, Size, Representation):-
  Head = ColNr-LineNr-NoAppearances,
  make_no_appearances(Result, LineNr, ColNr, Representation, NoAppearances),
  Representation1 is Representation +  1,
  go_through_board(Rest, Result, Size, Representation1).

% receives a list of : X-Y-Nr, where nr is the number of blocks we want that block to expand to
solve_prob(Points, N, Result):-
  length(Result, N),
  length(Points, NoIndexes),
  force_solution_size(Result, N, NoIndexes),
  go_through_board(Points, Result, N, 1),
  matrix_to_list(Result,[],FlatResult),
  labeling([], FlatResult),
  fd_statistics.
