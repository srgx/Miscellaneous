#!/usr/bin/wish

# Main loop function
proc every {ms body} {
    eval $body; after $ms [namespace code [info level 0]]
}


# Create board of zeros, red: 0, blue: 1

set numRows 80
set numCols 100

set row []
for {set i 0} {$i < $numCols} {incr i} { lappend row 0 }
set board []
for {set i 0} {$i < $numRows} {incr i} { lappend board $row }

# Create canvas

canvas .can
.can configure -width 854
.can configure -height 480

pack .can

wm title . "Langton"


# Create shapes with appropriate tags

set squareSize 4

set a 0
set b 0
set c $squareSize
set d $squareSize

for {set i 0} {$i < $numRows} {incr i} {

  for {set j 0} {$j < $numCols} {incr j} {
    .can create rect $a $b $c $d -outline #f50 -fill red -tags "$i-$j"
    
    set a [expr {$a+$squareSize}]
    set c [expr {$c+$squareSize}]
  }
  
  set a 0
  set c $squareSize
  set b [expr {$b+$squareSize}]
  set d [expr {$d+$squareSize}]
}


# Initial state
# direction, row, col
# 0 - up, 1 - right, 2 - down, 3 - left
set ant "0 25 65"

# Count iterations
set counter 0

# Main loop
every 1 {

  upvar counter counter
  incr counter
  
  # Stop after 12200
  if {$counter >= 12200} { return }

  upvar ant ant
  upvar board board

  set dir [lindex $ant 0]
  set c [lindex $ant 2]
  set r [lindex $ant 1]
  set currentValue [lindex $board $r $c ]
  
  puts "Position: $r $c, Direction: $dir"
  
  # Change color and turn right or left
  if {$currentValue == 0} {
  
    puts "Turn right"
    
    # Set cell value and color
    lset board $r $c 1
    .can itemconfigure "$r-$c" -fill blue
    
    # Set direction
    lset ant 0 [expr {($dir+1)%4}]
    
  } else {
  
    puts "Turn left"
    
    # Set cell value and color
    lset board $r $c 0
    .can itemconfigure "$r-$c" -fill red
    
    # Set direction
    lset ant 0 [expr {($dir-1)%4}]
    
  }
  
  # Move forward
  switch [lindex $ant 0] {
  
    # up
    0 {
      lset ant 1 [expr {$r-1}]
    }
    
    # right
    1 {
      lset ant 2 [expr {$c+1}]
    }
    
    # down
    2 {
      lset ant 1 [expr {$r+1}]
    }
    
    # left
    3 {
      lset ant 2 [expr {$c-1}]
    }
    
  }
  
}



