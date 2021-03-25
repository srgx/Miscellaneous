#!/usr/bin/rexx

/* Szachy */

call main

exit 0

/* --------------------------------------------------------------------------------------------- */

main: procedure expose litery.
  
  call ustawLitery
  call nowaPlansza
  
  say 'Tura' gracz
  call wykonajRuch 'D', 2, 'D', 4
  call pokazPlansze 'B'
  
  say 'Tura' gracz
  call wykonajRuch 'C', 7, 'C', 6
  call pokazPlansze 'B'
  
  say 'Tura' gracz
  call wykonajRuch 'B', 1, 'A', 3
  call pokazPlansze 'B'
  
  say 'Tura' gracz
  call wykonajRuch 'G', 7, 'G', 5
  call pokazPlansze 'B'
  
  say 'Tura' gracz
  call wykonajRuch 'C', 1, 'E', 3
  call pokazPlansze 'B'
  
  return
  
/* --------------------------------------------------------------------------------------------- */
  
wykonajRuch: procedure expose plansza. gracz litery.

  arg colFrom, rowFrom, colTo, rowTo
  
  rowFrom = wiersz(rowFrom) ; rowTo = wiersz(rowTo)
  colFrom = kolumna(colFrom) ; colTo = kolumna(colTo)
  
  k = plansza.rowFrom.colFrom.color
  
  if k = '' then
    say 'Pole puste'
  else if k \= gracz then
    say 'Tura przeciwnika'
  else do
  
    figura = plansza.rowFrom.colFrom.name
  
    select
      when figura = 'Wieża' then
        call ruchWiezy rowFrom, colFrom, rowTo, colTo
      when figura = 'Koń' then
        call ruchKonia rowFrom, colFrom, rowTo, colTo
      when figura = 'Goniec' then
        call ruchGonca rowFrom, colFrom, rowTo, colTo
      when figura = 'Królowa' then
        call ruchKrolowej rowFrom, colFrom, rowTo, colTo
      when figura = 'Król' then
        call ruchKrola rowFrom, colFrom, rowTo, colTo
      when figura = 'Pionek' then
        call ruchPionka rowFrom, colFrom, rowTo, colTo
      otherwise
        say figura
        say 'Nieprawidłowa figura'
    end
    
  end
  
  return
  
/* Przesuń figurę jeśli to możliwe */
/* Przełącz turę na kolejnego gracza */
przesunFigure: procedure expose plansza. gracz litery.

  arg rowFrom, colFrom, rowTo, colTo
  
  n = plansza.rowFrom.colFrom.name
  c1 = plansza.rowFrom.colFrom.color
  c2 = plansza.rowTo.colTo.color
  
  if n = 'Pionek'  then do
    if colTo = colFrom then do
      if c2 \= '' then do
        say 'Pole przed pionkiem zajęte'
        return
      end
    end
    else if c2 = '' then do
      say 'Pionek nie może poruszać się na ukos bez bicia'
      return
    end
  end
    
    
  if c1 = c2 then
    say 'Nie można bić własnych figur'
  else do
  
    say 'Przesuwam' odmienKolor(n,c1) odmienFigure(n),
        'z pozycji' litera(colFrom)'-'wiersz(rowFrom),
        'na pozycję' litera(colTo)'-'wiersz(rowTo)
        
    if c2 \= '' then
      say 'Bicie'

    /* Przesuń figurę w nowe miejsce */
    plansza.rowTo.colTo.name = n
    plansza.rowTo.colTo.color = c1
    
    /* Stare miejsce jest puste */
    plansza.rowFrom.colFrom.name = 'Puste'
    plansza.rowFrom.colFrom.color = ''

    call nastepnyGracz
    
  end
  
  return
  
nastepnyGracz: procedure expose gracz
  select
    when gracz = 'B' then
      gracz = 'C'
    when gracz = 'C' then
      gracz = 'B'
    otherwise
      say 'Błąd stanu gracza'
      say gracz
  end
  return
  
/* --------------------------------------------------------------------------------------------- */
  
ruchWiezy: procedure
  arg rowFrom, colFrom, rowTo, colTo
  call sprawdzRuchWiezy rowFrom, colFrom, rowTo, colTo
  select
    when result = 0 then
      say 'Nieprawidłowy ruch wieży'
    when result = 1 then
      call przesunFigure rowFrom, colFrom, rowTo, colTo
    when result = 'blad_skok' then
      say 'Wieża nie może skakać nad innymi figurami'
    otherwise
      say 'Nieprawidłowa wartość zwrócona z funkcji 'sprawdzRuchWiezy''
  end
  return
  
ruchKonia: procedure expose plansza. gracz litery.
  arg rowFrom, colFrom, rowTo, colTo
  call sprawdzRuchKonia rowFrom, colFrom, rowTo, colTo
  if result then
    call przesunFigure rowFrom, colFrom, rowTo, colTo
  else
    say 'Nieprawidłowy ruch konia'
  return
  
ruchGonca: procedure expose plansza. gracz litery.
  arg rowFrom, colFrom, rowTo, colTo
  call sprawdzRuchGonca rowFrom, colFrom, rowTo, colTo
  select
    when result = 0 then
      say 'Nieprawidłowy ruch gońca'
    when result = 1 then
      call przesunFigure rowFrom, colFrom, rowTo, colTo
    when result = 'blad_skok' then
      say 'Goniec nie może skakać nad innymi figurami'
    otherwise
      say 'Nieprawidłowa wartość zwrócona z funkcji 'sprawdzRuchGonca''
  end
  return
  
ruchKrolowej: procedure expose plansza. gracz litery.
  arg rowFrom, colFrom, rowTo, colTo
  if result then
    call przesunFigure rowFrom, colFrom, rowTo, colTo
  else
    say 'Nieprawidłowy ruch królowej'
  return
  return
  
ruchKrola: procedure expose plansza. litery.
  arg rowFrom, colFrom, rowTo, colTo
  call sprawdzRuchKrola rowFrom, colFrom, rowTo, colTo
  if result then
    call przesunFigure rowFrom, colFrom, rowTo, colTo
  else
    say 'Nieprawidłowy ruch króla'
  return
  
ruchPionka: procedure expose plansza. gracz litery.
  arg rowFrom, colFrom, rowTo, colTo
  call sprawdzRuchPionka rowFrom, colFrom, rowTo, colTo
  if result then
    call przesunFigure rowFrom, colFrom, rowTo, colTo
  else
    say 'Nieprawidłowy ruch pionka'
  return
  
/* --------------------------------------------------------------------------------------------- */

sprawdzRuchWiezy: procedure expose plansza.
  arg rowFrom, colFrom, rowTo, colTo
  if rowFrom = rowTo then do
    call ustawStartStop colFrom, colTo
    return sprawdzSciezkePoziomo(start, stop, rowFrom)
    end
  else if colFrom = colTo then do
    call ustawStartStop rowFrom, rowTo
    return sprawdzSciezkePionowo(start, stop, colFrom)
    end
  else
    return 0
  return
    
sprawdzRuchKonia: procedure
  arg rowFrom, colFrom, rowTo, colTo
  return ((rowTo = rowFrom - 2 | rowTo = rowFrom + 2) & (colTo = colFrom - 1 | colTo = colFrom + 1)) |,
         ((rowTo = rowFrom - 1 | rowTo = rowFrom + 1) & (colTo = colFrom - 2 | colTo = colFrom + 2))
  return
  
sprawdzRuchGonca: procedure expose plansza.

  arg rowFrom, colFrom, rowTo, colTo

  p = 'Puste' ; s = 'blad_skok'

  if rowTo > rowFrom then do
    
    /* W dół w prawo */
    if colFrom < colTo then do
      row = rowFrom + 1 ; col = colFrom + 1
      do while row < rowTo & col < colTo
        if plansza.row.col \= p then
          return s
        else do
          row = row + 1 ; col = col + 1
        end
      end
      return row = rowTo & col = colTo
    end
    
    /* W dół w lewo */
    else if colFrom > colTo then do
    
      row = rowFrom + 1 ; col = colFrom - 1
      do while row < rowTo & col > colTo
        if plansza.row.col \= p then
          return s
        else do
          row = row + 1 ; col = col - 1
        end
      end
      return row = rowTo & col = colTo
    end
      
    else
      return 0
      
    end
    
  else if rowTo < rowFrom then do
    
    /* W górę w prawo */
    if colFrom < colTo then do
      row = rowFrom - 1 ; col = colFrom + 1
      do while row > rowTo & col < colTo
        if plansza.row.col.name \= p then
          return s
        else do
          row = row - 1 ; col = col + 1
        end
      end
      return row = rowTo & col = colTo
    end
    
    /* W górę w lewo */
    else if colFrom > colTo then do
      row = rowFrom - 1 ; col = colFrom - 1
      do while row > rowTo & col > colTo
        if plansza.row.col \= p then
          return s
        else do
          row = row - 1 ; col = col - 1
        end
      end
      return row = rowTo & col = colTo
    end
      
    else
      return 0
      
  end
    
  else
    return 0
    
  return
  
sprawdzRuchKrolowej: procedure expose plansza.
  arg rowFrom, colFrom, rowTo, colTo
  return sprawdzRuchWiezy(rowFrom, colFrom, rowTo, colTo) |,
         sprawdzRuchGonca(rowFrom, colFrom, rowTo, colTo)
  return
  
sprawdzRuchKrola: procedure
  arg rowFrom, colFrom, rowTo, colTo
  return (rowTo = rowFrom | rowTo = rowFrom + 1 | rowTo = rowFrom - 1) &,
         (colTo = colFrom | colTo = colFrom + 1 | colTo = colFrom - 1)
  return
  
sprawdzRuchPionka: procedure expose plansza.
  arg rowFrom, colFrom, rowTo, colTo
  c = plansza.rowFrom.colFrom.color
  return (c = 'C' &,
          ((rowFrom = 2 & rowTo = 4 & colFrom = colTo) |,
           (rowTo = rowFrom + 1) & (colTo = colFrom | colTo = colFrom - 1 | colTo = colFrom + 1))) |,
         (c = 'B' &,
          ((rowFrom = 7 & rowTo = 5 & colFrom = colTo) |,
           (rowTo = rowFrom - 1) & (colTo = colFrom | colTo = colFrom - 1 | colTo = colFrom + 1)))
  return
  
/* --------------------------------------------------------------------------------------------- */

/* Ustaw wartości tak żeby start był mniejszy niż stop */
ustawStartStop: procedure expose start stop
  arg from, to
  if from < to then
    do
      start = from
      stop = to
    end
  else
    do
      start = to
      stop = from
    end
  return
  
sprawdzSciezkePoziomo: procedure expose plansza
  arg start, stop, row
  clean = 1
  do i=start+1 to stop-1
    if plansza.row.i.name \= 'Puste' then
      do
        clean = 0
        leave
      end
  end
  call sprawdzSkok
  return result
  return
  
sprawdzSciezkePionowo: procedure expose plansza
  arg start, stop, col
  clean = 1
  do i=start+1 to stop-1
    if plansza.i.col.name \= 'Puste' then
      do
        clean = 0
        leave
      end
  end
  call sprawdzSkok
  return result  
  return
  
sprawdzSkok: procedure expose clean
  if clean then
    return clean
  else
    return 'blad_skok'
  return
  
/* --------------------------------------------------------------------------------------------- */

nowaPlansza: procedure expose plansza. gracz

  plansza. = ''
  
  /* Zaczyna biały gracz */
  gracz = 'B'
  
  /* Nazwy figur */
  w = 'Wieża' ; k = 'Koń' ; g = 'Goniec'
  figury.1 = w ; figury.2 = k ; figury.3 = g ; figury.4 = 'Królowa'
  figury.5 = 'Król' ; figury.6 = g ; figury.7 = k ; figury.8 = w
  
  do row = 1 to 8
  
    /* Kolory pól */
    /* W parzystym rzędzie parzysta kolumna jest biała */
    /* W nieparzystym rzędzie nieparzysta kolumna jest biała */
    if row // 2 = 0 then
      do col = 1 to 8
        if col // 2 = 0 then
          plansza.row.col.bg = 'B'
        else
          plansza.row.col.bg = 'C'
      end
    else
      do col = 1 to 8
        if col // 2 = 0 then
          plansza.row.col.bg = 'C'
        else
          plansza.row.col.bg = 'B'
      end
  
    /* Figury */
    select
      when row = 1 then
        do col=1 to 8
          plansza.row.col.name = figury.col
          plansza.row.col.color = 'C'
        end
      when row = 2 then
        do col=1 to 8
          plansza.row.col.name = 'Pionek'
          plansza.row.col.color = 'C'
        end
      when row = 7 then
        do col=1 to 8
          plansza.row.col.name = 'Pionek'
          plansza.row.col.color = 'B'
        end
      when row = 8 then
        do col=1 to 8
          plansza.row.col.name = figury.col
          plansza.row.col.color = 'B'
        end
      otherwise
        do col=1 to 8
          plansza.row.col.name = 'Puste'
        end
    end
      
  end

  return
  
ustawLitery: procedure expose litery.
  litery. = ''
  litery.1 = 'A' ; litery.2 = 'B' ; litery.3 = 'C' ; litery.4 = 'D'
  litery.5 = 'E' ; litery.6 = 'F' ; litery.7 = 'G' ; litery.8 = 'H'
  return
    
/* --------------------------------------------------------------------------------------------- */
  
/* Wyświetlane symbole figur */
symbol: procedure
  parse arg f
  select
    when f = 'Wieża' then
      return 'W'
    when f = 'Pionek' then
      return 'P'
    when f = 'Goniec' then
      return 'G'
    when f = 'Koń' then
      return 'H'
    when f = 'Królowa' then
      return 'Q'
    when f = 'Król' then
      return 'K'
    when f = 'Puste' then
      return '  '
    otherwise
      return 'ERROR'
  end
  return
  
/* Pokaż planszę z perspektywy białego lub czarnego gracza (C lub B) */
pokazPlansze: procedure expose plansza.

  arg perspektywa

  /* Czy pokazywać tło? */
  tlo = 0
  
  incr = 0 ; start = 0 ; stop = 0
  
  call linia
  
  select
    when perspektywa = 'B' then do
      say 'X|AA|BB|CC|DD|EE|FF|GG|HH|'
      incr = 1
      start = 1
      stop = 8
      end
    when perspektywa = 'C' then do
      say 'X|HH|GG|FF|EE|DD|CC|BB|AA|'
      incr = -1
      start = 8
      stop = 1
      end
    otherwise
      say 'Nieprawidłowy parametr'
      return
  end
  
  do i=start to stop by incr
  
    call charout ,wiersz(i)''
  
    do j=start to stop by incr
    
      call charout ,'|'
      
      /* Symbol figury */
      call charout ,symbol(plansza.i.j.name)
      
      /* Kolor figury */
      if plansza.i.j.name \= 'Puste' then
        call charout ,plansza.i.j.color
        
      /* Tło pola */
      if tlo then
        do
          call charout ,'-'
          call charout ,plansza.i.j.bg
        end
        
      if j = stop then
        call charout ,'|'
        
    end
    
    say ''
    
  end
  
  call linia
  
  return
  
linia: procedure
  say '--------------------------'
  return
  
/* --------------------------------------------------------------------------------------------- */

/* Zwraca znak na podstawie indeksu kolumny */
litera: procedure expose litery.
  arg n
  return litery.n
  return

/* Zwraca indeks kolumny na podstawie znaku  */
kolumna: procedure expose litery.
  arg p
  i = 1
  do while litery.i \= ''
    if litery.i = p then
      return i
    i = i + 1
  end
  return

/* Mapowanie między wierszami w tablicy a wierszami na planszy */
wiersz: procedure
  arg n
  return 9 - n
  return
  
odmienFigure: procedure
  parse arg n
  select
    when n = 'Pionek' then
      return 'pionka'
    when n = 'Wieża' then
      return 'wieżę'
    when n = 'Koń' then
      return 'konia'
    when n = 'Goniec' then
      return 'gońca'
    when n = 'Król' then
      return 'króla'
    when n = 'Królowa' then
      return 'królową'
  end
  return
  
odmienKolor: procedure
  parse arg n, c
  select
    when c = 'C' then
      do
        if sprawdzPlec(n) then
          return 'czarnego'
        else
          return 'czarną'
      end
    when c = 'B' then
      do
        if sprawdzPlec(n) then
          return 'białego'
        else
          return 'białą'
      end
    otherwise
      say 'Error'
  end  
  return
  
/* Sprawdź czy to płeć męska */
sprawdzPlec: procedure
  parse arg n
  return n \= 'Królowa' & n \= 'Wieża'
  return
  
/* --------------------------------------------------------------------------------------------- */
