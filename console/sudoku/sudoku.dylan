Module: sudoku
Synopsis:
Author:
Copyright:

// Application created with: 'make-dylan-app sudoku'
// Build & Run: 'dylan-compiler -build sudoku.lid && ./_build/bin/sudoku'

define class <game> (<object>)
  slot game-board :: <array>;
end class <game>;

define method show(g :: <game>)
  for (row from 0 to 8)
    for (col from 0 to 8)
      format-out("|%d",g.game-board[row,col]);
    end;
    format-out("|\n");
  end;
end method;

define method checkGame(g :: <game>)
  checkRows(g) & checkCols(g) & checkSquares(g)
end method;

define method createBoard(g :: <game>)
  g.game-board := make(<array>, dimensions: #[9,9], fill: 0);
end method;

define method initialize(g :: <game>, #key)
  next-method();
  createBoard(g);
end;

define method checkRows(g :: <game>)
  //for (row from 0 to 8)
  //  for (col from 0 to 8)
  //  end;
  //end;
  #t
end method;

define method checkCols(g :: <game>)
  #t
end method;

define method checkSquares(g :: <game>)
  #t
end method;


define function main(name :: <string>, arguments :: <vector>)

  format-out("\n\n");
  
  let g = make(<game>);
  
  format-out("Plansza\n");
  
  format-out("-------------------\n");
  show(g);
  format-out("-------------------\n");
  
  if (checkGame(g))
    format-out("Zwycięstwo\n");
  else
    format-out("Porażka\n");
  end if;
  
  
  exit-application(0);
  
end function main;

main(application-name(), application-arguments());
