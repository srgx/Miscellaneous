#!/usr/bin/wish

# Inclusive
proc rnd {min max} {
  expr {int(rand()*($max+1-$min))+$min}
}

# Create canvas
canvas .can
.can configure -width 854
.can configure -height 480

# --------------------------------------------
# Main configuration

# Board size
set s 330

# Particle size
set dotSize 1.0

# Number of random particles
set tests 1000

# Connection distance
set distanceToConnect 5
# --------------------------------------------

# Create board
.can create rect 0 0 $s $s -outline black -fill black

# Board center
set cntr [expr {$s/2}]

# Half dot
set hDot [expr {$dotSize/2}]

# Top Left
set cX [expr {$cntr-$hDot}]

# Bot Right
set cX2 [expr {$cX+$dotSize}]

pack .can
wm title . "DLA"

# Initial square
.can create rect $cX $cX $cX2 $cX2 -outline red -fill red

# List of positions(centers)
set dots "{$cX $cX}"

# Position limits
set minPos $hDot
set maxPos [expr {$s-$hDot}]

for {set i 0} {$i < $tests} {incr i} {

  puts "I: $i"
  
  # Random wall
  set wall [rnd 1 4]
  
  # Position in wall
  set position [rnd $minPos $maxPos]
  
  # Angle range
  set ang [rnd 0 180]
  
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
  
  # Set current position and vector
  set currentPosition $midCoords
  set radians [expr {$ang*0.0174532925}]
  
  # Vector components
  set x [expr {cos($radians)}] ; set y [expr {sin($radians)}]
  
  set breaking 0
  
  # Move while position in bounds
  while {[lindex $currentPosition 0]>=$minPos&&\
         [lindex $currentPosition 0]<=$maxPos&&\
         [lindex $currentPosition 1]>=$minPos&&
         [lindex $currentPosition 1]<=$maxPos} {
  
    # Move point
    lset currentPosition 0 [expr {[lindex $currentPosition 0]+$x}]
    lset currentPosition 1 [expr {[lindex $currentPosition 1]+$y}]
    
    set cpX [lindex $currentPosition 0]
    set cpY [lindex $currentPosition 1]
    
    # Check if is close to others
    for {set j 0} {$j < [llength $dots]} {incr j} {
    
      set currentFrozenPoint [lindex $dots $j]
      set fX [lindex $currentFrozenPoint 0]
      set fY [lindex $currentFrozenPoint 1]
        
      set distance [expr {sqrt(pow($cpX-$fX,2)+pow($cpY-$fY,2))}]
      
      if {$distance<=$distanceToConnect} {
      
        # Add new position
        lappend dots $currentPosition
        
        # Create rectangle
        .can create rect\
          [expr {$cpX-$hDot}] [expr {$cpY-$hDot}]\
          [expr {$cpX+$hDot}] [expr {$cpY+$hDot}]\
          -outline red -fill red
          
        # Connect lines
        .can create line $fX $fY $cpX $cpY -fill yellow -tag lines
        
        # Break for and while loops
        set breaking 1 ; break
        
      }
      
    }
    
    # Break while loop
    if {$breaking} { set breaking 0 ; break }
    
  }
    
}

