
###############################################################
#      Dining Philosophers - Procedures & Functions          ;#
###############################################################


############################
#    Small Functions      ;#
############################
proc every {ms body} {
  eval $body; after $ms [namespace code [info level 0]]
}
proc line {} {
  puts "-------------------------------------------------"
}
# Random functions
proc rnd {min max} { expr {int(rand()*($max+1-$min))+$min} }
proc getRandom {} { return [rnd 5 20] }


######################################
#    Draw Philosophers & Forks      ;#
######################################
proc drawShapes {numShapes currentAngle distanceFromCenter radius color} {

  global middleX middleY radiansBetweenShapes ; set points {}

  for {set i 0} {$i < $numShapes} {incr i} {

    # Unit vector
    set vecX [expr {cos($currentAngle)}] ; set vecY [expr {sin($currentAngle)}]
    
    # Central point of philosopher/fork
    set pointX\
      [expr {$middleX+$vecX*$distanceFromCenter}]
    set pointY\
      [expr {$middleY-$vecY*$distanceFromCenter}]
    
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

##############################
#    Draw large circle      ;#
##############################
proc drawTable {} {

  global tableRadius numPhi middleX middleY

  # Table top-left and bottom-right
  set x1 150 ; set y1 70
  set tableDiameter [expr {$tableRadius*2}]
  set x2 [expr {$x1+$tableDiameter}]
  set y2 [expr {$y1+$tableDiameter}]

  # Table center
  set middleX [expr {$x1+$tableRadius}]
  set middleY [expr {$y1+$tableRadius}]

  # Draw table
  .can create oval\
    $x1 $y1 $x2 $y2\
    -outline red -fill green
    
  # Draw middle dot
  .can create oval\
    $middleX $middleY $middleX $middleY\
    -outline red -fill red
    
}

############################
#    Draw all shapes      ;#
############################
proc drawCircles {numPhi} {

  global radiansBetweenShapes phiRad forkRad philoPoints forkPoints

  # Table
  drawTable

  set philosophersFromCenter 130
  set initialAngle $radiansBetweenShapes

  # Philosophers
  set philoPoints\
    [drawShapes $numPhi $initialAngle\
    $philosophersFromCenter $phiRad blue]

  set forksFromCenter 70
  set initialAngle [expr {$radiansBetweenShapes/2}]

  # Forks
  set forkPoints\
    [drawShapes $numPhi $initialAngle\
    $forksFromCenter $forkRad red]
    
}

########################
#    Draw one fork    ;#
########################
proc drawFork {index direction} {

  global forkPoints philoPoints

  # Philosopher centrum position
  set pIndex [expr {$index/2}]
  set philoPoint [lindex $philoPoints $pIndex]
  
  # Fork centrum position
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
  
  # Create line
  .can create line\
    [lindex $philoPoint 0]\
    [lindex $philoPoint 1]\
    [lindex $fPoint 0]\
    [lindex $fPoint 1]\
    -fill yellow -tag $pIndex-$symbol
  
}

############################
#    Eating philosopher   ;#
############################
proc processEating {index} {

  global e
  upvar startActivity startActivity
  upvar lForkIndex lForkIndex
  upvar rForkIndex rForkIndex
  upvar remTime remTime
  upvar name name
  
  if {$remTime==0} {
  
    puts "$name skończył jeść i zaczyna myśleć"
    
    # Change state to thinking
    lset e $index 2 0
    
    # Random thinking time
    lset e $index 1 [getRandom]
    
    # Put forks down
    lset e $lForkIndex 0
    lset e $rForkIndex 0
    
    deleteForks $index
    
    set startActivity 1
  } else {
    puts "$name jest w trakcie jedzenia ($remTime)"
  }                                                   
}


################################
#    Non-eating philosopher   ;#
################################
proc processNonEating {index} {

  global e
  upvar name name
  upvar leftNeIndex leftNeIndex
  upvar rightNeIndex rightNeIndex
  upvar lForkIndex lForkIndex
  upvar rForkIndex rForkIndex
  upvar remTime remTime

  # Attempt to change state
  if {0==$remTime} {
    # Neighbours
    set leftN [lindex $e $leftNeIndex]
    set rightN [lindex $e $rightNeIndex]
    
    # Someone is using left fork
    if {[lindex $e $lForkIndex]==1} {
    
      # Its neighbour
      if {[lindex $leftN 2]==1} {
        puts "$name nie może wziąć lewego widelca"
        
      # Its me
      } else {
      
        # Get right fork if its free
        if {[lindex $e $rForkIndex]!=1} {
        
          puts "$name podnosi prawy widelec i zaczyna jeść"
          
          drawFork $index right
          
          # Get right fork
          lset e $rForkIndex 1
          
          # Change status
          lset e $index 2 1
          
          # Set eating time
          lset e $index 1 [getRandom]
          
          set startActivity 1
          
        # I cant get right fork
        } else {
          puts "$name nie może wziąć prawego widelca"
        }
      }
    } else {
    
      # Get left fork
      lset e $lForkIndex 1
      puts "$name podnosi lewy widelec"
      drawFork $index left
      
    }
    
  } else {
    puts "$name myśli ($remTime)"
  }       
}


###################
#   Neighbours   ;#
###################
proc getNeighbourIndices {index} {

  global e

  if {0==$index} {
    set l [expr {[llength $e]-2}]
    set r [expr {$index+2}]
  } elseif {([llength $e]-2)==$index} {
    set l [expr {$index-2}]
    set r 0
  } else {
    set l [expr {$index-2}]
    set r [expr {$index+2}]
  }
  
  return "$l $r"
  
}


###########################
#    Delete both forks   ;#
###########################
proc deleteForks {index} {  
  set pIndex [expr {$index/2}]
    .can delete $pIndex-0
    .can delete $pIndex-1
}


###############################################################
#               Philosophers & Forks Data                    ;#
###############################################################

# { Name, Remaining time, State }
# State ( 1 - Eating, 0 - Thinking )
set e "

  {Arystoteles [getRandom] 0}
  0
  {Platon [getRandom] 0}
  0
  {Kartezjusz [getRandom] 0}
  0
  {Sokrates [getRandom] 0}
  0
  {Augustyn [getRandom] 0}
  0
  
"

###############################################################
#               Initialize Variables & Shapes                ;#
###############################################################
                                                             ;#
# Number of philosophers and forks                           ;#
set numPhi 5                                                 ;#
                                                             ;#
# Table, philosopher, fork radii                             ;#
set tableRadius 95 ; set phiRad 27 ; set forkRad 10          ;#
                                                             ;#
# Angle between philosophers and forks                       ;#
set angle [expr {360/$numPhi}]                               ;#
set radiansBetweenShapes [expr {$angle*0.0174532925}]        ;#
                                                             ;#
set lastPhilosopherIndex [expr {[llength $e]-2}]             ;#
                                                             ;#
# Create canvas                                              ;#
canvas .can                                                  ;#
.can configure -width 854                                    ;#
.can configure -height 480                                   ;#
                                                             ;#
# Draw all shapes                                            ;#
drawCircles $numPhi                                          ;#
                                                             ;#
pack .can                                                    ;#
wm title . "Dinner"                                          ;#
                                                             ;#
###############################################################



####################################################################
#                    Main Program Loop                            ;#
####################################################################
every 25 {                                                        ;#
                                                                  ;#
  global lastPhilosopherIndex e forkPoints philoPoints            ;#
                                                                  ;#
  for {set j 0} {$j <= $lastPhilosopherIndex} {incr j 2} {        ;#
                                                                  ;#
    # Philosopher data                                            ;#
    set philo [lindex $e $j]                                      ;#
    set name [lindex $philo 0]                                    ;#
    set remTime [lindex $philo 1]                                 ;#
    set activity [lindex $philo 2]                                ;#
                                                                  ;#
    # Fork indices                                                ;#
    set rForkIndex [expr {$j+1}]                                  ;#
    set lForkIndex [expr {0==$j ? 9 : $j-1}]                      ;#
                                                                  ;#
    set neIndices [getNeighbourIndices $j]                        ;#
    set leftNeIndex [lindex $neIndices 0]                         ;#
    set rightNeIndex [lindex $neIndices 1]                        ;#
                                                                  ;#
    set startActivity 0                                           ;#
                                                                  ;#
    # Philosopher is eating                                       ;#
    if {1==$activity} {                                           ;#
                                                                  ;#
      processEating $j                                            ;#
                                                                  ;#
    # Philosopher is not eating                                   ;#
    } else {                                                      ;#
                                                                  ;#
      processNonEating $j                                         ;#
                                                                  ;#
    }                                                             ;#
                                                                  ;#
    # Dont decrement if remaining time                            ;#
    # is 0 or activity just started                               ;#
    if {!$startActivity&&$remTime > 0} {                          ;#
      lset e $j 1 [expr {$remTime-1}]                             ;#
    }                                                             ;#
                                                                  ;#
  }                                                               ;#
                                                                  ;#
  line                                                            ;#
                                                                  ;#
}                                                                 ;#
                                                                  ;#
####################################################################                                                                
