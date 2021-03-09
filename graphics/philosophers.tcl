#!/usr/bin/wish

oo::class create Program {

  constructor {} {
  
    variable philosopherColor black
    variable handColor yellow
    variable tableColor red
    variable forkColor blue
    variable tableMiddleX
    variable tableMiddleY
    variable numPhilosophers 5
    variable tableRadius 95
    variable philosopherRadius 27
    variable forkRadius 10
    variable angle [expr {360/$numPhilosophers}]
    variable radiansBetweenShapes [expr {$angle*0.0174532925}]
    variable forkPoints
    variable philoPoints
    variable startActivity

    # { Name, Remaining time, State }
    # State ( 1 - Eating, 0 - Thinking )
    variable tableState "

      {Arystoteles [my getRandom] 0}
      0
      {Platon [my getRandom] 0}
      0
      {Kartezjusz [my getRandom] 0}
      0
      {Sokrates [my getRandom] 0}
      0
      {Augustyn [my getRandom] 0}
      0
      
    "
    
    variable lastPhilosopherIndex [expr {[llength $tableState]-2}]

    my createCanvas
    
  }

  
  method createCanvas {} {
  
    canvas .can
    .can configure -width 854
    .can configure -height 480
    
    pack .can
    wm title . "Dinner"

    my drawAllShapes

  }
  
  method drawAllShapes {} {
  
    variable numPhilosophers
    variable radiansBetweenShapes
    variable philosopherRadius
    variable forkRadius
    variable forkColor
    variable philosopherColor
    variable forkPoints
    variable philoPoints

    my drawTable

    set philosophersFromCenter 130
    set initialAngle $radiansBetweenShapes

    # Philosophers
    set philoPoints\
      [my drawShapes\
        $initialAngle $philosophersFromCenter\
        $philosopherRadius $philosopherColor]

    set forksFromCenter 70
    set initialAngle [expr {$radiansBetweenShapes/2}]

    # Forks
    set forkPoints\
      [my drawShapes\
        $initialAngle $forksFromCenter\
        $forkRadius $forkColor]
    
  }
  
  method drawTable {} {
    
    variable tableRadius
    variable tableColor
    variable tableMiddleX
    variable tableMiddleY

    # Table top-left and bottom-right
    set x1 150 ; set y1 70
    set tableDiameter [expr {$tableRadius*2}]
    set x2 [expr {$x1+$tableDiameter}]
    set y2 [expr {$y1+$tableDiameter}]

    # Table center
    set tableMiddleX [expr {$x1+$tableRadius}]
    set tableMiddleY [expr {$y1+$tableRadius}]

    # Draw table
    .can create oval\
      $x1 $y1 $x2 $y2\
      -outline red -fill $tableColor
      
    # Draw middle dot
    .can create oval\
      $tableMiddleX $tableMiddleY $tableMiddleX $tableMiddleY\
      -outline red -fill red
    
  }
  
  method drawShapes {currentAngle distanceFromCenter radius color} {
  
    variable tableMiddleX
    variable tableMiddleY
    variable radiansBetweenShapes
    variable numPhilosophers

    set points {}

    for {set i 0} {$i < $numPhilosophers} {incr i} {

      # Unit vector
      set vecX [expr {cos($currentAngle)}] ; set vecY [expr {sin($currentAngle)}]
      
      # Central point of philosopher/fork
      set pointX\
        [expr {$tableMiddleX+$vecX*$distanceFromCenter}]
      set pointY\
        [expr {$tableMiddleY-$vecY*$distanceFromCenter}]
      
      # List of positions
      lappend points "$pointX $pointY"

      # Top left circle position
      set newX\
        [expr {$pointX-$radius}]
      set newY\
        [expr {$pointY-$radius}]
      
      set shapeDiameter [expr {$radius*2}]
      
      # Draw circle
      .can create oval\
        $newX $newY\
        [expr {$newX+$shapeDiameter}]\
        [expr {$newY+$shapeDiameter}]\
        -outline $color -fill $color
        
      # Angle for next shape
      set currentAngle [expr {$currentAngle+$radiansBetweenShapes}]
    
    }
  
    # Return list of positions
    return $points
  
  }
  
  method rnd {min max} { expr {int(rand()*($max+1-$min))+$min} }
  method getRandom {} { return [my rnd 5 20] }
  
  method update {} {
  
    variable lastPhilosopherIndex
    variable tableState
  
    for {set j 0} {$j <= $lastPhilosopherIndex} {incr j 2} {
    
      set startActivity 0
      set remTime [lindex $tableState $j 1]
      set activity [lindex $tableState $j 2]
      
      if {1==$activity} {
        my processEating $j
      } else {
        my processNonEating $j
      }
      
      # Dont decrement if remaining time
      # is 0 or activity just started
      if {!$startActivity&&$remTime > 0} {
        lset tableState $j 1 [expr {$remTime-1}]
      }
      
    }
    
    my line
    
  }
  
  method getNeighbourIndices {index} {

    variable tableState
    
    set lastP [expr {[llength $tableState]-2}]
    set l [expr {0==$index ? $lastP : $index-2}]
    set r [expr {$lastP==$index ? 0 : $index+2}]
    
    return "$l $r"
  
  }
  
  method processNonEating {index} {

    variable tableState
    variable startActivity
    
    set philo [lindex $tableState $index]
    set name [lindex $philo 0]
    set remTime [lindex $philo 1]
    set rForkIndex [expr {$index+1}]
    set lForkIndex [my getLForkIndex $index]
    set neIndices [my getNeighbourIndices $index]
    set leftNeIndex [lindex $neIndices 0]
    set rightNeIndex [lindex $neIndices 1]
    
    # Attempt to change state
    if {0==$remTime} {
    
      # Neighbours
      set leftN [lindex $tableState $leftNeIndex]
      set rightN [lindex $tableState $rightNeIndex]
      
      # Someone is using left fork
      if {[lindex $tableState $lForkIndex]==1} {
      
        # Its neighbour
        if {[lindex $leftN 2]==1} {
          puts "$name nie może wziąć lewego widelca"
          
        # Its me
        } else {
        
          # Get right fork if its free
          if {[lindex $tableState $rForkIndex]!=1} {
          
            puts "$name podnosi prawy widelec i zaczyna jeść"
            
            my drawHand $index right
            
            # Get right fork
            lset tableState $rForkIndex 1
            
            # Change status
            lset tableState $index 2 1
            
            # Set eating time
            lset tableState $index 1 [my getRandom]
            
            set startActivity 1
            
          # I cant get right fork
          } else {
            puts "$name nie może wziąć prawego widelca"
          }
          
        }
          
      } else {
        
        # Get left fork
        lset tableState $lForkIndex 1
        puts "$name podnosi lewy widelec"
        my drawHand $index left
          
      }
        
    } else {
      puts "$name myśli ($remTime)"
    }
    
  }
  
  method getLForkIndex {index} {
    return [expr {0==$index ? 9 : $index-1}]
  }
  
  method processEating {index} {

    variable tableState
    variable startActivity
    
    set philo [lindex $tableState $index]
    set name [lindex $philo 0]
    set remTime [lindex $philo 1]
    set rForkIndex [expr {$index+1}]
    set lForkIndex [my getLForkIndex $index]
    
    if {$remTime==0} {
    
      puts "$name skończył jeść i zaczyna myśleć"
      
      # Change state to thinking
      lset tableState $index 2 0
      
      # Random thinking time
      lset tableState $index 1 [my getRandom]
      
      # Put forks down
      lset tableState $lForkIndex 0
      lset tableState $rForkIndex 0
      
      my deleteForks $index
      
      set startActivity 1
      
    } else {
      puts "$name jest w trakcie jedzenia ($remTime)"
    }
  }
  
  method drawHand {index direction} {
    
    variable forkPoints
    variable philoPoints
    variable handColor

    # Philosopher center
    set pIndex [expr {$index/2}]
    set philoPoint [lindex $philoPoints $pIndex]
    
    # Fork center
    # Symbol identifies left/right fork
    set fPoint {} ; set symbol {}
    if {$direction=="right"} {
      set symbol 1
      if {4==$pIndex} {
        set fPoint [lindex $forkPoints 0]
      } else {
        set fPoint [lindex $forkPoints [expr {$pIndex+1}]]
      }
    } elseif {$direction=="left"} {
      set symbol 0
      set fPoint [lindex $forkPoints $pIndex]
    }
    
    .can create line\
      [lindex $philoPoint 0]\
      [lindex $philoPoint 1]\
      [lindex $fPoint 0]\
      [lindex $fPoint 1]\
      -fill $handColor -tag $pIndex-$symbol
  
  }
  
  # Delete both forks
  method deleteForks {index} {  
    set pIndex [expr {$index/2}]
    .can delete $pIndex-0
    .can delete $pIndex-1
  }
  
  method line {} {
    puts "-------------------------------------------------"
  }
  
}

proc every {ms body} {
  eval $body; after $ms [namespace code [info level 0]]
}


# ----------------------------------------------
set program [Program new]
every 25 { global program ; $program update }
# ----------------------------------------------
