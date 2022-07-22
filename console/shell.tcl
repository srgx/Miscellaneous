#!/usr/bin/tclsh

set shells {K L M N O P Q}
set orbitals {s p d f}

for {set i 1} {$i <= 3} {incr i} {

  puts "   *** [lindex $shells [expr {$i - 1}]] shell ***"

  for {set j 0} {$j < $i} {incr j} {

    puts "Orbital [lindex $orbitals $j]"

    for {set k -$j} {$k <= $j} {incr k} {

      # Get rid of -0
      scan $k %d k

      # Display data
      for {set l 0} {$l < 2} {incr l} {
        puts "n:$i, l:$j, m:$k, ms:[expr {0 == $l ? "-" : ""}]1/2"
      }

    }

  }

  puts ""

}


