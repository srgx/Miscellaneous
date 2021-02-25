

proc every {ms body} {
  eval $body; after $ms [namespace code [info level 0]]
}


proc drawShapes {numShapes currentAngle distanceFromCenter radius color} {

  global middleX middleY radiansBetweenShapes
  
  set points {}

  for {set i 0} {$i < $numShapes} {incr i} {

    set vecX [expr {cos($currentAngle)}] ; set vecY [expr {sin($currentAngle)}]
    
    set pointX\
      [expr {$middleX+$vecX*$distanceFromCenter}]
      
    set pointY\
      [expr {$middleY-$vecY*$distanceFromCenter}]
    
    lappend points "$pointX $pointY"

    set newX\
      [expr {$pointX-$radius}]
      
    set newY\
      [expr {$pointY-$radius}]
    
    
    set shapeDiameter [expr {$radius*2}]
    
    .can create oval\
      $newX $newY\
      [expr {$newX+$shapeDiameter}]\
      [expr {$newY+$shapeDiameter}]\
      -outline $color -fill $color
      
    set currentAngle [expr {$currentAngle+$radiansBetweenShapes}]
  
  }
  
  return $points
  
}

# Funkcje losujące
proc rnd {min max} { expr {int(rand()*($max+1-$min))+$min} }
proc getRandom {} { return [rnd 5 20] }

canvas .can
.can configure -width 854
.can configure -height 480

# -----------------------------------------------

# Liczba filozofów i widelców
set numPhi 5

# Stół
set tableRadius 95

# Promień filozofa
set phiRad 27

# Promień widelca
set forkRad 10

set angle [expr {360/$numPhi}]
set radiansBetweenShapes [expr {$angle*0.0174532925}]

# Stan(1 - Jedzenie, 0 - Myślenie)
# {Imię, Pozostały czas, Stan}
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

set lastPhilosopherIndex [expr {[llength $e]-2}]

# -----------------------------------------------

proc drawTable {} {

  global tableRadius numPhi middleX middleY

  # Lewa góra i prawy dół stołu
  set x1 150 ; set y1 70
  set tableDiameter [expr {$tableRadius*2}]
  set x2 [expr {$x1+$tableDiameter}]
  set y2 [expr {$y1+$tableDiameter}]

  # Środek stołu
  set middleX [expr {$x1+$tableRadius}]
  set middleY [expr {$y1+$tableRadius}]

  # Stół
  .can create oval\
    $x1 $y1 $x2 $y2\
    -outline red -fill green
    
  # Środek
  .can create oval\
    $middleX $middleY $middleX $middleY\
    -outline red -fill red
    
}


proc drawCircles {numPhi} {

  global radiansBetweenShapes phiRad forkRad philoPoints forkPoints

  # Stół
  drawTable

  set philosophersFromCenter 130
  set initialAngle $radiansBetweenShapes

  # Filozofowie
  set philoPoints\
    [drawShapes $numPhi $initialAngle\
    $philosophersFromCenter $phiRad blue]

  set forksFromCenter 70
  set initialAngle [expr {$radiansBetweenShapes/2}]

  # Widelce
  set forkPoints\
    [drawShapes $numPhi $initialAngle\
    $forksFromCenter $forkRad red]
}


# Narysuj wszyskie kształty
drawCircles $numPhi

pack .can
wm title . "Dinner"


every 25 {

  global lastPhilosopherIndex e forkPoints philoPoints

  for {set j 0} {$j <= $lastPhilosopherIndex} {incr j 2} {
  
    # Pobierz dane o filozofie
    set philo [lindex $e $j]
    set name [lindex $philo 0]
    set remTime [lindex $philo 1]
    set activity [lindex $philo 2]
    
    # Indeks, pod którym znajduje się
    # pozycja filozofa na liście philoPoints
    set philoPointIndex [expr {$j/2}]
    
    # Punkt lewego widelca
    set leftForkPoint [lindex $forkPoints $philoPointIndex]
    
    # Punkt prawego widelca
    if {4==$philoPointIndex} {
      set rightForkPoint [lindex $forkPoints 0]
    } else {
      set rightForkPoint [lindex $forkPoints [expr {$philoPointIndex+1}]]
    }
    
    # Widelec na liście e
    set rightForkIndex [expr {$j+1}]
    set rightFork [lindex $e $rightForkIndex]
    
    # Sąsiedzi
    if {0==$j} {
      set leftNeIndex [expr {[llength $e]-2}]
      set rightNeIndex [expr {$j+2}]
    } elseif {([llength $e]-2)==$j} {
      set leftNeIndex [expr {$j-2}]
      set rightNeIndex 0
    } else {
      set leftNeIndex [expr {$j-2}]
      set rightNeIndex [expr {$j+2}]
    }
  
    # Pierwszy filozof
    if {0==$j} {
      set leftForkIndex 9
      set leftFork [lindex $e $leftForkIndex]
      
    # Pozostali filozofowie
    } else {
      set leftForkIndex [expr {$j-1}]
      set leftFork [lindex $e $leftForkIndex]
    }
    
    set startActivity 0
    
    # Jedzenie
    if {1==$activity} {
    
      if {$remTime==0} {
      
        puts "$name skończył jeść i zaczyna myśleć"
        
        # Zmiana statusu na myślenie
        lset e $j 2 0
        
        # Losowy czas myślenia
        lset e $j 1 [getRandom]
        
        # Odkładanie widelców
        lset e $leftForkIndex 0
        lset e $rightForkIndex 0
        
        .can delete $philoPointIndex-0
        .can delete $philoPointIndex-1
        
        set startActivity 1
        
      } else {
        puts "$name jest w trakcie jedzenia ($remTime)"
      }
      
      
    # Myślenie albo próba jedzenia
    } else {
    
      # Chce zmienić swój stan
      if {0==$remTime} {
      
        # Sąsiedzi
        set leftN [lindex $e $leftNeIndex]
        set rightN [lindex $e $rightNeIndex]
        
        # Lewy widelec zajęty
        if {$leftFork==1} {
        
          # Zajęty przez sąsiada
          if {[lindex $leftN 2]==1} {
          
            puts "$name nie może wziąć lewego widelca"
            
          # Zajęty przeze mnie
          } else {
            
            # Jeśli prawy nie jest podniesiony
            if {$rightFork!=1} {
            
              puts "$name podnosi prawy widelec i zaczyna jeść"
              
              set philoPoint [lindex $philoPoints $philoPointIndex]
          
              .can create line\
                [lindex $philoPoint 0]\
                [lindex $philoPoint 1]\
                [lindex $rightForkPoint 0]\
                [lindex $rightForkPoint 1]\
                -fill yellow -tag $philoPointIndex-1
            
              # Podniesienie prawego widelca
              lset e $rightForkIndex 1
              
              # Zmiana statusu na jedzenie
              lset e $j 2 1
              
              # Ustawienie czasu jedzenia
              lset e $j 1 [getRandom]
              
              set startActivity 1
            
            # Prawy jest podniesiony ale ja nie jem
            # To znaczy że je sąsiad
            } else {
              puts "$name nie może wziąć prawego widelca"
            }
          }
        } else {
        
          # Podniesienie lewego widelca
          lset e $leftForkIndex 1
          puts "$name podnosi lewy widelec"
          
          set philoPoint [lindex $philoPoints $philoPointIndex]
          
          .can create line\
            [lindex $philoPoint 0]\
            [lindex $philoPoint 1]\
            [lindex $leftForkPoint 0]\
            [lindex $leftForkPoint 1]\
            -fill yellow -tag $philoPointIndex-0
          
        }
      
      } else {
      
        puts "$name myśli ($remTime)"
        
      }
      
    }
    
    # Myślenie lub jedzenie dopiero
    # się zaczęło albo już się skończyło
    if {!$startActivity&&$remTime > 0} {
      lset e $j 1 [expr {$remTime-1}]
    }
    
  }
  
  puts "-------------------------------------------------"
  
}

