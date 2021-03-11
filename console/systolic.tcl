#!/usr/bin/tclsh


oo::class create Program {

  constructor {} {
  
    variable input {3 4 1 2}
    variable cells {{} {} {} {}}
    variable inputSize [llength $input]
    
    # Input index starting from right
    variable index [expr {$inputSize-1}]
    
    # Current step
    variable step
    
    variable newLst
    variable currentCell
    variable value
    variable toLeft
    variable toRight
    variable result {}
    
  }
  
  method createList {} {

    variable inputSize
    
    set newList {}
    for {set i 0} {$i < $inputSize} {incr i} {
      lappend newLst {}
    }
    
    return $newLst
    
  }

  method swapValues {} {

    variable toLeft
    variable toRight
    
    if {$toLeft>$toRight} {
      set temp $toRight
      set toRight $toLeft
      set toLeft $temp
    }
    
  }

  method moveLastLeft {} {
  
    variable inputSize
    variable cells
    variable newLst

    set lastIndex [expr {$inputSize-1}]
    set last [lindex $cells $lastIndex]
    if {[llength $last]==1} {
    
      # Cell before last
      set newCell [lindex $cells [expr {$lastIndex-1}]]
      
      # Add last value
      lappend newCell $last
      
      # Update cell
      lset newLst [expr {$lastIndex-1}] $newCell
      
    }
    
  }

  method compareAndPush {} {
    
    variable currentCell
    variable i
    variable newLst
    variable result
    variable toLeft
    variable toRight

    set toLeft [lindex $currentCell 0] ; set toRight [lindex $currentCell 1]
        
    my swapValues
    
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
  method moveMidRight {} {

    variable inputSize
    variable cells
    variable value
    variable i
    variable currentCell

    for {set i 0} {$i<$inputSize-1} {incr i} {
    
      set currentCell [lindex $cells $i]
      
      if {[llength $currentCell]==2} {
        
        # Move small value left and large value right
        my compareAndPush
      
      # Move 1 value right
      } elseif {[llength $currentCell]==1} {
      
        set value [lindex $currentCell 0]
        my move right
        
      }
      
    }
    
  }

  # Add value from input to first cell
  method addAtFirst {} {
    
    variable step
    variable input
    variable index
    variable newLst

    if {$step%2!=0} {
      set newValue [lindex $input $index]
      set cFirst [lindex $newLst 0]
      lappend cFirst $newValue
      lset newLst 0 $cFirst
      incr index -1
    }
    
  }

  # Move single value left or right
  method move {dir} {
    
    variable newLst
    variable i
    variable value
    
    set nextIndex [expr {$i+($dir == "right" ? 1 : -1)}]
    set nextCell [lindex $newLst $nextIndex]
    lappend nextCell $value
    lset newLst $nextIndex $nextCell
    
  }

  method stepPhase1 {} {
    
    variable inputSize
    variable newLst
    variable cells
    
    set newLst [my createList]
    set start [expr {[lindex $cells 0]=={} ? 1 : 0}]
    
    # Move all values right
    for {set j $start} {$j < ($inputSize-1)} {incr j 2} {
      lset newLst [expr {$j+1}] [lindex $cells $j]
    }
    
    # Add number from input to first
    # cell when step number is odd
    my addAtFirst
    
    set cells $newLst
    
  }

  method stepPhase2 {} {

    variable newLst
    variable cells
    
    set newLst [my createList]
    
    # If last cell contains 1
    # value, move it left
    my moveLastLeft
    
    # Move 1 value right. Compare 2 values in
    # cell and move them left and right
    my moveMidRight
    
    my addAtFirst
    
    
    set cells $newLst
    
  }

  method stepPhase3 {} {
    
    variable cells
    variable result
    variable inputSize
    variable newLst
    variable value
    variable i
    variable currentCell
    
    set newLst [my createList]
    
    for {set i 0} {$i < $inputSize} {incr i} {
    
      set currentCell [lindex $cells $i]
      set valuesInCell [llength $currentCell]
      
      if {$valuesInCell==1} {
      
        set value [lindex $currentCell 0]
        
        if {$i==0} {
        
          # Add single value from first cell to result
          lappend result $value
          
        } else {
        
          my move left
          
        }
        
      } elseif {$valuesInCell==2} {
      
        my compareAndPush
        
      }
    }
    
    set cells $newLst
    
  }
  
  method main {} {
    
    variable input
    variable cells
    variable inputSize
    variable result
    variable step
  
    puts "Input: $input"

    # First phase
    for {set step 1} {$step <= $inputSize} {incr step} {
      my stepPhase1
    }

    puts "After first phase"
    puts $cells
    
    # Second phase
    for {set step 1} {$step <= $inputSize-1} {incr step} {
      my stepPhase2
    }

    puts "After second phase"
    puts $cells

    # Third phase
    while {[llength $result]<$inputSize} {
      my stepPhase3
    }

    puts "After third phase"
    puts $cells

    puts "Result"
    puts $result
    
  }

  
}


set program [Program new]

$program main
