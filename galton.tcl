proc every {ms body} {
  eval $body; after $ms [namespace code [info level 0]]
}

proc rnd {} {
  if {rand()>0.5} {
    return 1
  } else {
    return 0
  }
}

canvas .can
.can configure -width 854
.can configure -height 480

set diameter 10
set hDistance 12
set vDistance 12
set shift [expr {$hDistance/2}]

# Initial ball position
set rowX 200
set rowY 10

set rws 8
set rows [expr {$rws+1}]

set targets {}

for {set i 0} {$i < $rows} {incr i} {

  set balls [expr {$i+1}]
  set currentX $rowX
  
  for {set j 0} {$j < $balls} {incr j} {
  
    # Create one ball
    if {$i!=$rows-1} {
      .can create oval\
        $currentX $rowY\
        [expr {$currentX+$diameter}]\
        [expr {$rowY+$diameter}]\
        -outline black -fill black -tag $i-$j
      
    # In last row set list of target positions
    } else {
      lappend targets "$currentX $rowY"
    }
  
    # Move right
    set currentX [expr {$currentX+$hDistance}]
    
  }
  
  # Move initial x position to the left
  set rowX [expr {$rowX-$shift}]
  
  # Move y position down
  set rowY [expr {$rowY+$vDistance}]
    
}

pack .can
wm title . "Galton"


# Initial ball position
set position {0 0}
.can itemconfigure 0-0 -fill red

every 100 {

  upvar position position
  upvar rows rows
  upvar targets targets
  upvar diameter diameter
  upvar vDistance vDistance
  
  set row [lindex $position 0]
  set col [lindex $position 1]
  
  # Turn right/left
  set direction [rnd]
  
  # Set new column position if necessary
  if {$direction==1} { lset position 1 [expr {$col+1}] }

  # Turn off old ball
  .can itemconfigure $row-$col -fill black
  
  # Move ball to next row
  if {$row < ($rows-2)} {
  
    # Set new row position
    lset position 0 [expr {$row+1}]
    
    # Update colors    
    .can itemconfigure "[lindex $position 0]-[lindex $position 1]" -fill red
  
  # Move ball to final position
  } else {
  
    set finalColumn [lindex $position 1]
    set currentTarget [lindex $targets $finalColumn]
    
    set x [lindex $currentTarget 0]
    set y [lindex $currentTarget 1]
    
    .can create oval\
      $x $y\
      [expr {$x+$diameter}]\
      [expr {$y+$diameter}]\
      -outline black -fill red
    
    # Set new target position in column where ball was added
    lset targets $finalColumn 1 [expr {$y+$vDistance}]
    
    # Start from top  
    set position {0 0}
    .can itemconfigure 0-0 -fill red
  }
}

