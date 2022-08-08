#!/usr/bin/wish

# SSD

# ---------------------------------------------------------------

set cells {}
set files {}
set cellHealth 10
set colors {#fc0303 #fc6203 #fca103 #fcc203 #fce303 #fcfc03 #e3fc03 #b1fc03 #6ffc03 #2dfc03 #03fc20}

# ---------------------------------------------------------------

proc createGraphics {} {

  global cellHealth cells

  canvas .can
  pack .can
  wm title . "SSD"

  set leftX 20
  set x $leftX ; set y 20
  set size 20 ; set distance 25

  # Create squares
  for {set i 0} {$i < 10} {incr i} {

    for {set j 0} {$j < 10} {incr j} {
      lappend ids [.can create rect $x $y\
        [expr {$x+$size}] [expr {$y+$size}] -outline #000000 -fill #03fc20]
      incr x $distance
    }

    # Start from left
    set x $leftX

    # Next row
    incr y $distance

  }
  
  # Create cells
  for {set i 0} {$i < 100} {incr i} {
    lappend cells "$i $cellHealth 0"
  }
  
  # Percentage text
  .can create text 150 130 -fill black -font [font create -size 60]

}

# Update cell colors and percentage info
proc updateGraphics {} {

  global cells colors

  for {set i 0} {$i < [llength $cells]} {incr i} {
    .can itemconfigure [expr {$i+1}] -fill\
      [lindex $colors [lindex $cells $i 1]]
  }

  # Configure text
  .can itemconfigure 101 -text [percent]%

}

# Percentage of disk wear
proc percent {} {

  global cells cellHealth

  set sum 0
  foreach c $cells {
    incr sum [lindex $c 1]
  }

  set total [expr {[llength $cells]*$cellHealth}]
  return [expr {int(double($sum)/$total*100)}]

}

# Find free cells
proc findIndices {size} {

  global cells

  # Healthiest cells first
  set sorted [lsort -integer -decreasing -index 1 $cells]

  # Collect free cells
  set indices {}
  for {set i 0} {$i < [llength $sorted]} {incr i} {
  
    set cell [lindex $sorted $i]

    # Cell is unused and has health greater than 0
    if {[lindex $cell 2] == 0 && [lindex $cell 1] > 0} {
    
      # Add new cell
      lappend indices [lindex $cell 0]
      
      # All cells found
      if {[llength $indices] == $size} { break }
      
    }

  }

  return $indices

}

proc saveAtIndices {indices} {

  global cells

  puts "Save: $indices"

  for {set i 0} {$i < [llength $indices]} {incr i} {
    set index [lindex $indices $i]
    set oldHealth [lindex $cells $index 1]
    lset cells $index 2 1
    lset cells $index 1 [expr {$oldHealth - 1}]
  }

  return $indices

}

proc saveFile {size} {

  global files

  set indices [findIndices $size]

  if {[llength $indices] == $size} {
    lappend files [saveAtIndices $indices]
  } else {
    puts "Insufficient disk space!"
  }

}

proc deleteFile {index} {

  global cells files

  set indices [lindex $files $index]
  
  puts "Delete: $indices"
  
  # Delete file from list
  set files [lreplace $files $index $index]

  # Free file cells
  for {set i 0} {$i < [llength $indices]} {incr i} {
    lset cells [lindex $indices $i] 2 0
  }

}

proc every {ms body} {
  eval $body; after $ms [namespace code [info level 0]]
}

proc rnd {max} {
  return [expr {int(rand()*($max+1))}]
}

proc saveRandomFile {} {
  saveFile [expr {[rnd 5]+1}]
}

proc deleteRandomFile {} {
  global files
  deleteFile [expr {[rnd [llength $files]]-1}]
}

# ---------------------------------------------------------------

createGraphics

every 100 {
  global cells
  saveRandomFile
  saveRandomFile
  deleteRandomFile
  updateGraphics
}

# ---------------------------------------------------------------

