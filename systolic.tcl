#!/usr/bin/tclsh

proc createList {} {

  global inputSize
  
  set newList {}
  for {set i 0} {$i < $inputSize} {incr i} {
    lappend newLst {}
  }
  
  return $newLst
  
}

proc swapValues {} {

  upvar toLeft toLeft toRight toRight
  
  if {$toLeft>$toRight} {
    set temp $toRight
    set toRight $toLeft
    set toLeft $temp
  }
  
}

proc moveLastLeft {} {
  
  global inputSize
  upvar lst lst newLst newLst

  set lastIndex [expr {$inputSize-1}]
  set last [lindex $lst $lastIndex]
  if {[llength $last]==1} {
  
    # Cell before last
    set newCell [lindex $lst [expr {$lastIndex-1}]]
    
    # Add last value
    lappend newCell $last
    
    # Update cell
    lset newLst [expr {$lastIndex-1}] $newCell
    
  }
}

proc compareAndPush {} {

  upvar currentCell currentCell i i newLst newLst result result

  set toLeft [lindex $currentCell 0] ; set toRight [lindex $currentCell 1]
      
  swapValues
  
  set leftIndex [expr {$i-1}]
  set rightIndex [expr {$i+1}]
  
  if {$leftIndex<0} {
    lappend result $toLeft
  } else {
    set currentLeft [lindex $newLst $leftIndex]
    lappend currentLeft $toLeft
    lset newLst $leftIndex $currentLeft
  }
  
  set currentRight [lindex $newLst $rightIndex]
  lappend currentRight $toRight
  lset newLst $rightIndex $currentRight
  
}

# Move value right or compare and push
proc moveMidRight {} {

  global inputSize
  upvar lst lst newLst newLst

  for {set i 0} {$i<$inputSize-1} {incr i} {
  
    set currentCell [lindex $lst $i]
    
    if {[llength $currentCell]==2} {
      
      # Move small value left and large value right
      compareAndPush
    
    # Move 1 value right
    } elseif {[llength $currentCell]==1} {
    
      set value [lindex $currentCell 0]
      move right
      
    }
    
  }
  
}

# Add value from input to first cell
proc addAtFirst {} {

  upvar i i input input index index newLst newLst

  if {$i%2!=0} {
    set newValue [lindex $input $index]
    set cFirst [lindex $newLst 0]
    lappend cFirst $newValue
    lset newLst 0 $cFirst
    incr index -1
  }
  
}

# Move single value left or right
proc move {dir} {

  upvar i i newLst newLst value value
  
  set nextIndex [expr {$i+($dir == "right" ? 1 : -1)}]
  set nextCell [lindex $newLst $nextIndex]
  lappend nextCell $value
  lset newLst $nextIndex $nextCell
  
}

# ---------------------------------------------------------

proc stepPhase1 {lst} {
  
  global inputSize
  upvar i i input input index index
  
  set newLst [createList]
  set start [expr {[lindex $lst 0]=={} ? 1 : 0}]
  
  # Move all values right
  for {set j $start} {$j < ($inputSize-1)} {incr j 2} {
    lset newLst [expr {$j+1}] [lindex $lst $j]
  }
  
  # Add number from input to first
  # cell when step number is odd
  addAtFirst
  
  return $newLst
  
}

proc stepPhase2 {lst} {

  global inputSize
  upvar i i input input index index
  
  set newLst [createList]
  
  # If last cell contains 1
  # value, move it left
  moveLastLeft
  
  # Move 1 value right. Compare 2 values in
  # cell and move them left and right
  moveMidRight
  
  addAtFirst
  
  return $newLst
  
}

proc stepPhase3 {lst} {

  global result inputSize
  
  set newLst [createList]
  
  for {set i 0} {$i < $inputSize} {incr i} {
  
    set currentCell [lindex $lst $i]
    set valuesInCell [llength $currentCell]
    
    if {$valuesInCell==1} {
    
      set value [lindex $currentCell 0]
      
      if {$i==0} {
      
        # Add single value from first cell to result
        lappend result $value
        
      } else {
      
        move left
        
      }
      
    } elseif {$valuesInCell==2} {
    
      compareAndPush
      
    }
  }
  
  return $newLst
  
}

# ---------------------------------------------------------

set input {3 4 1 2}
set cells {{} {} {} {}}
set inputSize [llength $input]
set index [expr {$inputSize-1}]

puts "Input: $input"

# First phase
for {set i 1} {$i <= $inputSize} {incr i} {
  set cells [stepPhase1 $cells]
}

puts "After first phase"
puts $cells

# Second phase
for {set i 1} {$i <= $inputSize-1} {incr i} {
  set cells [stepPhase2 $cells]
}

puts "After second phase"
puts $cells

set result {}

# Third phase
while {[llength $result]<$inputSize} {
  set cells [stepPhase3 $cells]
}

puts "After third phase"
puts $cells

puts "Result"
puts $result




