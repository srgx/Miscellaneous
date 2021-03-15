Module: sudoku
Synopsis:
Author:
Copyright:

// Application created with: 'make-dylan-app sudoku'
// Build & Run: 'dylan-compiler -build sudoku.lid && ./_build/bin/sudoku'

define class <game> (<object>)
  slot game-board :: <array>;
  slot game-maps :: <vector>;
  slot game-positions :: <list>, init-value: #();
end class <game>;

define method initialize(g :: <game>, #key)
  next-method();
  g.createBoard;
  g.createMaps;
end method initialize;

define method show(g :: <game>)
  line();
  for (row from 0 to 8)
    for (col from 0 to 8)
      let n = g.game-board[row,col];
      format-out("|");
      if (0 ~= n)
        format-out("%d",n);
      else
        format-out(" ");
      end if;
    end for;
    format-out("|\n");
  end for;
  line();
end method show;

define method equalVectors(a :: <vector>, b :: <vector>)
    a[0] = b[0] & a[1] = b[1]
end method equalVectors;

define method puzzle(g :: <game>)
  let randomInRow = 4;
  for (row from 0 to 8)
    for (i from 1 to randomInRow)
      let col = random(9);
      g.game-board[row,col] := 0;
      let position = vector(row,col);
      if (~member?(position,g.game-positions, test: equalVectors))
        g.game-positions := add(g.game-positions,position);
      end if;
    end for;
  end for;
end method puzzle;

define method randomMap(g :: <game>)
  let s = size(g.game-maps);
  let mapIndex = random(s + 1);  
  if (mapIndex ~= s)
    for (row from 0 to 8)
      for (col from 0 to 8)
        g.game-board[row,col] := g.game-maps[mapIndex][g.game-board[row,col] - 1];
      end for;
    end for;
  end if;
end method randomMap;

define method setNumberAt(g :: <game>, n :: <integer>, i :: <integer>, j :: <integer>)
  let position = vector(i,j);
  if (member?(position,g.game-positions, test: equalVectors))
    format-out("Ustawiam liczbę %d na pozycji %d-%d\n", n, i, j);
    g.game-board[i,j] := n;
  else
    format-out("Nie można ustawić liczby na pozycji %d-%d\n", i, j);
  end if;
end method setNumberAt;

define method unsetNumberAt(g :: <game>, i :: <integer>, j :: <integer>)
  let position = vector(i,j);
  if (member?(position,g.game-positions, test: equalVectors))
    format-out("Usuwam liczbę z pozycji %d-%d\n", i, j);
    g.game-board[i,j] := 0;
  else
    format-out("Nie można usunąć liczby z pozycji %d-%d\n", i, j);
  end if;
end method unsetNumberAt;

define method checkGame(g :: <game>)
  checkRows(g) & checkCols(g) & checkSquares(g)
end method checkGame;

define method byRows(g :: <game>, i :: <integer>, j :: <integer>)
  g.game-board[i,j]
end method byRows;

define method byCols(g :: <game>, i :: <integer>, j :: <integer>)
  g.game-board[j,i]
end method byCols;

define method checkLines(g :: <game>, fn :: <function>)
  let result = #t;
  block (break)
    for (i from 0 to 8)
      for (n from 1 to 9)
        let hasN = #f;
        block (break)
          for (j from 0 to 8)
            if (n = fn(g,i,j))
              hasN := #t;
              break();
            end if;
          end for;
        end block;
        if (~hasN)
          result := #f;
          break();
        end if;
      end for;
    end for;
  end block;
  result
end method checkLines;

define method checkRows(g :: <game>)
  checkLines(g,byRows)
end method checkRows;

define method checkCols(g :: <game>)
  checkLines(g,byCols)
end method checkCols;

define method checkSquares(g)
  let result = #t;
  block (break)
    for (i from 0 to 6 by 3)
      for (j from 0 to 6 by 3)
        for (n from 1 to 9)
          let hasN = #f;
          block (break)
            for (k from i to i + 2)
              for (l from j to j + 2)
                if (n = g.game-board[k,l])
                  hasN := #t;
                  break();
                end if;
              end for;
            end for;
          end block;
          if (~hasN)
            result := #f;
            break();
          end if;
        end for;
      end for;      
    end for;
  end block;
  result
end method checkSquares;

define method line()
  format-out("-------------------\n");
end method line;

define function main(name :: <string>, arguments :: <vector>)

  format-out("\n\n");
  
  let g = make(<game>);
  
  // Ustaw losową planszę
  g.randomMap;
  
  // Usuń liczby
  g.puzzle;
  
  // Pokaż planszę
  g.show;
  
  for (row from 0 to 8)
    for (col from 0 to 8)
      setNumberAt(g,8,row,col);
    end for
  end for;
  
  unsetNumberAt(g,8,8);
  
  g.show;
  
  //if (checkGame(g))
  //  format-out("Zwycięstwo\n");
  //else
  //  format-out("Przegrana\n");
  //end if;
  
  exit-application(0);
  
end function main;

define method createBoard(g :: <game>)

  let b = make(<array>, dimensions: #[9,9]);

  // Row 1
  b[0,0] := 8; b[0,1] := 2; b[0,2] := 7;
  b[0,3] := 1; b[0,4] := 5; b[0,5] := 4;
  b[0,6] := 3; b[0,7] := 9; b[0,8] := 6;
  
  // Row 2
  b[1,0] := 9; b[1,1] := 6; b[1,2] := 5;
  b[1,3] := 3; b[1,4] := 2; b[1,5] := 7;
  b[1,6] := 1; b[1,7] := 4; b[1,8] := 8;
  
  // Row 3
  b[2,0] := 3; b[2,1] := 4; b[2,2] := 1;
  b[2,3] := 6; b[2,4] := 8; b[2,5] := 9;
  b[2,6] := 7; b[2,7] := 5; b[2,8] := 2;
  
  // Row 4
  b[3,0] := 5; b[3,1] := 9; b[3,2] := 3;
  b[3,3] := 4; b[3,4] := 6; b[3,5] := 8;
  b[3,6] := 2; b[3,7] := 7; b[3,8] := 1;
  
  // Row 5
  b[4,0] := 4; b[4,1] := 7; b[4,2] := 2;
  b[4,3] := 5; b[4,4] := 1; b[4,5] := 3;
  b[4,6] := 6; b[4,7] := 8; b[4,8] := 9;
  
  // Row 6
  b[5,0] := 6; b[5,1] := 1; b[5,2] := 8;
  b[5,3] := 9; b[5,4] := 7; b[5,5] := 2;
  b[5,6] := 4; b[5,7] := 3; b[5,8] := 5;
  
  // Row 7
  b[6,0] := 7; b[6,1] := 8; b[6,2] := 6;
  b[6,3] := 2; b[6,4] := 3; b[6,5] := 5;
  b[6,6] := 9; b[6,7] := 1; b[6,8] := 4;
  
  // Row 8
  b[7,0] := 1; b[7,1] := 5; b[7,2] := 4;
  b[7,3] := 7; b[7,4] := 9; b[7,5] := 6;
  b[7,6] := 8; b[7,7] := 2; b[7,8] := 3;
  
  // Row 9
  b[8,0] := 2; b[8,1] := 3; b[8,2] := 9;
  b[8,3] := 8; b[8,4] := 4; b[8,5] := 1;
  b[8,6] := 5; b[8,7] := 6; b[8,8] := 7;
  
  g.game-board := b;
  
end method createBoard;

define method createMaps(g :: <game>)
  g.game-maps := #[#[5,6,9,7,2,4,3,1,8],#[4,3,5,2,6,9,1,7,8]];
end method createMaps;

main(application-name(), application-arguments());
