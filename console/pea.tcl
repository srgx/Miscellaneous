#!/usr/bin/tclsh


oo::class create Program {

  constructor {} {
    # ---
  }
  
  method gametes {pea} {

    set len [llength $pea]
    set gms []
    
    switch $len {
    
      2 {
        for {set i 0} {$i < $len} {incr i} {
          if {!([lindex $pea $i] in $gms)} {
            lappend gms [lindex $pea $i]
          }
        }
      }
      
      4 {
        for {set i 0} {$i < 2} {incr i} {
          for {set j 2} {$j < $len} {incr j} {
            set cmb "[lindex $pea $i] [lindex $pea $j]"
            if {!($cmb in $gms)} {
              lappend gms $cmb
            }
          }
        }
      }
      
      default {
      
      }
      
    }
    
    return $gms
  
  }

  method combineGametes {g1 g2} {
    
    set cmb []
    set numGametes [llength $g1]
    set gameteLen [llength [lindex $g1 0]]
      
    for {set i 0} {$i < $numGametes} {incr i} {
      
      # Gameta z pierwszej listy
      set gam1 [lindex $g1 $i]
      
      for {set j 0} {$j < $numGametes} {incr j} {
      
        # Gameta z drugiej listy
        set gam2 [lindex $g2 $j]
        
        # Łączenie gamet w odpowiedniej kolejności
        # {A B} + {A B} -> {A A B B}
        set newc []
        for {set k 0} {$k < $gameteLen} {incr k} {
          lappend newc [lindex $gam1 $k] [lindex $gam2 $k]
        }
        
        lappend cmb $newc
        
      }
    }
    
    return $cmb
    
  }

  # Wszystkie możliwe kombinacje z pary (a,b)
  method combinePea {a b} {

    set gametesA [my gametes $a]
    set gametesB [my gametes $b]
    
    my combineGametes $gametesA $gametesB
    
  }

  method tests {} {

    set t []
    
    
    # Gamety
    
    lappend t\
      [expr {[my gametes "A A"]=="A"}]\
      [expr {[my gametes "A a"]=="A a"}]\
      [expr {[my gametes "A A B B"]=="{A B}"}]\
      [expr {[my gametes "a a b b"]=="{a b}"}]\
      [expr {[my gametes "A a B b"]=="{A B} {A b} {a B} {a b}"}]
    
    
    # Krzyżówki
    
    lappend t\
      [expr {[my combinePea "A A" "a a"]=="{A a}"}]\
      [expr {[my combinePea "A a" "A a"]=="{A A} {A a} {a A} {a a}"}]\
      [expr {[my combinePea "A A B B" "a a b b"]=="{A a B b}"}]\
      [expr {[my combinePea "A a B b" "A a B b"]==
        "{A A B B} {A A B b} {A a B B} {A a B b}\
        {A A b B} {A A b b} {A a b B} {A a b b}\
        {a A B B} {a A B b} {a a B B} {a a B b}\
        {a A b B} {a A b b} {a a b B} {a a b b}"}]

  
  
    # Wyniki
    
    set p 0
    set l [llength $t]
    
    for {set i 0} {$i < $l} {incr i} {
      set p [expr {$p + [lindex $t $i]}]
    }
    
    puts $t
    puts "Testy: $p/$l"
    
  }

  method getR {} {
    return [expr {rand() > 0.5 ? 1 : 0}]
  }

  method perc {value total} {
    expr {$value/$total*100}
  }

  method countL {test lst} {

    set total [llength $lst]
    set count 0
    
    for {set i 0} {$i < $total} {incr i} {
      if { [apply $test [lindex $lst $i]] } { incr count }
    }
    
    return $count
    
  }


  # Nowy losowy groszek z pary (a,b)
  method genPea {a b} {

    set pairs [expr {[llength $a]/2}]
    set newPea []
    
    for {set i 0} {$i < $pairs} {incr i} {
    
      lappend newPea\
        [lindex $a [expr {[my getR]+2*$i}]]\
        [lindex $b [expr {[my getR]+2*$i}]]
        
    }

    return $newPea
  }

  method flower {total} {

    puts "A - czerwone, a - białe"

    set a "A A"
    set b "a a"

    # Pierwsze pokolenie
    set f1 []
    for {set i 0} {$i < $total} {incr i} { lappend f1 [my genPea $a $b] }
      
    puts "Pokolenie 1"
    
    puts "[format {%0.2f} [my perc [my countL {{ x }
      { expr {"A" in $x} }} $f1] $total]]%\
      czerwonych groszków"

    # Dwa organizmy z pierwszego pokolenia
    set c [lindex $f1 0] ; # Aa
    set d [lindex $f1 1] ; # Aa

    # Drugie pokolenie
    set f2 []
    for {set i 0} {$i < $total} {incr i} { lappend f2 [my genPea $c $d] }
      
    puts "Pokolenie 2"
    
    puts "[format {%0.2f} [my perc [my countL {{ x }
      { expr {"A" in $x} }} $f2] $total]]%\
      czerwonych groszków"
    
  }

  method seed {total} {

    puts "A - żółte, a - zielone, B - gładkie, b - pomarszczone"

    set a "A A B B"
    set b "a a b b"

    # Pierwsze pokolenie
    set f1 []
    for {set i 0} {$i < $total} {incr i} { lappend f1 [my genPea $a $b] }

    puts "Pokolenie 1"
    
    puts "[format {%0.2f} [my perc [my countL {{ x }
      { expr {"A" in $x && "B" in $x} }} $f1] $total]]%\
      żółtych i gładkich groszków"

    # Dwa organizmy z pierwszego pokolenia
    set c [lindex $f1 0] ; # AaBb
    set d [lindex $f1 1] ; # AaBb

    # Drugie pokolenie
    set f2 []
    for {set i 0} {$i < $total} {incr i} { lappend f2 [my genPea $c $d] }
    
    puts "Pokolenie 2"
    
    puts "[format {%0.2f} [my perc [my countL {{ x }
      { expr {"A" in $x && "B" in $x} }} $f2] $total]]%\
      żółtych i gładkich groszków"

    puts "[format {%0.2f} [my perc [my countL {{ x }
      { expr {"A" in $x && !("B" in $x)} }} $f2] $total]]%\
      żółtych i pomarszczonych groszków"

    puts "[format {%0.2f} [my perc [my countL {{ x }
      { expr {!("A" in $x) && "B" in $x} }} $f2] $total]]%\
      zielonych i gładkich groszków"

    puts "[format {%0.2f} [my perc [my countL {{ x }
      { expr {!("A" in $x) && !("B" in $x)} }} $f2] $total]]%\
      zielonych i pomarszczonych groszków"
    
    
  }

  method line {} {
    for {set i 0} {$i < 60} {incr i} {
      puts -nonewline "-"
    }
  }

  method main {} {

    set n 1e4
    
    my tests
    my line
    puts ""
    my flower $n
    my line
    puts ""
    my seed $n

  }

  
}


[Program new] main




