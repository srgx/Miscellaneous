#!/usr/bin/wish

oo::class create Program {

  constructor {} {
  
    # Ant - "direction row col"
    # direction - "0 - up, 1 - right, 2 - down, 3 - left"
  
    variable counter 0
    variable ant "0 25 65"
    variable board
    variable numRows 80
    variable numCols 100
    
    my createCanvas
    my createBoard
    my createSquares
    
  }
  
  method createCanvas {} {
  
    canvas .can
    .can configure -width 854
    .can configure -height 480
    
    pack .can
    wm title . "Langton"
    
  }
  
  method createSquares {} {
  
    variable numRows
    variable numCols
  
    set squareSize 4

    set a 0 ; set b 0 ; set c $squareSize ; set d $squareSize

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
    
  }
  
  method createBoard {} {
  
    variable numRows
    variable numCols
    variable board
  
    set row [] ; for {set i 0} {$i < $numCols} {incr i} { lappend row 0 }
    set board [] ; for {set i 0} {$i < $numRows} {incr i} { lappend board $row }

  }
  
  method moveForward {} {
  
    variable ant
    set r [lindex $ant 1]
    set c [lindex $ant 2]
  
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
  

  method turnLeft {} {
  
    variable ant
    variable board
    
    puts "Turn left"
    
    set r [lindex $ant 1] ; set c [lindex $ant 2]
    lset board $r $c 0 ; .can itemconfigure "$r-$c" -fill red
    
    set dir [lindex $ant 0]
    lset ant 0 [expr {($dir-1)%4}]
    
  }
  
  method turnRight {} {
  
    variable ant
    variable board
    
    puts "Turn right"
      
    set r [lindex $ant 1] ; set c [lindex $ant 2]
    lset board $r $c 1 ; .can itemconfigure "$r-$c" -fill blue
    
    set dir [lindex $ant 0]
    lset ant 0 [expr {($dir+1)%4}]
    
  }
  
  method turn {} {
  
    variable board
    variable ant
    
    set r [lindex $ant 1] ; set c [lindex $ant 2]
    my [expr {[lindex $board $r $c ]==0 ? "turnRight" : "turnLeft" }]
    
  }
  
  method showState {} {
  
    variable ant
    
    puts "Position: [lindex $ant 1] [lindex $ant 2], Direction: [lindex $ant 0]"
    
  }
  
  method update {} {
  
    variable counter
  
    incr counter
    
    # Stop after 12200
    if {$counter >= 12200} { return }

    my showState ; my turn ; my moveForward
    
  }
  
}


proc every {ms body} { eval $body; after $ms [namespace code [info level 0]] }

set program [Program new]
every 1 { global program ; $program update }

