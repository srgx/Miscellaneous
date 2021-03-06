#!/usr/bin/tclsh

oo::class create Program {

  constructor {} {
  
    variable from "5 5"
    variable to "9 9"
    variable totalTime 200.
    variable currentTime 0
    variable totalDisplacement [my subtractVectors]
    variable proportion
    
  }
  
  method subtractVectors {} {
  
    variable from
    variable to
  
    return "[expr {[lindex $to 0] - [lindex $from 0]}]\
            [expr {[lindex $to 1] - [lindex $from 1]}]"
  }
  
  method scaleVector {} {
  
    variable proportion
    variable totalDisplacement
    
    return "[expr {[lindex $totalDisplacement 0] * $proportion}]\
            [expr {[lindex $totalDisplacement 1] * $proportion}]"
            
  }

  method positionAfterTime {} {
  
    variable currentTime
    variable totalTime
    variable proportion
    
    set proportion [expr {$currentTime / $totalTime}]
    
    return [my scaleVector]
  
  }
  
  method update {} {
    
    variable currentTime
  
    set displacement [my positionAfterTime]
    
    puts "Displacement after $currentTime seconds:\
          ([lindex $displacement 0],[lindex $displacement 1])"
    
    if {$currentTime < 200} { set currentTime [expr {$currentTime + 50}] }
    
  }
  
}


set program [Program new]
for {set i 0} {$i < 5} {incr i} { $program update }

