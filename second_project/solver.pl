:-use_module(library(clpfd)).
:-use_module(library(lists)).

board(Board,1):- %5x5
  Board=[[8,-1,-1,-1,-1],
         [-1,2,-1,1,-1],
         [-1,-1,-1,-1,2],
         [-1,-1,-1,1,-1],
         [-1,2,-1,-1,2]].

board(Board,2):- %8x8
  Board=[[8,-1,-1,-1,-1,-1,-1,-1],
         [-1,-1,-1,-1,12,-1,-1,-1],
         [-1,-1,2,-1,-1,-1,2,-1],
         [-1,-1,2,-1,-1,-1,2,-1],
         [-1,-1,2,-1,-1,-1,2,-1],
         [-1,-1,2,-1,-1,-1,-1,2],
         [-1,-1,2,-1,-1,2,-1,-1],
         [5,-1,2,-1,-1,-1,2,-1]].

board(Board,3):-
  Board=[[-1,-1,-1,-1,10,-1,-1,-1,-1,-1,-1,-1],
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

board(Board,4):-
   Board=[[-1,-1,-1,2,7,-1,-1,-1,-1,-1,-1,-1],
    [2,-1,-1,-1,-1,-1,5,-1,-1,-1,-1,-1],
    [-1,-1,6,-1,-1,-1,-1,-1,-1,-1,7,-1],
    [-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,12],
    [-1,-1,-1,9,-1,-1,-1,-1,-1,-1,1,-1],
    [-1,-1,-1,-1,-1,-1,-1,-1,7,-1,-1,-1],
    [-1,4,-1,-1,-1,-1,-1,8,-1,-1,-1,-1],
    [9,-1,-1,-1,1,-1,-1,-1,-1,-1,4,2],
    [-1,5,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1],
    [-1,-1,-1,-1,-1,-1,6,-1,-1,1,-1,-1],
    [-1,-1,8,-1,-1,-1,-1,-1,-1,-1,-1,3],
    [-1,-1,-1,-1,-1,-1,-1,-1,13,-1,-1,-1]].

  board(Board,5):-
    Board=[[-1,-1,-1,2,4,-1,-1,-1,-1,-1,-1,2],
     [2,-1,-1,-1,-1,-1,5,-1,-1,-1,-1,-1],
     [-1,-1,6,-1,-1,-1,-1,-1,-1,-1,7,-1],
     [-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,12],
     [-1,-1,-1,9,-1,-1,-1,-1,-1,-1,1,-1],
     [-1,-1,-1,-1,-1,-1,-1,-1,7,-1,-1,-1],
     [-1,4,-1,-1,-1,-1,-1,8,-1,-1,-1,-1],
     [9,-1,-1,-1,1,-1,-1,-1,-1,-1,4,2],
     [-1,5,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1],
     [-1,-1,-1,-1,-1,-1,6,-1,-1,1,-1,-1],
     [-1,-1,8,-1,-1,-1,-1,-1,-1,-1,-1,3],
     [-1,-1,-1,-1,-1,-1,-1,-1,13,-1,-1,-1]].

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

get_points_in_line(Points,LineNr,List):-
  get_points_in_line(Points,LineNr,1,List).
get_points_in_line([],_,_,[]).
get_points_in_line([_-LineNr-_|Rest],LineNr,Index,[Index|List]):-
    NextIndex is Index+1,
    get_points_in_line(Rest,LineNr,NextIndex,List).
get_points_in_line([_|Rest],LineNr,Index,List):-
  NextIndex is Index+1,
  get_points_in_line(Rest,LineNr,NextIndex,List).

get_points_in_col(Points,ColNr,List):-
  get_points_in_col(Points,ColNr,1,List).
get_points_in_col([],_,_,[]).
get_points_in_col([ColNr-_-_|Rest],ColNr,Index,[Index|List]):-
    NextIndex is Index+1,
    get_points_in_col(Rest,ColNr,NextIndex,List).
get_points_in_col([_|Rest],ColNr,Index,List):-
  NextIndex is Index+1,
  get_points_in_col(Rest,ColNr,NextIndex,List).

get_point_domain(Points, LineNr, ColNr, List):-
  get_points_in_line(Points,LineNr,LinePoints),
  get_points_in_col(Points,ColNr,ColPoints),
  append(LinePoints, ColPoints, List).

create_domains(Points,Solution):-
  create_domains(Points,Solution,1).

create_line_domains(Points,Line,LineNr):-
  create_line_domains(Points,Line,LineNr,1).

create_line_domains(_,[],_,_).
create_line_domains(Points,[Elem|Rest],LineNr,ColNr):-
  get_point_domain(Points,LineNr,ColNr,Domain),
  list_to_fdset(Domain,FDSet),
  Elem in_set FDSet,
  NextColNr is ColNr + 1,
  create_line_domains(Points,Rest,LineNr,NextColNr).

create_domains(_,[],_).
create_domains(Points,[SolutionHead|SolutionTail],LineNr):-
  create_line_domains(Points,SolutionHead,LineNr),
  NextLineNr is LineNr + 1,
  create_domains(Points,SolutionTail,NextLineNr).

force_solution_size([S|Ss],N):-
  length(S,N),
  force_solution_size(Ss, N).
force_solution_size([],_).

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

force_adjacency(Line, InitialNr, Rep):-
  force_adjacency(Line, InitialNr, Rep, 1).

force_adjacency(Line, InitialNr, Representation, Pos):-
  length(Line, N),
  Pos > N.

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

reset_timer :- statistics(walltime,_).
print_time :-
	statistics(walltime,[_,T]),
	format('\nTempo decorrido durante a procura da solucao: ~3d segundos.',[T]),
  nl,
  nl.

% receives a list of : X-Y-Nr, where nr is the number of blocks we want that block to expand to
solve_prob(Board,Points,Result):-
  length(Board, N),
  length(Result, N),
  get_board_points(Board,Points),
  force_solution_size(Result, N),
  create_domains(Points,Result),
  go_through_board(Points, Result, N, 1),
  matrix_to_list(Result,[],FlatResult),
  reset_timer,
  labeling([ffc], FlatResult),
  print_time,
  fd_statistics.
