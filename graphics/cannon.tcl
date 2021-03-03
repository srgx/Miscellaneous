#!/usr/bin/wish

# Check arguments
if {$argc<2} {
  puts "Usage: wish $argv0 angle speed"
  exit
}

proc every {ms body} {
  eval $body; after $ms [namespace code [info level 0]]
}

canvas .can
.can configure -width 854
.can configure -height 480

# Ball position
set ballX 50
set ballY 280

# Ball radius
set ballR 10

# Gravity
set acceleration -0.4

# Path dot radius
set pathR 2

set initialSpeed [lindex $argv 1]
set angle [expr {0.0174532925*[lindex $argv 0]}]

# Components
set vertical [expr {sin($angle)*$initialSpeed}]
set horizontal [expr {cos($angle)*$initialSpeed}]

.can create rect 10 290 800 300 -outline #f50 -fill brown
.can create oval [expr {$ballX-$ballR}]\
                 [expr {$ballY-$ballR}]\
                 [expr {$ballX+$ballR}]\
                 [expr {$ballY+$ballR}]\
                 -outline black -fill black -tag ball

pack .can

wm title . "Cannon"

set t 0

every 60 {

  upvar t t
  incr t
  
  
  if {$t>10&&$t<=100} {
    
    upvar ballX ballX
    upvar ballY ballY
    
    upvar vertical vertical
    upvar horizontal horizontal
    
    set ballX [expr {$ballX+$horizontal}]
    set ballY [expr {$ballY-$vertical}]
    
    
    upvar ballR ballR
    
    # Update ball position
    .can coords ball\
      [expr {$ballX-$ballR}]\
      [expr {$ballY-$ballR}]\
      [expr {$ballX+$ballR}]\
      [expr {$ballY+$ballR}]
    
    
    upvar pathR pathR
    
    # Draw ball path
    .can create oval\
      [expr {$ballX-$pathR}]\
      [expr {$ballY-$pathR}]\
      [expr {$ballX+$pathR}]\
      [expr {$ballY+$pathR}]\
      -outline black -fill black
                     
                     
    upvar acceleration acceleration
    
    # Update vertical component
    # Horizontal component is constant
    set vertical [expr {$vertical+$acceleration}]
    
  }
      
}
