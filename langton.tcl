#!/usr/bin/wish

# Create board of zeros 20x20, red: 0, blue: 1

set row []
for {set i 0} {$i < 20} {incr i} { lappend row 0 }
set board []
for {set i 0} {$i < 20} {incr i} { lappend board $row }


# Create 2 dimensional array of shapes

canvas .can

set a 0
set b 0
set c 10
set d 10

for {set i 0} {$i < 20} {incr i} {

  for {set j 0} {$j < 20} {incr j} {
    .can create rect $a $b $c $d -outline #f50 -fill red -tags "$i-$j"
    
    set a [expr {$a+10}]
    set c [expr {$c+10}]
  }
  
  set a 0
  set c 10
  set b [expr {$b+10}]
  set d [expr {$d+10}]
}

pack .can

wm title . "Langton"

proc every {ms body} {
    eval $body; after $ms [namespace code [info level 0]]
}

# direction, row, col
# 0 - up, 1 - right, 2 - down, 3 - left
set ant "0 10 9"


# Main loop
every 20 {

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


