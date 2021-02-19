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

# Create canvas
canvas .can
.can configure -width 854
.can configure -height 480

.can create rect 0 0 400 300 \
    -outline black -fill black

# List of points
# Point is {x y}
set listRows {}

proc createPoints {rws hd vd} {

  # Initial point position
  set rowX 200
  set rowY 10

  global rows listRows
    
  set rows [expr {$rws+1}]
  set hDistance $hd ; set vDistance $vd
  set shift [expr {$hDistance/2}]

  for {set i 0} {$i < $rows} {incr i} {

    set points [expr {$i+1}]
    set currentX $rowX
    
    set currentRow {}
    
    for {set j 0} {$j < $points} {incr j} {
    
      lappend currentRow "$currentX $rowY"
    
      # Move right
      set currentX [expr {$currentX+$hDistance}]
      
    }
    
    lappend listRows $currentRow
    
    # Move initial x position to the left
    set rowX [expr {$rowX-$shift}]
    
    # Move y position down
    set rowY [expr {$rowY+$vDistance}]
    
  }
}

# Main function
createPoints 12 10 20

pack .can
wm title . "Lightning"

# Initial point
set position {0 0}

# Count lightnings in group
set c 0

set pause 0

every 8 {

  global pause
  
  if {$pause>0} {
    incr pause -1
  } else {
  
    global position rows listRows c
  
    set row [lindex $position 0]
    set col [lindex $position 1]
    
    # Turn right/left
    set direction [rnd]
    
    # Set new column position if necessary
    if {$direction==1} { lset position 1 [expr {$col+1}] }
    
    # Move to next row
    if {$row < ($rows-1)} {
    
      # Set new row position
      lset position 0 [expr {$row+1}]
      
      set lastPoint [lindex $listRows $row $col]
      set newPoint [lindex $listRows [lindex $position 0] [lindex $position 1]]
      
      .can create line\
        [lindex $lastPoint 0]\
        [lindex $lastPoint 1]\
        [lindex $newPoint 0]\
        [lindex $newPoint 1]\
        -fill yellow -tag lines
        
    } else {
    
      incr c
      
      # After 5 lightnings
      if {$c >= 5} { .can delete lines ; set c 0 ; set pause 0}
      
      # Start from top
      set position {0 0}
      
    }
  }

}

