#!/usr/bin/tclsh

# Half-Life

set l2 [expr {log(2)}]
proc log2 {n} {
  global l2
  return [expr {log($n) / $l2}]
}

proc calculateRemainingMass {half_life initialMass years} {
  return [expr {$initialMass / 2**($years/$half_life)}]
}

proc calculateYearsPassed {half_life initialMass currentMass} {
  return [expr {[log2 [expr {$initialMass/$currentMass}]] * $half_life}]
}

proc calculate {half_life} {

  upvar initialMass initialMass
  upvar years years
  upvar remainingMass remainingMass

  puts "Half-life: $half_life years"
  puts "Initial mass: $initialMass kg"
  puts "Mass after $years years: [calculateRemainingMass $half_life $initialMass $years] kg"
  puts "Mass of $remainingMass kg after [calculateYearsPassed $half_life $initialMass 250.0] years"

}

proc line {} {
  puts -----------------------------------------------
}

proc main {} {

  set initialMass 1000.0
  set years 200.0
  set remainingMass 250.0

  set isotopes {{"Carbon 14" 5730} {"Strontium 90" 29} {"Uranium 238" 4.468e9}}

  line

  # Main loop
  foreach iso $isotopes {
    puts [lindex $iso 0]
    calculate [lindex $iso 1]
    line
  }

}


main

