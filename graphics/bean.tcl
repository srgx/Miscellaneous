#!/usr/bin/wish

oo::class create Program {

  constructor {nRows} {
  
    variable position
    set position {0 0}
    
    variable rows
    set rows [expr {$nRows+1}]
    
    variable diameter
    set diameter 7
    
    variable targets
    set targets {}
    
    my createBalls
    
  }
  
  method createCanvas {} {
  
    canvas .can
    .can configure -width 854
    .can configure -height 480
    
    pack .can
    wm title . "Bean Machine"
    
  }
  
  method createBalls {} {
  
    variable rows
    variable diameter
    variable targets
  
    my createCanvas
  
    set rowX 200 ; set rowY 10
    set horizontalDistance 2 ; set verticalDistance 2
    
    set shift [expr {$diameter/2+$horizontalDistance/2}]

    for {set i 0} {$i < $rows} {incr i} {
    
      set ballsInRow [expr {$i+1}]
      set currentX $rowX
      
      for {set j 0} {$j < $ballsInRow} {incr j} {
      
        if {$i!=$rows-1} {
        
          .can create oval\
            $currentX $rowY\
            [expr {$currentX+$diameter}]\
            [expr {$rowY+$diameter}]\
            -outline black -fill black -tag $i-$j
            
        } else {
        
          lappend targets "$currentX $rowY"
          
        }
        
        set currentX [expr {$currentX+$diameter+$horizontalDistance}]
        
      }
      
      set rowX [expr {$rowX-$shift}]
      set rowY [expr {$rowY+$diameter+$verticalDistance}]
      
    }
    
    my turnOn
    
  }
  
  method turnOn {} { my setColor red }
  
  method turnOff {} { my setColor black }
  
  method setColor {color} {
  
    variable position
    
    .can itemconfigure [lindex $position 0]-[lindex $position 1] -fill $color
    
  }
  
  method rnd {} { return [expr {rand()>0.5 ? 1 : 0}] }
  
  method toNextRow {} {
  
    variable position

    lset position 0 [expr {[lindex $position 0]+1}]
    my turnOn
    
  }
  
  method toFinalPosition {} {
  
      variable position
      variable diameter
      variable targets
      
      set finalColumn [lindex $position 1]
      set currentTarget [lindex $targets $finalColumn]
      
      set x [lindex $currentTarget 0] ; set y [lindex $currentTarget 1]
      
      .can create oval\
        $x $y\
        [expr {$x+$diameter}]\
        [expr {$y+$diameter}]\
        -outline black -fill red
      
      lset targets $finalColumn 1 [expr {$y+$diameter/3}]
      
      set position {0 0}
      my turnOn
      
  }
  
  method moveBall {} {
  
    variable rows
    variable position
    
    my turnOff
    
    set direction [my rnd]
    if {$direction==1} { lset position 1 [expr {[lindex $position 1]+1}] }
    my [expr {[lindex $position 0] < ($rows-2) ? "toNextRow" : "toFinalPosition"}]
  
  }
  
  method update {} { my moveBall }
  
}

proc every {ms body} {
  eval $body; after $ms [namespace code [info level 0]]
}


set program [Program new 8]

every 50 {

  global program
  
  $program update
  
}
