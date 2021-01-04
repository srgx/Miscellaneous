
proc every {ms body} {
    eval $body; after $ms [namespace code [info level 0]]
}

proc click {i j} {

  upvar buffer buffer
  upvar bufferIndex bufferIndex
  upvar currentIndex currentIndex
  upvar horizontal horizontal
  upvar sequences sequences
  upvar numSeqs numSeqs
  upvar matrix matrix
  
  set ok 1
  
  if {$horizontal} {
    if {$i != $currentIndex} {
      set ok 0
    } else {
      set horizontal 0 ; set currentIndex $j
    }
  } else {
    if {$j != $currentIndex} {
      set ok 0
    } else {
      set horizontal 1 ; set currentIndex $i
    }
  }
  
  if {$ok} {
  
    .$i-$j configure -bg green
  
    set value [lindex $matrix $i $j]

    puts $i-$j ; puts $value
    
    # Set buffer label
    .buffer$bufferIndex configure -text $value
    incr bufferIndex
    
    # Add value to buffer
    lappend buffer $value
    
    puts $buffer
    
    
    
    # -------------------------------------------------------
    
    # Look for current value in sequences
    for {set k 0} {$k < $numSeqs} {incr k} {
    
      set currentSequence [lindex $sequences $k]
      set currentProgress [lindex $currentSequence 1]
      
      # Increment progress value and mark sequence cell
      if {[lindex $currentSequence 0 $currentProgress] == $value} {
        set newProgress [expr {$currentProgress+1}]
      
        lset sequences "$k 1" $newProgress
        .seqs$k-$currentProgress configure -bg green
         
        puts $currentProgress
        
        # Check if sequence is unlocked
        if { $newProgress == [llength [lindex $currentSequence 0]] } {
          puts "Odblokowano"
        }
      }
    }
    
    
  }
  
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
        
    # Bind events to matrix cells
    bind .$i-$j <1> "click $i $j"
    
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
set bufferIndex 0

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





