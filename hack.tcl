
proc every {ms body} {
    eval $body; after $ms [namespace code [info level 0]]
}

# Create canvas
canvas .can
.can configure -width 854
.can configure -height 480

# Create yellow background
.can create rect 0 0 854 480 \
    -outline #f50 -fill yellow

# Main labels
label .matrix -text "CODE MATRIX" -bg yellow -font {Helvetica -22 bold}
label .buffer -text "BUFFER" -bg yellow -font {Helvetica -22 bold}
label .sequences -text "SEQUENCE" -bg yellow -font {Helvetica -22 bold}


# Code matrix
set matrix\
  {{1C E9 1C 55 1C}\
   {E9 55 1C 1C BD}\
   {55 BD 1C BD 55}\
   {55 1C 55 55 1C}\
   {E9 1C 1C 1C 55}}


set leftBorder 30

# Initial cell position in code matrix
set x $leftBorder
set y 50

# Horizontal and vertical distances
# between cells in code matrix
set hDistance 50
set vDistance 30

# Set code matrix labels
for {set i 0} {$i < 5} {incr i} {

  for {set j 0} {$j < 5} {incr j} {
    label .$i-$j -text [lindex $matrix $i $j] -bg red -font {Helvetica -18 bold} -width 3
    place .$i-$j -x $x -y $y
    set x [expr {$x+$hDistance}]
  }
  
  set x $leftBorder
  set y [expr {$y+$vDistance}]  
}


# First buffer label coordinates
set x 450
set y 45

set hDistance 35

# Set buffer labels
for {set i 0} {$i < 7} {incr i} {
  label .buffer$i -text "XX" -bg black -font {Helvetica -18 bold} -foreground white
  place .buffer$i -x $x -y $y
  set x [expr {$x+$hDistance}]
}


# List of sequences(sequence, progress, description)
set sequences\
  {{{55 1C} 0 DATAMINE_V1}\
   {{1C 1C E9} 0 DATAMINE_V2}\
   {{BD E9 55} 0 DATAMINE_V3}}


set numSeqs [llength $sequences]

set leftBorder 450

# Initial sequence cell position
set x $leftBorder
set y 130

set hDistance 40
set vDistance 40

# Set sequence labels
for {set i 0} {$i < $numSeqs} {incr i} {

  set seqs [lindex $sequences $i 0]
  set lng [llength $seqs]
  
  for {set j 0} {$j < $lng} {incr j} {
  
    label .seqs$i-$j -text [lindex $seqs $j]\
    -bg black -font {Helvetica -18 bold}\
    -width 3 -foreground red
    
    place .seqs$i-$j -x $x -y $y
    
    set x [expr {$x+$hDistance}]
    
  }
  
  set x $leftBorder
  set y [expr {$y+$vDistance}]
  
}

# Set 3 main labels and background
place .matrix -x 30 -y 10
place .buffer -x 500 -y 10
place .sequences -x 500 -y 90
place .can -x 0 -y 0

# Set window title and geometry
wm title . "Hack"
wm geometry . 854x480+0+0

# -----------------------------------------------------------------------------

# Initial Row/Col index
set currentIndex 0

# Initial movement direction
# Horizontal 1, Vertical - 0
set horizontal 1

# Buffer is empty
set buffer []

# 1C 1C E9 55 1C
set userInput {2 1 0 3 1}

set inputSize [llength $userInput]

# Check progress
# for {set i 0} {$i < 3} {incr i} {
#
#  set currentSequence [lindex $sequences $i]
#  
#  set progress [lindex $currentSequence 1]
#  set seql [llength [lindex $currentSequence 0]]
#  set bonus [lindex $currentSequence 2]
#  
#  if { $progress == $seql } {
#    puts -nonewline "Unlocked - "
#  } else {
#    puts -nonewline "Failed - "
#  }
#  
#  puts $bonus
#  
#}


# Process user input
set i 0
every 1000 {

  upvar i i
  upvar matrix matrix
  upvar horizontal horizontal
  upvar userInput userInput
  upvar currentInput currentInput
  upvar buffer buffer
  upvar currentIndex currentIndex
  upvar sequences sequences
  upvar inputSize inputSize
  upvar numSeqs numSeqs
  
  if {$i >= $inputSize} { return }

  set currentInput [lindex $userInput $i]
  
  # Current input specifies column
  if {$horizontal} {
  
    set currentValue [lindex $matrix $currentIndex $currentInput]
    
    # Mark cell on code matrix, add value 
    # to buffer and change movement axis
    .$currentIndex-$currentInput configure -bg green
    lappend buffer $currentValue
    set currentIndex $currentInput
    set horizontal 0
    
    
  # Current input specifies row  
  } else {
  
    set currentValue [lindex $matrix $currentInput $currentIndex]
    
    # Mark cell on code matrix, add value 
    # to buffer and change movement axis
    .$currentInput-$currentIndex configure -bg green
    lappend buffer $currentValue
    set currentIndex $currentInput
    set horizontal 1
    
  }
  
  
  # Look for current value in sequences
  for {set j 0} {$j < $numSeqs} {incr j} {
  
    set currentSequence [lindex $sequences $j]
    set currentProgress [lindex $currentSequence 1]
    
    # Increment progress value and mark sequence cell
    if {[lindex $currentSequence 0 $currentProgress] == $currentValue} {
      lset sequences "$j 1" [expr {$currentProgress+1}]
      .seqs$j-$currentProgress configure -bg red
    }
  }
  
  # Next input
  incr i

}


