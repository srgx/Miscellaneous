#!/usr/bin/tclsh

# Estimate Pi

# ----------------------------------------------------------------------------

# Leibniz formula
# pi/4 = 1 - 1/3 + 1/5 - 1/7 + 1/9...
proc leibnizPi {} {

  set val 1.0 ; set den 3

  for {set i 0} {$i < 1e6} {incr i} {
    set val [expr {$val + (0 == $i % 2 ? -1.0 : 1.0) / $den}]
    incr den 2
  }

  puts "Leibniz: [expr {$val * 4}]"

}

# Monte Carlo method
proc monteCarloPi {} {

  set circleCenter {50 50}
  set radius 50
  set points 10000
  set inCircle 0
  set arr {0 0}

  for {set i 0} {$i < $points} {incr i} {

    for {set j 0} {$j < 2} {incr j} {
      lset arr $j [rnd 1 100]
    }

    set distance\
      [expr {sqrt(([lindex $arr 0] - [lindex $circleCenter 0])**2 +\
                  ([lindex $arr 1] - [lindex $circleCenter 1])**2)}]

    if {$distance < $radius} { incr inCircle }

  }

  puts "Monte Carlo: [expr {4.0 * $inCircle / $points}]"
  puts "Points inside circle: $inCircle"
  puts "Total points: $points"

}

# ----------------------------------------------------------------------------

proc rnd {min max} { expr {int(rand()*($max+1-$min))+$min} }

proc line {} {
  puts -----------------------------------
}

# ----------------------------------------------------------------------------

proc main {} {
  line
  leibnizPi
  line
  monteCarloPi
  line
}

# ----------------------------------------------------------------------------
main
# ----------------------------------------------------------------------------
