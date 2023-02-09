
% -----------------------------------------------------------------------------

% Turtle

% -----------------------------------------------------------------------------

:- module turtle.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.
:- implementation.
:- import_module int, string, list, char.

% -----------------------------------------------------------------------------

:- type position == {int, int}.
:- type dimensions == {int, int}.
:- type points == list(position).
:- type wstate == {position, points, int, dimensions}.

% -----------------------------------------------------------------------------

% Find new position for character
:- pred mchar(char::in, position::in, position::out) is semidet.
mchar('w', {R, C}, {R - 1, C}).
mchar('s', {R, C}, {R + 1, C}).
mchar('a', {R, C}, {R, C - 1}).
mchar('d', {R, C}, {R, C + 1}).

% Find new position or stay in the same place
:- func move(char, position) = position.
move(Char, Position) =
  (
    if
      mchar(Char, Position, NP),
      {NewRow, NewCol} = NP,
      NewRow >= 0, NewCol >= 0
    then
      NP
    else
      Position
  ).

% -----------------------------------------------------------------------------

% Adjust dimensions to last marked position
:- func new_dimensions(dimensions, position) = dimensions.
new_dimensions({Height, Width}, {Row, Col}) =
  {(if Row >= Height then Row + 1 else Height),
   (if Col >= Width then Col + 1 else Width)}.

:- pred new_points(wstate::in, position::in, points::out, dimensions::out) is det.
new_points({Position, Points, Mode, Dimensions}, UpdatedPosition, NewPoints, NewDimensions) :-
  (
    if

      % Drawing mode, position changed, point is not already in set
      Mode = 1, Position \= UpdatedPosition, not member(Position, Points)

    then

      % Draw point
      NewPoints = [Position | Points],

      % Adjust size
      NewDimensions = new_dimensions(Dimensions, Position)

    else
      NewPoints = Points, NewDimensions = Dimensions
  ).

% Return new mode
:- func new_mode(char, int) = int.
new_mode(Char, Mode) = Mode * (if 'r' = Char then -1 else 1).

% Process one character
% Return new state
:- pred process_char(char::in, wstate::in, wstate::out) is det.
process_char(Char, State, {UpdatedPosition, NewPoints, new_mode(Char, Mode), NewDimensions}) :-

  % Read position and mode from old state
  State = {Position, _, Mode, _},

  % Update position
  UpdatedPosition = move(Char, Position),

  % Return new points to draw and updated dimensions
  new_points(State, UpdatedPosition, NewPoints, NewDimensions).

% -----------------------------------------------------------------------------

:- pred process_string_helper(string::in, int::in, wstate::in,
                              points::out, dimensions::out) is det.
process_string_helper(String, Index, State, NewPoints, Dimensions) :-
    if
      index(String, Index, Char)
    then
      process_char(Char, State, NewState),
      process_string_helper(String, 1 + Index, NewState, NewPoints, Dimensions)
    else
      {_, NewPoints, _, Dimensions} = State.

% Process input string
% Return points to draw and canvas dimensions
:- pred process_string(string::in, points::out, dimensions::out) is det.
process_string(String, Points, Dimensions) :-

  % Start processing string
  % Initial index: 0
  % Initial position: {0, 0}
  % Empty list of points
  % Mode: -1 (drawing disabled)
  % Dimensions: {0, 0}
  process_string_helper(String, 0, {{0, 0}, [], -1, {0, 0}}, Points, Dimensions).

% -----------------------------------------------------------------------------

% Main point drawing function
:- pred draw(points::in, dimensions::in, io::di, io::uo) is det.
draw(Points, Dimensions, !IO) :-
  if [] = Points then nl(!IO) else draw_helper(Points, Dimensions, !IO).

:- pred draw_helper(points::in, dimensions::in, io::di, io::uo) is det.
draw_helper(Points, Dimensions, !IO) :-
  if
    [] = Points
  then
    true
  else
    {RowCount, _} = Dimensions, draw_rows(Points, RowCount, Dimensions, !IO).

% Draw all rows
:- pred draw_rows(points::in, int::in, dimensions::in, io::di, io::uo) is det.
draw_rows(Points, RowCounter, Dimensions, !IO) :-
  {Height, Width} = Dimensions,
  (
    if
      RowCounter > 0, Row = Height - RowCounter
    then
      draw_row(Points, Row, Width, Width, !IO), nl(!IO),
      draw_rows(Points, RowCounter - 1, Dimensions, !IO)
    else
      true
  ).

% Draw row in image
:- pred draw_row(points::in, int::in, int::in, int::in, io::di, io::uo) is det.
draw_row(Points, RowIndex, ColCounter, Width, !IO) :-
  if
    ColCounter > 0,
    ColIndex = Width - ColCounter
  then
    write_string(if member({RowIndex, ColIndex}, Points) then "." else " ", !IO),
    draw_row(Points, RowIndex, ColCounter - 1, Width, !IO)
  else
    true.

% -----------------------------------------------------------------------------

% Show coordinates of one point
:- pred show_point(position::in, io::di, io::uo) is det.
show_point({X, Y}, !IO) :-
  format("%d:%d, ", [i(X), i(Y)], !IO).

% Display points
:- pred show_points(points::in, io::di, io::uo) is det.
show_points([], !IO) :- nl(!IO).
show_points([Fst | Rst], !IO) :- show_point(Fst, !IO), show_points(Rst, !IO).

% -----------------------------------------------------------------------------

% Line helper
:- pred draw_line_helper(int::in, io::di, io::uo) is det.
draw_line_helper(Len, !IO) :-
  if Len > 0 then write_string("-", !IO), draw_line_helper(Len - 1, !IO) else true.

% Line
:- pred draw_line(int::in, io::di, io::uo) is det.
draw_line(Len, !IO) :-
  draw_line_helper(Len, !IO), nl(!IO).

% -----------------------------------------------------------------------------

% Predicate in main loop
:- pred process(string::in, io::di, io::uo) is det.
process(String, !IO) :-

  % Collect points
  process_string(String, Points, Dimensions),
  {Height, Width} = Dimensions,

  % Show values
  format("Number of points: %d\n", [i(length(Points))], !IO),
  format("Height: %d\nWidth: %d\n", [i(Height), i(Width)], !IO),
  write_string("Points: ", !IO),
  show_points(Points, !IO),

  (

    if
      [] = Points
    then
      true
    else

      % Draw points and lines
      draw_line(Width, !IO),
      draw(Points, Dimensions, !IO),
      draw_line(Width, !IO)

  ),

  % Continue
  main(!IO).

% -----------------------------------------------------------------------------

main(!IO) :-

  % Read input
  read_line_as_string(Result, !IO),

  (

    if

      % Test input
      ok(Str) = Result,
      String = string.strip(Str)

    then

      % Process string or quit
      (if String \= "q" then process(String, !IO) else write_string("Bye\n", !IO))

    else

      % Error
      write_string("Wrong input\n", !IO)

  ).

% -----------------------------------------------------------------------------

