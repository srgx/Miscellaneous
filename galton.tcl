proc every {ms body} {
  eval $body; after $ms [namespace code [info level 0]]
}

canvas .can
.can configure -width 854
.can configure -height 480

set diameter 10

set hDistance 15
set shift [expr {$hDistance/2}]
set vDistance 15

set rowX 200
set rowY 10

set rows 9

set targets {}

for {set i 0} {$i < $rows} {incr i} {

  set balls [expr {$i+1}]
  
  set currentX $rowX
  
  for {set j 0} {$j < $balls} {incr j} {
  
    # Create all balls
    if {$i!=$rows-1} {
    
      .can create oval $currentX $rowY [expr {$currentX+$diameter}] [expr {$rowY+$diameter}] -outline black -fill black -tag $i$j
      
    # In last row set list of target positions
    } else {
    
      lappend targets "$currentX $rowY"
    
      .can create oval $currentX $rowY [expr {$currentX+$diameter}] [expr {$rowY+$diameter}] -outline black -fill red
    }
  
    set currentX [expr {$currentX+$hDistance}]
    
  }
  
  set rowX [expr {$rowX-$shift}]
  set rowY [expr {$rowY+$vDistance}]
    
}


pack .can

wm title . "Galton"

puts [llength $targets]
