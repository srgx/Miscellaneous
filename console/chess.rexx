#!/usr/bin/rexx

/* Szachy */

call main

exit 0

main: procedure expose plansza.
  
  call nowaPlansza
  
  call wykonajRuch 1, 1, 1, 4
  
  /*
  call przesunFigure 1, 1, 3, 3
  call przesunFigure 3, 3, 5, 5
  call przesunFigure 1, 2, 6, 6
  */
  
  call pokazPlansze
  
  return
  
nowaPlansza: procedure expose plansza.

  plansza. = ''
  
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
  
pokazPlansze: procedure expose plansza.

  /* Czy pokazywać tło? */
  tlo = 0
  
  say 'X|AA|BB|CC|DD|EE|FF|GG|HH|'
  
  do i=1 to 8
  
    call charout ,wiersz(i)''
  
    do j=1 to 8
    
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
        
      if j = 8 then
        call charout ,'|'
        
    end
    
    say ''
    
  end
  
  return
  
  
litera: procedure
  arg n
  litery.1 = 'A' ; litery.2 = 'B' ; litery.3 = 'C' ; litery.4 = 'D'
  litery.5 = 'E' ; litery.6 = 'F' ; litery.7 = 'G' ; litery.8 = 'H'
  return litery.n
  return
  
wiersz: procedure
  arg n
  return 9 - n
  return
  
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
  return clean
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
  return clean
  return
  
wykonajRuch: procedure expose plansza.

  arg rowFrom, colFrom, rowTo, colTo
  
  figura = plansza.rowFrom.colFrom.name
  kolor = plansza.rowFrom.colFrom.color
  
  skok = 'Wieża nie może przeskakiwać ponad figurami'
  niebij = 'Nie można bić własnych figur'
  bij = 'Bicie figury'
  
  select
  
    when figura = 'Wieża' then
    
      /* Ruch w poziomie */
      if rowFrom = rowTo then
        do
          call ustawStartStop colFrom, colTo
          if sprawdzSciezkePoziomo(start, stop, rowFrom) then
            do
              if plansza.rowFrom.stop.name = 'Puste' then
                call przesunFigure rowFrom, colFrom, rowTo, colTo
              else if plansza.rowFrom.stop.color = kolor then
                say niebij
              else
                do
                  say bij
                  call przesunFigure rowFrom, colFrom, rowTo, colTo
                end
            end
          else
            say skok
        end
      
      /* Ruch w pionie */
      else if colFrom = colTo then
        do
          call ustawStartStop rowFrom, rowTo
          if sprawdzSciezkePionowo(start, stop, colFrom) then
            do
              if plansza.stop.colFrom.name = 'Puste' then
                call przesunFigure rowFrom, colFrom, rowTo, colTo
              else if plansza.stop.colFrom.color = kolor then
                say niebij
              else
                do
                  say bij
                  call przesunFigure rowFrom, colFrom, rowTo, colTo
                end
            end
          else
            say skok
        end
      else
        say 'Nieprawidłowy ruch'
    
    when figura = 'Koń' then
      say 'Skoczek'
    
    when figura = 'Goniec' then
      say 'Laufer'
      
    when figura = 'Królowa' then
      say 'Hetman'
      
    when figura = 'Król' then
      say 'Szach'
      
    when figura = 'Pionek' then
      say 'Pion'
      
    otherwise
      say figura
      say 'Nieprawidłowa figura'
  end
  
 
  return
  
przesunFigure: procedure expose plansza.

  arg rowFrom, colFrom, rowTo, colTo
  
  n = plansza.rowFrom.colFrom.name ; c = plansza.rowFrom.colFrom.color
  
  say 'Przesuwam' odmienKolor(n,c) odmienFigure(n),
      'z pozycji' litera(colFrom)'-'wiersz(rowFrom),
      'na pozycję' litera(colTo)'-'wiersz(rowTo)
  
  /* Przesuń figurę w nowe miejsce */
  plansza.rowTo.colTo.name = n
  plansza.rowTo.colTo.color = c
  
  /* Stare miejsce jest puste */
  plansza.rowFrom.colFrom.name = 'Puste'
  plansza.rowFrom.colFrom.color = ''
  
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
