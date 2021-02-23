

proc every {ms body} {
  eval $body; after $ms [namespace code [info level 0]]
}

# Stan(1 - Jedzenie, 0 - Myślenie)
# {Imię, Pozostały czas, Stan}

proc rnd {min max} {
  expr {int(rand()*($max+1-$min))+$min}
}

canvas .can
.can configure -width 854
.can configure -height 480

# -----------------------------------------------

# Liczba filozofów i widelców
set numPhi 5 ; set numFork $numPhi

# Stół
set diameter 190
set radius [expr {$diameter/2}]

# Wymiary filozofa
set phiDiam 54
set phiRad [expr {$phiDiam/2}]

# Wymiary widelca
set forkDiam 20
set forkRad [expr {$forkDiam/2}]

# -----------------------------------------------

# Lewa góra i prawy dół stołu
set x1 150 ; set y1 70
set x2 [expr {$x1+$diameter}]
set y2 [expr {$y1+$diameter}]

# Środek stołu
set middleX [expr {$x1+$radius}]
set middleY [expr {$y1+$radius}]

set angle [expr {360/$numPhi}]
set radians [expr {$angle*0.0174532925}]

# Stół
.can create oval\
  $x1 $y1 $x2 $y2\
  -outline red -fill green
  
# Środek
.can create oval\
  $middleX $middleY $middleX $middleY\
  -outline red -fill red
  
# Pozycja filozofów
set distanceFromCenter 130

set currentAngle $radians

set philoPoints {}
set forkPoints {}

# Narysuj filozofów
for {set i 0} {$i < $numPhi} {incr i} {

  set vecX [expr {cos($currentAngle)}]
  set vecY [expr {sin($currentAngle)}]
  
  set pointX [expr {$middleX+$vecX*$distanceFromCenter}]
  set pointY [expr {$middleY-$vecY*$distanceFromCenter}]
  
  lappend philoPoints "$pointX $pointY"

  set newX\
    [expr {$pointX-$phiRad}]
    
  set newY\
    [expr {$pointY-$phiRad}]
  
  .can create oval\
    $newX $newY\
    [expr {$newX+$phiDiam}]\
    [expr {$newY+$phiDiam}]\
    -outline blue -fill blue
    
  set currentAngle [expr {$currentAngle+$radians}]
  
}


# Pozycja widelców
set distanceFromCenter 70

set currentAngle [expr {$radians/2}]

# Narysuj widelce
for {set i 0} {$i < $numFork} {incr i} {

  set vecX [expr {cos($currentAngle)}]
  set vecY [expr {sin($currentAngle)}]
  
  set pointX [expr {$middleX+$vecX*$distanceFromCenter}]
  set pointY [expr {$middleY-$vecY*$distanceFromCenter}]
  
  lappend forkPoints "$pointX $pointY"

  set newX\
    [expr {$pointX-$forkRad}]
    
  set newY\
    [expr {$pointY-$forkRad}]
  
  .can create oval\
    $newX $newY\
    [expr {$newX+$forkDiam}]\
    [expr {$newY+$forkDiam}]\
    -outline red -fill red
    
  set currentAngle [expr {$currentAngle+$radians}]
  
}


pack .can
wm title . "Dinner"

set minTime 5
set maxTime 20

set e "

  {Arystoteles [rnd $minTime $maxTime] 0}
  0
  {Platon [rnd $minTime $maxTime] 0}
  0
  {Kartezjusz [rnd $minTime $maxTime] 0}
  0
  {Sokrates [rnd $minTime $maxTime] 0}
  0
  {Augustyn [rnd $minTime $maxTime] 0}
  0
  
"

set rounds 200
set limit [expr {[llength $e]-1}]


every 25 {

  global limit e forkPoints philoPoints minTime maxTime

  for {set j 0} {$j < $limit} {incr j 2} {
  
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
        lset e $j 1 [rnd $minTime $maxTime]
        
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
              lset e $j 1 [rnd $minTime $maxTime]
              
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





