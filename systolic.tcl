

proc phase1 {lst} {
 
  set len [llength $lst]
  
  set newLst {}
  for {set i 0} {$i < $len} {incr i} {
    lappend newLst {}
  }
  
  set start [expr {[lindex $lst 0]=={} ? 1 : 0}]
   
  for {set i $start} {$i < ($len-1)} {incr i 2} {
    lset newLst [expr {$i+1}] [lindex $lst $i]
  }
  
  return $newLst
  
}

proc phase2 {lst} {

  set len [llength $lst]
  
  # Nowa lista
  set newLst {}
  for {set i 0} {$i < $len} {incr i} {
    lappend newLst {}
  }
  
  # Jeżeli ostatnia komórka
  # zawiera jedną liczbę
  # przesuń ją w lewo
  set lastIndex [expr {$len-1}]
  set last [lindex $lst $lastIndex]
  if {[llength $last]==1} {
  
    # Aktualna zawartość przedostatniej komórki
    set newCell [lindex $lst [expr {$lastIndex-1}]]
    
    # Przedostatnia komórka z ostatnim elementem
    lappend newCell $last
    
    # Ustawienie wartości
    lset newLst [expr {$lastIndex-1}] $newCell
    
  }
  
  # Środkowe komórki
  for {set i 0} {$i<$len-1} {incr i} {
  
    set curVal [lindex $lst $i]
    
    if {[llength $curVal]==2} {
    
      set toLeft [lindex $curVal 0] ; set toRight [lindex $curVal 1]
      
      # Zamień wartości
      if {$toLeft>$toRight} {
        set temp $toRight
        set toRight $toLeft
        set toLeft $temp
      }
      
      # Przesuń mniejszą w lewo
      # a większą w prawo
      set leftIndex [expr {$i-1}]
      set rightIndex [expr {$i+1}]
      
      set currentLeft [lindex $newLst $leftIndex]
      set currentRight [lindex $newLst $rightIndex]
      
      lappend currentLeft $toLeft
      lappend currentRight $toRight
      
      lset newLst $leftIndex $currentLeft
      lset newLst $rightIndex $currentRight
      
      
    } elseif {[llength $curVal]==1} {
    
      set nextIndex [expr {$i+1}]
    
      # Aktualna zawartość prawej komórki
      set newCell [lindex $newLst $nextIndex]
        
      # Wartość z dodaną pierwszą komórką
      lappend newCell $curVal
      
      # Ustawienie wartości
      lset newLst $nextIndex $newCell
      
    }
    
  }
  
  return $newLst
  
}

proc phase3 {lst} {
  global result
  
  set len [llength $lst]
  
  # Nowa lista
  set newLst {}
  for {set i 0} {$i < $len} {incr i} {
    lappend newLst {}
  }
  
  for {set i 0} {$i < $len} {incr i} {
    set curVal [lindex $lst $i]
    set cLen [llength $curVal]
    if {$cLen==1} {
    
      set val [lindex $curVal 0]
      
      if {$i==0} {
        # Dodaj wartość do wyniku
        lappend result $val
      } else {
      
        # Przesuń w lewo
        set leftIndex [expr {$i-1}]
        
        set leftVal [lindex $newLst $leftIndex]
        lappend leftVal $val
        lset newLst $leftIndex $leftVal
      }
      
    } elseif {$cLen==2} {
    
      set toLeft [lindex $curVal 0] ; set toRight [lindex $curVal 1]
      
      # Zamień wartości
      if {$toLeft>$toRight} {
        set temp $toRight
        set toRight $toLeft
        set toLeft $temp
      }
      
      # Przesuń mniejszą w lewo
      # a większą w prawo
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
  }
  
  return $newLst
  
}

set input {3 4 1 2}
set cells {{} {} {} {}}
set inputSize [llength $input]
set index [expr {$inputSize-1}]

puts "Input: $input"

# Pierwsza faza
for {set i 1} {$i <= $inputSize} {incr i} {

  set cells [phase1 $cells]
  
  # Dodaj liczbą z inputu
  # w nieparzystym kroku
  if {$i%2!=0} {
    lset cells 0 [lindex $input $index]
    incr index -1
  }
  
}

puts "Po pierwszej fazie"
puts $cells

# Druga faza
for {set i 1} {$i <= $inputSize-1} {incr i} {

  set cells [phase2 $cells]

  # Dodaj liczbę z inputu
  # w nieparzystym kroku
  if {$i%2!=0} {
    set newValue [lindex $input $index]
    set cFirst [lindex $cells 0]
    lappend cFirst $newValue
    lset cells 0 $cFirst
    incr index -1
  }
  
}

puts "Po drugiej fazie"
puts $cells

set result {}

# Trzecia faza
while {[llength $result]<4} {
  set cells [phase3 $cells]
}

puts "Po trzeciej fazie"
puts $cells

puts "Wynik"
puts $result



