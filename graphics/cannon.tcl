#!/usr/bin/wish

oo::class create Program {

  constructor {angle initialSpeed} {
  
    set angle [expr {$angle*0.0174532925}]
    
    variable t 0
    variable ballX 50
    variable ballY 280
    variable horizontal [expr {cos($angle)*$initialSpeed}]
    variable vertical [expr {sin($angle)*$initialSpeed}]
    variable ballRadius 10
    variable pathRadius 2
    variable acceleration -0.4
    my createCanvas
    
  }
  
  method createCanvas {} {
  
    variable ballX
    variable ballY
    variable ballRadius
    
    canvas .can
    .can configure -width 854
    .can configure -height 480
    
    .can create rect 10 290 800 300 -outline #f50 -fill brown
    .can create oval\
      [expr {$ballX-$ballRadius}] [expr {$ballY-$ballRadius}]\
      [expr {$ballX+$ballRadius}] [expr {$ballY+$ballRadius}]\
       -outline black -fill black -tag ball
       
    pack .can
    wm title . "Cannon"
       
  }
  
  method updateBall {} {
    
    variable ballX
    variable ballY
    variable ballRadius
  
    .can coords ball\
      [expr {$ballX-$ballRadius}]\
      [expr {$ballY-$ballRadius}]\
      [expr {$ballX+$ballRadius}]\
      [expr {$ballY+$ballRadius}]
      
  }
  
  method updatePosition {} {
    
    variable ballX
    variable ballY
    variable horizontal
    variable vertical
  
    set ballX [expr {$ballX+$horizontal}]
    set ballY [expr {$ballY-$vertical}]
    
  }
  
  method drawPath {} {
  
    variable ballX
    variable ballY
    variable pathRadius
  
    .can create oval\
      [expr {$ballX-$pathRadius}]\
      [expr {$ballY-$pathRadius}]\
      [expr {$ballX+$pathRadius}]\
      [expr {$ballY+$pathRadius}]\
      -outline black -fill black
      
  }
  
  
  method updateVector {} {
  
    variable vertical
    variable acceleration
  
    set vertical [expr {$vertical+$acceleration}]
    
  }
  
  method update {} {
  
    variable t
    
    incr t
    
    if {$t>10&&$t<=100} {
  
      my updatePosition
      my updateBall
      my drawPath
      my updateVector
      
    }
    
  }
  
}

proc every {ms body} {
  eval $body; after $ms [namespace code [info level 0]]
}



if {$argc<2} {

  puts "Usage: wish $argv0 angle speed"
  exit
  
} else {

  set program [Program new [lindex $argv 0] [lindex $argv 1]]
  
  every 60 {

    global program
    $program update
  
  }
  
}

