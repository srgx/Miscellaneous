proc gametes {pea} {

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

proc combineGametes {g1 g2} {
  
  set cmb []
  set len [llength $g1]
    
  for {set i 0} {$i < $len} {incr i} {
    for {set j 0} {$j < $len} {incr j} {
      lappend cmb "[lindex $g1 $i] [lindex $g2 $j]"
    }
  }
  
  return $cmb
}

# Wszystkie możliwe kombinacje z pary (a,b)
proc combinePea {a b} {

  set gametesA [gametes $a]
  set gametesB [gametes $b]
  
  return [combineGametes $gametesA $gametesB]
  
}

proc tests {} {

  set t []
  
  
  # Gamety
  
  lappend t [expr {[gametes "A A"]=="A"}]
  lappend t [expr {[gametes "A a"]=="A a"}]
  lappend t [expr {[gametes "A A B B"]=="{A B}"}]
  lappend t [expr {[gametes "a a b b"]=="{a b}"}]
  lappend t [expr {[gametes "A a B b"]=="{A B} {A b} {a B} {a b}"}]
  
  
  # Krzyżówki
  
  lappend t [expr {[combinePea "A A" "a a"]=="{A a}"}]
  lappend t [expr {[combinePea "A a" "A a"]=="{A A} {A a} {a A} {a a}"}]
  lappend t [expr {[combinePea "A A B B" "a a b b"]=="{A B a b}"}] 
  lappend t [expr {[combinePea "A a B b" "A a B b"]==
    "{A B A B} {A B A b} {A B a B} {A B a b}\
     {A b A B} {A b A b} {A b a B} {A b a b}\
     {a B A B} {a B A b} {a B a B} {a B a b}\
     {a b A B} {a b A b} {a b a B} {a b a b}"}]
 
 
 
  # Wyniki
  
  set p 0
  set l [llength $t]
  
  for {set i 0} {$i < $l} {incr i} {
    set p [expr {$p + [lindex $t $i]}]
  }
  
  puts $t
  puts "Testy: $p/$l"
  
}

proc getR {} {

  set v [expr rand()]  
  return [expr {$v > 0.5 ? 1 : 0}]
  
}

proc countL {test lst} {

  set total [llength $lst]
  set count 0
  
  for {set i 0} {$i < $total} {incr i} {
    set crnt [lindex $lst $i]
    if { [apply $test $crnt] } { incr count }
  }
  
  return $count
  
}


# Nowy losowy groszek z pary (a,b)
proc genPea {a b} {

  set pairs [expr {[llength $a]/2}]
  set newPea []
  
  for {set i 0} {$i < $pairs} {incr i} {
    set fromA [lindex $a [expr {[getR]+(2*$i)}]]
    set fromB [lindex $b [expr {[getR]+(2*$i)}]]
    lappend newPea $fromA
    lappend newPea $fromB
  }
    
  return $newPea
}

proc flower {total} {

  puts "A - czerwone, a - białe"

  set a "A A"
  set b "a a"

  # Pierwsze pokolenie
  set f1 []
  for {set i 0} {$i < $total} {incr i} { lappend f1 [genPea $a $b] }

  set red [countL {{ x }
    { return [expr {"A" in $x}] }} $f1]
    
  puts "Pokolenie 1"
  puts "[format {%0.2f} [expr {$red/$total*100}]]% czerwonych groszków"

  # Dwa organizmy z pierwszego pokolenia
  set c [lindex $f1 0] ; # Aa
  set d [lindex $f1 1] ; # Aa

  # Drugie pokolenie
  set f2 []
  for {set i 0} {$i < $total} {incr i} { lappend f2 [genPea $c $d] }

  set red [countL {{ x }
    { return [expr {"A" in $x}] }} $f2]
    
  puts "Pokolenie 2"
  puts "[format {%0.2f} [expr {$red/$total*100}]]% czerwonych groszków"
  
}

proc seed {total} {

  puts "A - żółte, a - zielone, B - gładkie, b - pomarszczone"

  set a "A A B B"
  set b "a a b b"

  # Pierwsze pokolenie
  set f1 []
  for {set i 0} {$i < $total} {incr i} { lappend f1 [genPea $a $b] }

  set cnt [countL {{ x }
    { return [expr {"A" in $x && "B" in $x}] }} $f1]
    
  puts "Pokolenie 1"
  puts "[format {%0.2f} [expr {$cnt/$total*100}]]% żółtych i gładkich groszków"

  # Dwa organizmy z pierwszego pokolenia
  set c [lindex $f1 0] ; # AaBb
  set d [lindex $f1 1] ; # AaBb

  # Drugie pokolenie
  set f2 []
  for {set i 0} {$i < $total} {incr i} { lappend f2 [genPea $c $d] }

  set cnt [countL {{ x }
    { return [expr {"A" in $x && "B" in $x}] }} $f2]
    
  puts "Pokolenie 2"
  puts "[format {%0.2f} [expr {$cnt/$total*100}]]% żółtych i gładkich groszków"

  set cnt [countL {{ x }
    { return [expr {"A" in $x && !("B" in $x)}] }} $f2]

  puts "[format {%0.2f} [expr {$cnt/$total*100}]]% żółtych i pomarszczonych groszków"

  set cnt [countL {{ x }
    { return [expr {!("A" in $x) && "B" in $x}] }} $f2]

  puts "[format {%0.2f} [expr {$cnt/$total*100}]]% zielonych i gładkich groszków"

  set cnt [countL {{ x }
    { return [expr {!("A" in $x) && !("B" in $x)}] }} $f2]

  puts "[format {%0.2f} [expr {$cnt/$total*100}]]% zielonych i pomarszczonych groszków"
  
}

proc line {} {
  for {set i 0} {$i < 60} {incr i} {
    puts -nonewline "-"
  }
}

proc main {} {

  set n 1e4
  
  tests
  line
  puts ""
  flower $n
  line
  puts ""
  seed $n

}

main




