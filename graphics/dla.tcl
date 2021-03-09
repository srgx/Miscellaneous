#!/usr/bin/wish

oo::class create Program {

  constructor {} {
  
    variable boardSize 330.
    variable boardCenter [expr {$boardSize/2}]
    
    # Main parameters
    variable shots 5000
    variable pointSize 1.0
    variable distanceToConnect 10
    variable vectorScale 10
    
    # Colors
    variable pointColor red
    variable lineColor cyan
    
    variable halfPoint [expr {$pointSize/2}]
    variable minPos $halfPoint
    variable maxPos [expr {$boardSize-$halfPoint}]
    
    variable points {}
    
    my createCanvas
    
  }
  
  method createCanvas {} {
  
    variable boardCenter
    variable halfPoint
    variable pointSize
    variable boardSize
    variable points
    variable pointColor
    
    set topLeft [expr {$boardCenter-$halfPoint}]
    set botRight [expr {$topLeft+$pointSize}]
  
    canvas .can
    .can configure -width 854
    .can configure -height 480
    
    pack .can
    wm title . "DLA"
    
    # Background
    .can create rect 0 0 $boardSize $boardSize -outline black -fill black
    
    # Initial middle dot
    .can create rect\
      $topLeft $topLeft $botRight $botRight\
      -outline $pointColor -fill $pointColor
      
    lappend points "$boardCenter $boardCenter"
    
  }
  
  method rnd {min max} { expr {int(rand()*($max+1-$min))+$min} }
  
  method inBounds {p} {
  
    variable minPos
    variable maxPos
    
    set x [lindex $p 0] ; set y [lindex $p 1]
    
    return [expr {$x>=$minPos&&$x<=$maxPos&&
                  $y>=$minPos&&$y<=$maxPos}]
                  
  }
  
  method checkCollision {p} {
  
    variable points
    variable distanceToConnect
  
    set cpX [lindex $p 0]
    set cpY [lindex $p 1]
    
    for {set j 0} {$j < [llength $points]} {incr j} {

      set currentFrozenPoint [lindex $points $j]
      set fX [lindex $currentFrozenPoint 0]
      set fY [lindex $currentFrozenPoint 1]
      set distance [expr {sqrt(pow($cpX-$fX,2)+pow($cpY-$fY,2))}]
  
      if {$distance<=$distanceToConnect} { return "1 {$fX $fY}"}
  
    }
    
    return "0 {}"
    
  }
  
  method main {} {
  
    variable shots
    variable minPos
    variable maxPos
    variable points
    variable halfPoint
    variable vectorScale
    variable pointColor
    variable lineColor
  
    for {set i 0} {$i < $shots} {incr i} {

      puts "Shots: $i, Frozen points: [llength $points]"
  
      # Random wall
      set wall [my rnd 1 4]
      
      # Position in wall
      set position [my rnd $minPos $maxPos]
      
      # Angle range
      set ang [my rnd 0 180]
    
      # Left(-90 to 90)
      # Top(-180 to 0)
      # Bot(0 to 180)
      # Right(90 to 270)
      switch $wall {

        # Left
        1 {
          set ang [expr {$ang-90}]
          set midCoords "$minPos $position"
        }
        
        # Top
        2 {
          set ang [expr {$ang-180}]
          set midCoords "$position $minPos"
        }
        
        # Right
        3 {
          set ang [expr {$ang+90}]
          set midCoords "$maxPos $position"
        }
        
        # Bot(no change required)
        4 {
          set midCoords "$position $maxPos"
        }
      
        default {
          puts "Error"
        }
        
      }
  
      # Middle side position
      set currentPosition $midCoords
      set radians [expr {$ang*0.0174532925}]
      
      # Vector components
      set x [expr {cos($radians)*$vectorScale}]
      set y [expr {sin($radians)*$vectorScale}]
      
      # Move while position in bounds
      while {[my inBounds $currentPosition]} {
  
        # Move point
        lset currentPosition 0 [expr {[lindex $currentPosition 0]+$x}]
        lset currentPosition 1 [expr {[lindex $currentPosition 1]+$y}]
        
        set result [my checkCollision $currentPosition]
        if {[lindex $result 0]} {
        
          set cpX [lindex $currentPosition 0]
          set cpY [lindex $currentPosition 1]
          
          set fX [lindex $result 1 0]
          set fY [lindex $result 1 1]
          
          lappend points $currentPosition
          
          # Create rectangle
          .can create rect\
            [expr {$cpX-$halfPoint}] [expr {$cpY-$halfPoint}]\
            [expr {$cpX+$halfPoint}] [expr {$cpY+$halfPoint}]\
            -outline $pointColor -fill $pointColor
            
          # Connect lines
          .can create line $fX $fY $cpX $cpY -fill $lineColor -tag lines
          
          break
          
        }
        
      }
    
    }

  }
  
}


# -------------------------
[Program new] main
# -------------------------
