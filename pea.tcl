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

  set gsize [llength [lindex $g1 0]]
  
  set len [llength $g1]
  
  set cmb []
  
  for {set i 0} {$i < $len} {incr i} {
    for {set j 0} {$j < $len} {incr j} {
      lappend cmb "[lindex $g1 $i] [lindex $g2 $j]"
    }
  }
  
  return $cmb
}

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

proc getR {} {
  set v [expr rand()]  
  return [expr {$v > 0.5 ? 1 : 0}]
}

proc gen {a b} {
  set al1 [lindex $a [getR]]
  set al2 [lindex $b [getR]]
  return "$al1 $al2"
}

proc countRed {a} {
  set countA 0
  set l [llength $a]
  for {set i 0} {$i < $l} {incr i} {
    if {"A" in [lindex $a $i]} {
      incr countA
    }
  }
  return $countA
}

# 10 tysięcy
set total 1e4

set a "A A"
set b "a a"

# Pierwsze pokolenie
set f1 []
for {set i 0} {$i < $total} {incr i} { lappend f1 [gen $a $b] }

set countA [countRed $f1]
puts "W pierwszym pokoleniu [format {%0.2f}\
[expr {$countA/$total*100}]]% czerwonych groszków"

# Dwa organizmy z pierwszego pokolenia
set c [lindex $f1 0] ; # Aa
set d [lindex $f1 1] ; # Aa

# Drugie pokolenie
set f2 []
for {set i 0} {$i < $total} {incr i} { lappend f2 [gen $c $d] }

set countA [countRed $f2]
puts "W drugim pokoleniu [format {%0.2f}\
[expr {$countA/$total*100}]]% czerwonych groszków"


