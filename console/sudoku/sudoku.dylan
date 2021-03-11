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
  
  // Row 1
  g.game-board[0,0] := 8; g.game-board[0,1] := 2; g.game-board[0,2] := 7;
  g.game-board[0,3] := 1; g.game-board[0,4] := 5; g.game-board[0,5] := 4;
  g.game-board[0,6] := 3; g.game-board[0,7] := 9; g.game-board[0,8] := 6;
  
  // Row 2
  g.game-board[1,0] := 9; g.game-board[1,1] := 6; g.game-board[1,2] := 5;
  g.game-board[1,3] := 3; g.game-board[1,4] := 2; g.game-board[1,5] := 7;
  g.game-board[1,6] := 1; g.game-board[1,7] := 4; g.game-board[1,8] := 8;
  
  // Row 3
  g.game-board[2,0] := 3; g.game-board[2,1] := 4; g.game-board[2,2] := 1;
  g.game-board[2,3] := 6; g.game-board[2,4] := 8; g.game-board[2,5] := 9;
  g.game-board[2,6] := 7; g.game-board[2,7] := 5; g.game-board[2,8] := 2;
  
  // Row 4
  g.game-board[3,0] := 5; g.game-board[3,1] := 9; g.game-board[3,2] := 3;
  g.game-board[3,3] := 4; g.game-board[3,4] := 6; g.game-board[3,5] := 8;
  g.game-board[3,6] := 2; g.game-board[3,7] := 7; g.game-board[3,8] := 1;
  
  // Row 5
  g.game-board[4,0] := 4; g.game-board[4,1] := 7; g.game-board[4,2] := 2;
  g.game-board[4,3] := 5; g.game-board[4,4] := 1; g.game-board[4,5] := 3;
  g.game-board[4,6] := 6; g.game-board[4,7] := 8; g.game-board[4,8] := 9;
  
  // Row 6
  g.game-board[5,0] := 6; g.game-board[5,1] := 1; g.game-board[5,2] := 8;
  g.game-board[5,3] := 9; g.game-board[5,4] := 7; g.game-board[5,5] := 2;
  g.game-board[5,6] := 4; g.game-board[5,7] := 3; g.game-board[5,8] := 5;
  
  // Row 7
  g.game-board[6,0] := 7; g.game-board[6,1] := 8; g.game-board[6,2] := 6;
  g.game-board[6,3] := 2; g.game-board[6,4] := 3; g.game-board[6,5] := 5;
  g.game-board[6,6] := 9; g.game-board[6,7] := 1; g.game-board[6,8] := 4;
  
  // Row 8
  g.game-board[7,0] := 1; g.game-board[7,1] := 5; g.game-board[7,2] := 4;
  g.game-board[7,3] := 7; g.game-board[7,4] := 9; g.game-board[7,5] := 6;
  g.game-board[7,6] := 8; g.game-board[7,7] := 2; g.game-board[7,8] := 3;
  
  // Row 9
  g.game-board[8,0] := 2; g.game-board[8,1] := 3; g.game-board[8,2] := 9;
  g.game-board[8,3] := 8; g.game-board[8,4] := 4; g.game-board[8,5] := 1;
  g.game-board[8,6] := 5; g.game-board[8,7] := 6; g.game-board[8,8] := 7;
  
end method;

define method initialize(g :: <game>, #key)
  next-method();
  createBoard(g);
end;


define method byRows(g,i,j,n)
  g.game-board[i,j] = n
end method;

define method byCols(g,i,j,n)
  g.game-board[j,i] = n
end method;

define method checkLines(g :: <game>, fn)

  let result = #t;
  
  for (i from 0 to 8)
  
    for (n from 1 to 9)
    
      let hasN = #f;
      
      for (j from 0 to 8)
      
        // Go through row or column
        if (fn(g,i,j,n))
          hasN := #t;
          break;
        end if;
        
      end;
      
      // Return false
      if (~hasN)
        result := #f;
        break;
      end if;
      
    end;
    
    if (~result)
      break;
    end if;
    
  end;
    
  result
  
end method;

define method checkRows(g :: <game>)
  checkLines(g,byRows)
end method;

define method checkCols(g :: <game>)
  checkLines(g,byCols)
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
