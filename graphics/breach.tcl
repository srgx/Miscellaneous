#!/usr/bin/wish

oo::class create Program {

  constructor {} {
  
    variable bufferSize 7
    variable bufferIndex 0
    variable size 5
    
    # Row/Col index
    variable currentIndex 0
    
    # Horizontal/Vertical step
    variable horizontal 1
    
    # Indices of locked sequences
    variable locked []
    
    # List of sequences(sequence, progress, description)
    variable sequences\
      {{{55 1C} 0 DATAMINE_V1}\
      {{1C 1C E9} 0 DATAMINE_V2}\
      {{BD E9 55} 0 DATAMINE_V3}}
    
    
    variable matrix\
      {{1C E9 1C 55 1C}\
      {E9 55 1C 1C BD}\
      {55 BD 1C BD 55}\
      {55 1C 55 55 1C}\
      {E9 1C 1C 1C 55}}
    
    
    my createCanvas
    my setCodeMatrixLabels
    my setCodeDots
    my setBufferLabels
    my setSequenceLabels
    
    # Mark first row dot
    .can itemconfigure vdot0 -fill red
      
  }
  
  method createCanvas {} {
  
    canvas .can
    .can configure -width 854
    .can configure -height 480
    
    place .can -x 0 -y 0

    # Background
    .can create rect 0 0 854 480 -outline #f50 -fill yellow
        
    # Main labels
    label .matrix -text "CODE MATRIX" -bg yellow -font {Helvetica -22 bold}
    place .matrix -x 30 -y 10
    
    label .buffer -text "BUFFER" -bg yellow -font {Helvetica -22 bold}
    place .buffer -x 500 -y 10
    
    label .sequences -text "SEQUENCE" -bg yellow -font {Helvetica -22 bold}
    place .sequences -x 500 -y 90

  
    wm title . "Breach"
    wm geometry . 854x480+0+0
    
  }
  
  method setCodeMatrixLabels {} {

    variable matrix
    variable size

    set leftBorder 30 ; set x $leftBorder ; set y 50
    set hDistance 50 ; set vDistance 30

    # Set code matrix labels
    for {set i 0} {$i < $size} {incr i} {

      for {set j 0} {$j < $size} {incr j} {
      
        label .$i-$j -text [lindex $matrix $i $j] -bg red -font {Helvetica -18 bold} -width 3
        place .$i-$j -x $x -y $y
            
        # Bind events to matrix cells
        bind .$i-$j <1> "click $i $j"
        
        set x [expr {$x+$hDistance}]
      }
      
      set x $leftBorder
      set y [expr {$y+$vDistance}]  
    }
    
  }
  
  method setCodeDots {} {
  
    variable size

    set hDistance 50 ; set vDistance 30
    set a 42 ; set b [expr {$a+8}]

    # Horizontal
    for {set i 0} {$i < $size} {incr i} {
      .can create oval $a 40 $b 48 -outline black -fill yellow -tag hdot$i
      set a [expr {$a+$hDistance}]
      set b [expr {$b+$hDistance}]
    }

    set a 59 ; set b [expr {$a+8}]

    # Vertical
    for {set i 0} {$i < $size} {incr i} {
      .can create oval 19 $a 27 $b -outline black -fill yellow -tag vdot$i
      set a [expr {$a+$vDistance}]
      set b [expr {$b+$vDistance}]
    }
    
  }

  method setBufferLabels {} {
  
    variable bufferSize

    set x 450 ; set y 45

    set hDistance 35

    for {set i 0} {$i < $bufferSize} {incr i} {
      label .buffer$i -text "XX" -bg black -font {Helvetica -18 bold} -foreground white
      place .buffer$i -x $x -y $y
      set x [expr {$x+$hDistance}]
    }
    
  }

  method setSequenceLabels {} {

    variable sequences
  
    set numSeqs [llength $sequences]
    
    set leftBorder 450 ; set x $leftBorder ; set y 130
    set hDistance 40 ; set vDistance 40

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
    
  }
  
  method click {i j} {
  
    variable bufferSize
    variable bufferIndex
    variable currentIndex
    variable horizontal
    variable sequences
    variable matrix
    variable locked

    # Full buffer or cell already marked
    if {$bufferIndex >= $bufferSize ||
      "green" == [lindex [.$i-$j configure -bg] 4]} {
      return
    }
      
    set numSeqs [llength $sequences]
    
    if {$horizontal} {
      if {$i != $currentIndex} {
        return
      } else {
        .can itemconfigure vdot$i -fill yellow
        .can itemconfigure hdot$j -fill red
        set horizontal 0 ; set currentIndex $j
      }
    } else {
      if {$j != $currentIndex} {
        return
      } else {
        .can itemconfigure hdot$j -fill yellow
        .can itemconfigure vdot$i -fill red
        set horizontal 1 ; set currentIndex $i
      }
    }
    
    .$i-$j configure -bg green

    set value [lindex $matrix $i $j]
    
    # Set buffer label
    .buffer$bufferIndex configure -text $value
    incr bufferIndex
    
    # Look for current value in sequences
    for {set k 0} {$k < $numSeqs} {incr k} {
    
      # Skip finished or wrong sequences
      if {$k in $locked} { continue }
    
      set currentSequence [lindex $sequences $k]
      set currentProgress [lindex $currentSequence 1]
      
      # Increment progress value and mark sequence cell
      if {[lindex $currentSequence 0 $currentProgress] == $value} {
        set newProgress [expr {$currentProgress+1}]
      
        lset sequences "$k 1" $newProgress
        .seqs$k-$currentProgress configure -bg green
        
        # Check if sequence is unlocked
        if { $newProgress == [llength [lindex $currentSequence 0]] } {
        
          # Data mine unlocked
        
          lappend locked $k
          
          label .sdata$k -text [lindex $currentSequence 2]\
          -bg yellow -font {Helvetica -20 bold} -foreground green
          
          place .sdata$k -x 580 -y [expr {$k*40+130}]
      
        }
        
      # Sequence started but error occured
      } elseif { $currentProgress > 0 } {
      
        lappend locked $k
        
        # Mark labels red
        for {set i 0} {$i < [llength [lindex $currentSequence 0]]} {incr i} {
          .seqs$k-$i configure -bg red
        }
        
        label .sdata$k -text "ERROR"\
          -bg yellow -font {Helvetica -20 bold} -foreground red
          
        place .sdata$k -x 580 -y [expr {$k*40+130}]
        
      }
      
    }
    
  }
  
}

proc click {i j} { global program ; $program click $i $j }

set program [Program new]


