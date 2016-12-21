:-use_module(library(clpfd)).
:-use_module(library(lists)).

% [-1,-1,-1,-1,10,-1,-1,-1,-1,-1,-1,-1],
% [2,-1,-1,-1,-1,-1,5,-1,-1,-1,-1,-1],
% [-1,-1,6,-1,-1,-1,-1,-1,-1,-1,7,-1],
% [-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,12],
% [-1,-1,-1,9,-1,-1,-1,-1,-1,-1,1,-1],
% [-1,-1,-1,-1,-1,-1,-1,-1,7,-1,-1,-1],
% [-1,4,-1,-1,-1,-1,-1,8,-1,-1,-1,-1],
% [9,-1,-1,-1,1,-1,-1,-1,-1,-1,4,-1],
% [-1,5,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1],
% [-1,-1,-1,-1,-1,-1,6,-1,-1,1,-1,-1],
% [-1,-1,8,-1,-1,-1,-1,-1,-1,-1,-1,6],
% [-1,-1,-1,-1,-1,-1,-1,-1,13,-1,-1,-1]

 % Board:- [5-1-10,
 %          1-2-2,
 %          7-2-5,
 %          3-3-6,
 %          11-3-7,
 %          12-4-12,
 %          4-5-9,
 %          11-5-1,
 %          9-6-7,
 %          2-7-4,
 %          8-7-8,
 %          1-8-9,
 %          5-8-1,
 %          11-8-4,
 %          2-9-5,
 %          7-10-6,
 %          10-10-1,
 %          3-11-8,
 %          12-11-8,
 %          9-12-13]

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

flatten([],[]).
flatten([LH|LT], Flattened) :-
	is_list(LH),
	flatten(LH, Aux),
	append(Aux, LT2, Flattened),
	flatten(LT, LT2).

flatten([LH | LT], [LH | FlattenedT]) :-
	\+is_list(LH),
	flatten(LT, FlattenedT).


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
  LineAppearances #= NoAppearances+2-ColAppearances.

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
  flatten(Result, FlatResult),
  labeling([], FlatResult),
  fd_statistics.
