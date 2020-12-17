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

tests


# -----------------------------------------------------------------------------

proc countPea {test1 test2 lst} {

  set total [llength $lst]

  set count 0
  for {set i 0} {$i < $total} {incr i} {
    set crnt [lindex $lst $i]
    if { [$test1 $crnt] && [$test2 $crnt] } { incr count }
  }
  
  return $count
  
}

proc isYellow {a} {
  return [expr {"A" in $a}]
}

proc isGreen {a} {
  return [expr {![isYellow $a]}]
}

proc isPlain {a} {
  return [expr {"B" in $a}]
}

proc isWrink {a} {
  return [expr {![isPlain $a]}]
}

proc getR {} {
  set v [expr rand()]  
  return [expr {$v > 0.5 ? 1 : 0}]
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

proc countAinB {a b} {
  set c 0
  set l [llength $b]
  for {set i 0} {$i < $l} {incr i} {
    if {$a in [lindex $b $i]} {
      incr c
    }
  }
  return $c
}

# 10 tysięcy
set total 1e4

set a "A A"
set b "a a"

# Pierwsze pokolenie
set f1 []
for {set i 0} {$i < $total} {incr i} { lappend f1 [genPea $a $b] }

set red [countAinB "A" $f1]
puts "W pierwszym pokoleniu [format {%0.2f}\
[expr {$red/$total*100}]]% czerwonych groszków"

# Dwa organizmy z pierwszego pokolenia
set c [lindex $f1 0] ; # Aa
set d [lindex $f1 1] ; # Aa

# Drugie pokolenie
set f2 []
for {set i 0} {$i < $total} {incr i} { lappend f2 [genPea $c $d] }

set red [countAinB "A" $f2]
puts "W drugim pokoleniu [format {%0.2f}\
[expr {$red/$total*100}]]% czerwonych groszków"

# -----------------------------------------------------------------------------
puts "----------------------------------------------------"


set a "A A B B"
set b "a a b b"

#puts [genPea $a $b]

# Pierwsze pokolenie
set f1 []
for {set i 0} {$i < $total} {incr i} { lappend f1 [genPea $a $b] }

set cnt [countPea isYellow isPlain $f1]

puts "W pierwszym pokoleniu [format {%0.2f}\
[expr {$cnt/$total*100}]]% żółtych i gładkich groszków"

# Dwa organizmy z pierwszego pokolenia
set c [lindex $f1 0] ; # AaBb
set d [lindex $f1 1] ; # AaBb

# Drugie pokolenie
set f2 []
for {set i 0} {$i < $total} {incr i} { lappend f2 [genPea $c $d] }

set cnt [countPea isYellow isPlain $f2]

puts "W drugim pokoleniu [format {%0.2f}\
[expr {$cnt/$total*100}]]% żółtych i gładkich groszków"

set cnt [countPea isYellow isWrink $f2]

puts "W drugim pokoleniu [format {%0.2f}\
[expr {$cnt/$total*100}]]% żółtych i pomarszczonych groszków"

set cnt [countPea isGreen isPlain $f2]

puts "W drugim pokoleniu [format {%0.2f}\
[expr {$cnt/$total*100}]]% zielonych i gładkich groszków"

set cnt [countPea isGreen isWrink $f2]

puts "W drugim pokoleniu [format {%0.2f}\
[expr {$cnt/$total*100}]]% zielonych i pomarszczonych groszków"


