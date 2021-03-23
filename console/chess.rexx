#!/usr/bin/rexx

/* Szachy */

call main

exit 0

main: procedure expose plansza.
  
  call nowaPlansza
  
  say 'Tura' gracz
  
  call wykonajRuch 'G', 1, 'H', 3
  
  say 'Tura' gracz
  
  call wykonajRuch 'B', 8, 'A', 6
  
  say 'Tura' gracz
  
  call linia
  call pokazPlansze 'B'
  call linia
  call pokazPlansze 'C'
  call linia
  
  return
  
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
  
  
nastepnyGracz: procedure expose gracz
  select
    when gracz = 'B' then
      gracz = 'C'
    when gracz = 'C' then
      gracz = 'B'
    otherwise
      say 'Błąd stanu gracza'
  end
  return
  
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
  

/* Pokaż planszę z perspektywy białego lub czarnego gracza */
pokazPlansze: procedure expose plansza.

  arg perspektywa

  /* Czy pokazywać tło? */
  tlo = 0
  
  incr = 0 ; start = 0 ; stop = 0
  
  select
    when perspektywa = 'B' then do
      incr = 1
      start = 1
      stop = 8
      end
    when perspektywa = 'C' then do
      incr = -1
      start = 8
      stop = 1
      end
    otherwise
      say 'Nieprawidłowy parametr'
      return
  end
  
  say 'X|AA|BB|CC|DD|EE|FF|GG|HH|'
  
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
  
  return
  
linia: procedure
  say '--------------------------'
  return
  

/* Symbole kolumn */
litera: procedure
  arg n
  litery.1 = 'A' ; litery.2 = 'B' ; litery.3 = 'C' ; litery.4 = 'D'
  litery.5 = 'E' ; litery.6 = 'F' ; litery.7 = 'G' ; litery.8 = 'H'
  return litery.n
  return
  
kolumna: procedure
  arg p
  kolumny.A = 1 ; kolumny.B = 2 ; kolumny.C = 3 ; kolumny.D = 4 ;
  kolumny.E = 5 ; kolumny.F = 6 ; kolumny.G = 7 ; kolumny.H = 8 ;
  return kolumny.p
  return
  
/* Numery wierszy */
wiersz: procedure
  arg n
  return 9 - n
  return
  
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
  
sprawdzSkok: procedure expose clean
  if clean then
    return clean
  else
    return 'blad_skok'
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
  
sprawdzRuchWiezy: procedure expose plansza.

  arg rowFrom, colFrom, rowTo, colTo

  /* Ruch w poziomie */
  if rowFrom = rowTo then do
    call ustawStartStop colFrom, colTo
    return sprawdzSciezkePoziomo(start, stop, rowFrom)
    end
  
  /* Ruch w pionie */
  else if colFrom = colTo then do
    call ustawStartStop rowFrom, rowTo
    return sprawdzSciezkePionowo(start, stop, colFrom)
    end
    
  else
    return 0
    
  return
    
ostatniGoniec: procedure expose plansza. error row col

  arg rowFrom, colFrom, rowTo, colTo
  wynik = 0
  
  if error then
    say 'Goniec nie może skakać nad figurami'
  else do
    if row = rowTo & col = colTo then
      if plansza.rowTo.colTo.color \= plansza.rowFrom.colFrom.color then
        call przesunFigure rowFrom, colFrom, rowTo, colTo
      else
        say 'Nie można bić własnych figur'
    else
      say 'Nieprawidłowy ruch'
  end
    
  return wynik
  return
  
sprawdzRuchGonca: procedure expose plansza.

  arg rowFrom, colFrom, rowTo, colTo

  blad = 'Nieprawidłowy ruch'
  p = 'Puste'
  s = 'blad_skok'
  
  if rowTo > rowFrom then do
    
    /* W dół w prawo */
    if colFrom < colTo then do
      row = rowFrom + 1 ; col = colFrom + 1 ; error = 0
      do while row < rowTo & col < colTo
        if plansza.row.col \= p then do
          return s
          end
        else do
          row = row + 1 ; col = col + 1
        end
      end
      return row = rowTo & col = colTo
      end
    
    /* W dół w lewo */
    else if colFrom > colTo then do
    
      row = rowFrom + 1 ; col = colFrom - 1 ; error = 0
      do while row < rowTo & col < colTo
        if plansza.row.col \= p then do
          return s
          end
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
      row = rowFrom - 1 ; col = colFrom + 1 ; error = 0
      do while row < rowTo & col < colTo
        if plansza.row.col \= p then do
          return s
          end
        else do
          row = row - 1 ; col = col + 1
        end
      end
      return row = rowTo & col = colTo
      end
    
    /* W górę w lewo */
    else if colFrom > colTo then do
      row = rowFrom - 1 ; col = colFrom - 1 ; error = 0
      do while row < rowTo & col < colTo
        if plansza.row.col \= p then do
          return s
          end
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
  
sprawdzRuchKonia: procedure
  arg rowFrom, colFrom, rowTo, colTo
  return ((rowTo = rowFrom - 2 | rowTo = rowFrom + 2) & (colTo = colFrom - 1 | colTo = colFrom + 1)) |,
         ((rowTo = rowFrom - 1 | rowTo = rowFrom + 1) & (colTo = colFrom - 2 | colTo = colFrom + 2))
  return

  
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
  
ruchKonia: procedure expose plansza. gracz

  arg rowFrom, colFrom, rowTo, colTo
  
  call sprawdzRuchKonia rowFrom, colFrom, rowTo, colTo
  
  if result then
    call przesunFigure rowFrom, colFrom, rowTo, colTo
  else
    say 'Nieprawidłowy ruch konia'
    
  return
  
  
ruchGonca: procedure expose plansza.

  arg rowFrom, colFrom, rowTo, colTo
  
  call sprawdzRuchGonca rowFrom, colFrom, rowTo, colTo
  
  select
    when result = 0 then
      say 'Nieprawidłowy ruch gońca'
    when result = 1 then
      call przesunFigure rowFrom, colFrom, rowTo, colTo
    when result = 'blad_skok' then
      say 'Wieża nie może skakać nad innymi figurami'
    otherwise
      say 'Nieprawidłowa wartość zwrócona z funkcji 'sprawdzRuchGonca''
  end

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
  
ruchKrola: procedure expose plansza.

  arg rowFrom, colFrom, rowTo, colTo
  
  call sprawdzRuchKrola rowFrom, colFrom, rowTo, colTo
  
  if result then
    call przesunFigure rowFrom, colFrom, rowTo, colTo
  else
    say 'Nieprawidłowy ruch króla'
    
  return
  
ruchPionka: procedure expose plansza.
  arg rowFrom, colFrom, rowTo, colTo
  return
  
wykonajRuch: procedure expose plansza. gracz

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
        say 'Szach'
      when figura = 'Pionek' then
        say 'Pion'
      otherwise
        say figura
        say 'Nieprawidłowa figura'
    end
    
  end
  
  return
  
/* Przesuń figurę jeśli to możliwe */
/* Przełącz turę na kolejnego gracza */
przesunFigure: procedure expose plansza. gracz

  arg rowFrom, colFrom, rowTo, colTo
  
  n = plansza.rowFrom.colFrom.name
  c1 = plansza.rowFrom.colFrom.color
  c2 = plansza.rowTo.colTo.color
  
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
  
/* Sprawdź czy to płeć męska */
sprawdzPlec: procedure
  parse arg n
  return n \= 'Królowa' & n \= 'Wieża'
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
