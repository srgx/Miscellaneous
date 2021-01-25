
proc every {ms body} {
  eval $body; after $ms [namespace code [info level 0]]
}

canvas .can
.can configure -width 854
.can configure -height 480

set initialSpeed 16

set ballX 50
set ballY 280
set ballR 10

set acceleration -0.4

set pathR 2

set angle 0.7

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

set timer 50

every 100 {

  upvar timer timer

  if {$timer>0} {
    incr timer -1
  } else {
    
    upvar acceleration acceleration

    upvar ballX ballX
    upvar ballY ballY
    upvar ballR ballR
    upvar pathR pathR
    
    upvar vertical vertical
    upvar horizontal horizontal
    
    set ballX [expr {$ballX+$horizontal}]
    set ballY [expr {$ballY-$vertical}]
    
    .can coords ball\
      [expr {$ballX-$ballR}]\
      [expr {$ballY-$ballR}]\
      [expr {$ballX+$ballR}]\
      [expr {$ballY+$ballR}]
      
    .can create oval [expr {$ballX-$pathR}]\
                 [expr {$ballY-$pathR}]\
                 [expr {$ballX+$pathR}]\
                 [expr {$ballY+$pathR}]\
                 -outline black -fill black
      
    set vertical [expr {$vertical+$acceleration}]
    
    }
      
}
