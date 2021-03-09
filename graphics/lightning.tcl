#!/usr/bin/wish

oo::class create Program {

  constructor {rws} {
  
    variable points {}
    variable position {0 0}
    variable lightnings 0
    variable pause 0
    variable horizontalDistance 10
    variable verticalDistance 20
    variable numRows [expr {$rws+1}]
  
    my createCanvas
    my createPoints
    
  }
  
  method rnd {} { return [expr {rand()>0.5 ? 1 : 0}] }
  
  method createCanvas {} {
  
    canvas .can
    .can configure -width 854
    .can configure -height 480
    
    # Background
    .can create rect 0 0 400 300 \
        -outline black -fill black
        
    pack .can
    wm title . "Lightning"
        
  }
  
  method createPoints {} {
  
    variable numRows
    variable points
    variable horizontalDistance
    variable verticalDistance

    set rowX 200 ; set rowY 10

    set shift [expr {$horizontalDistance/2}]

    for {set i 0} {$i < $numRows} {incr i} {

      set pointsInRow [expr {$i+1}]
      set currentX $rowX
      
      set currentRow {}
      
      for {set j 0} {$j < $pointsInRow} {incr j} {
        lappend currentRow "$currentX $rowY"
        set currentX [expr {$currentX+$horizontalDistance}]
      }
      
      lappend points $currentRow
      
      set rowX [expr {$rowX-$shift}]
      set rowY [expr {$rowY+$verticalDistance}]
      
    }
  }
  
  method update {} {
  
    variable pause
    variable position
    variable numRows
    variable points
    variable lightnings
  
    if {$pause>0} {
      incr pause -1
    } else {
    
      set row [lindex $position 0]
      set col [lindex $position 1]
      set direction [my rnd]
      
      if {$direction==1} { lset position 1 [expr {$col+1}] }
      
      if {$row < ($numRows-1)} {
      
        # Set new row position
        lset position 0 [expr {$row+1}]
        
        set lastPoint [lindex $points $row $col]
        set newPoint [lindex $points [lindex $position 0] [lindex $position 1]]
        
        .can create line\
          [lindex $lastPoint 0]\
          [lindex $lastPoint 1]\
          [lindex $newPoint 0]\
          [lindex $newPoint 1]\
          -fill yellow -tag lines
          
      } else {
      
        incr lightnings
        
        if {$lightnings >= 5} {
          .can delete lines ; set lightnings 0 ; set pause 0
        }
        
        set position {0 0}
        
      }
    }
  }
}

proc every {ms body} {
  eval $body; after $ms [namespace code [info level 0]]
}


set program [Program new 12]
every 8 { global program ; $program update }

