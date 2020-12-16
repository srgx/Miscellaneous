
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
puts "W pierwszym pokoleniu [expr {$countA/$total*100}]% czerwonych groszków"

# Dwa organizmy z pierwszego pokolenia
set c [lindex $f1 0] ; # Aa
set d [lindex $f1 1] ; # Aa

# Drugie pokolenie
set f2 []
for {set i 0} {$i < $total} {incr i} { lappend f2 [gen $c $d] }

set countA [countRed $f2]
puts "W drugim pokoleniu [expr {$countA/$total*100}]% czerwonych groszków"


