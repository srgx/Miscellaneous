#!/usr/bin/wish

oo::class create BaseGate {

  constructor { s o } {
    variable size $s
    variable outs $o
    variable values {}
    variable position {}
  }

  method setPosition {p} {
    variable position
    set position $p
  }

  method draw {} {
    variable position
    drawGate $position white
  }

  method drawLines {} {

    global gates
    variable position
    variable outs

    for {set i 0} {$i < [llength $outs]} {incr i} {
      set pos [[lindex $gates [lindex $outs $i]] getPosition]
      .can create line [lindex $position 0] [lindex $position 1]\
                       [lindex $pos 0] [lindex $pos 1] -fill black
    }

  }

  method getPosition {} {
    variable position
    return $position
  }

  method ready {} {
    variable size
    variable values
    return [expr {$size == [llength $values]}]
  }

  method addValue {v} {
    variable values
    lappend values $v
  }

  method sendSignal {v} {

    global gates
    variable outs
    variable values
    variable position

    my addValue $v

    if {[my ready]} {

      set newValue [my evaluate]

      drawActive $newValue $position

      for {set i 0} {$i < [llength $outs]} {incr i} {
        [lindex $gates [lindex $outs $i]] sendSignal $newValue
      }

    }

  }

  method getValues {} {
    variable values
    return $values
  }

}

oo::class create AndGate {

  superclass BaseGate

  constructor { size outs } { next $size $outs }

  method evaluate {} {
    variable values
    for {set i 0} {$i < [llength $values]} {incr i} {
      if {![lindex $values $i]} { return 0 }
    }
    return 1
  }

  method draw {} {
    variable position
    drawGate $position brown
  }

}

oo::class create OrGate {

  superclass BaseGate

  constructor { size outs } { next $size $outs }

  method evaluate {} {
    variable values
    for {set i 0} {$i < [llength $values]} {incr i} {
      if {[lindex $values $i]} { return 1 }
    }
    return 0
  }

  method draw {} {
    variable position
    drawGate $position black
  }

}

oo::class create NorGate {

  superclass BaseGate

  constructor { size outs } { next $size $outs }

  method evaluate {} {
    variable values
    for {set i 0} {$i < [llength $values]} {incr i} {
      if {[lindex $values $i]} { return 0 }
    }
    return 1
  }

  method draw {} {
    variable position
    drawGate $position lime
  }

}

oo::class create NandGate {

  superclass BaseGate

  constructor { size outs } { next $size $outs }

  method evaluate {} {
    variable values
    set sum 0 ; set l [llength $values]
    for {set i 0} {$i < $l} {incr i} {
      set sum [expr {$sum+[lindex $values $i]}]
    }
    return [expr {$sum!=$l}]
  }

  method draw {} {
    variable position
    drawGate $position orange
  }

}

oo::class create XorGate {

  superclass BaseGate

  constructor { size outs } { next $size $outs }

  method evaluate {} {
    variable values
    set sum 0 ; set l [llength $values]
    for {set i 0} {$i < $l} {incr i} {
      set sum [expr {$sum+[lindex $values $i]}]
    }
    return [expr {$sum==1}]
  }

  method draw {} {
    variable position
    drawGate $position magenta
  }

}

oo::class create NotGate {

  superclass BaseGate

  constructor { ots } { next 1 $ots}

  method evaluate {} {
    variable values
    return [expr {![lindex $values 0]}]
  }

  method draw {} {
    variable position
    set p0 [lindex $position 0] ; set p1 [lindex $position 1]
    set d 12;
    .can create polygon [expr {$p0-$d}] [expr {$p1-$d}]\
                        [expr {$p0+$d}] [expr {$p1-$d}]\
                        $p0 [expr {$p1+$d}] -outline #777 -fill red
  }

}

oo::class create Out {

  constructor { i } {
    variable indx $i
  }

  method sendSignal {v} {
    global result
    variable indx
    variable position
    drawActive $v $position
    lset result $indx $v
  }

  method setPosition {p} {
    variable position
    set position $p
  }

  method getPosition {} {
    variable position
    return $position
  }

  method draw {} {
    variable position
    drawGate $position blue
  }

}

oo::class create In {

  constructor { val ots } {
    variable value $val
    variable outs $ots
  }

  method setPosition {p} {
    variable position
    set position $p
  }

  method getPosition {} {
    variable position
    return $position
  }

  method draw {} {
    variable position
    drawGate $position green
  }

  method drawLines {} {

    global gates
    variable position
    variable outs

    for {set i 0} {$i < [llength $outs]} {incr i} {
      set pos [[lindex $gates [lindex $outs $i]] getPosition]

      .can create line [lindex $position 0] [lindex $position 1]\
                       [lindex $pos 0] [lindex $pos 1] -fill black
    }

  }

  method sendSignal {} {

    global gates
    variable outs
    variable value
    variable position

    drawActive $value $position

    for {set i 0} {$i < [llength $outs]} {incr i} {
      [lindex $gates [lindex $outs $i]] sendSignal $value
    }

  }

}

proc drawCircle {position radius color} {

  set p0 [lindex $position 0]
  set p1 [lindex $position 1]

  .can create oval [expr {$p0-$radius}] [expr {$p1-$radius}]\
                   [expr {$p0+$radius}] [expr {$p1+$radius}] -outline #777 -fill $color
}

proc drawGate {position color} {
  drawCircle $position 10 $color
}

proc drawActive {value position} {
  if {$value} { drawCircle $position 5 yellow }
}

proc drawAllGates {} {

  global input
  global gates

  # Draw inputs
  for {set i 0} {$i < [llength $input]} {incr i} {
    [lindex $input $i] draw
  }

  # Draw gates
  for {set i 0} {$i < [llength $gates]} {incr i} {
    [lindex $gates $i] draw
  }

  # Draw input lines
  for {set i 0} {$i < [llength $input]} {incr i} {
    [lindex $input $i] drawLines
  }

  # Draw lines
  for {set i 0} {$i < 67} {incr i} {
    [lindex $gates $i] drawLines
  }

}

proc setAllPositions {} {

  global input
  global gates

  # Top inputs
  set x 20
  for {set i 0} {$i < 10} {incr i} {
    [lindex $input $i] setPosition "$x 20"
    set x [expr {$x + 60}]
  }

  # Function select inputs
  set y 20
  for {set i 10} {$i < 14} {incr i} {
    [lindex $input $i] setPosition "820 $y"
    set y [expr {$y + 40}]
  }

  # Top not gates
  set x 50
  for {set i 0} {$i < 5} {incr i} {
    [lindex $gates $i] setPosition "$x 70"
    set x [expr {$x + 150}]
  }

  # Top and gates
  set x 15
  for {set i 5} {$i < 25} {incr i} {
    [lindex $gates $i] setPosition "$x 160"
    set x [expr {$x + 40}]
  }

  # Top nor gates
  set x 70
  for {set i 25} {$i < 33} {incr i} {
    [lindex $gates $i] setPosition "$x 220"
    set x [expr {$x + 90}]
  }

  # Ands, nands, nots
  set x 15
  for {set i 33} {$i < 53} {incr i} {
    [lindex $gates $i] setPosition "$x 300"
    set x [expr {$x + 42}]
  }

  # Ands, nors
  set x 120
  for {set i 53} {$i < 61} {incr i} {
    [lindex $gates $i] setPosition "$x 350"
    set x [expr {$x + 80}]
  }

  # Xors
  set x 90
  for {set i 61} {$i < 67} {incr i} {
    [lindex $gates $i] setPosition "$x 400"
    set x [expr {$x + 110}]
  }

  # Outs
  set x 40
  for {set i 67} {$i < 75} {incr i} {
    [lindex $gates $i] setPosition "$x 470"
    set x [expr {$x + 100}]
  }

}

proc main {} {

  canvas .can

  .can configure -width 854
  .can configure -height 480

  pack .can

  wm title . "Alu"

  global gates
  global result
  global input

  # 4 + 2 = 6
  set numberA { 1 0 1 1 }
  set numberB { 1 1 0 1 }

  set carry 0
  set mode 1
  set selected { 1 0 0 1 }
  set result { -1 -1 -1 -1 -1 -1 -1 -1 }

  set input " [In new $carry { 33 36 40 45 48 }]\
              [In new $mode { 0 }]\
              [In new [lindex $numberA 3] { 5 8 9 }]\
              [In new [lindex $numberB 3] { 1 6 9 }]\
              [In new [lindex $numberA 2] { 10 13 14 }]\
              [In new [lindex $numberB 2] { 2 11 14 }]\
              [In new [lindex $numberA 1] { 15 18 19 }]\
              [In new [lindex $numberB 1] { 3 16 19 }]\
              [In new [lindex $numberA 0] { 20 23 24 }]\
              [In new [lindex $numberB 0] { 4 21 24 }]\
              [In new [lindex $selected 0] { 6 11 16 21 }]\
              [In new [lindex $selected 1] { 7 12 17 22 }]\
              [In new [lindex $selected 2] { 8 13 18 23 }]\
              [In new [lindex $selected 3] { 9 14 19 24 }] "

  set gates " [NotGate new { 33 35 36 38 39 40 42 43 44 45}]\
              [NotGate new { 7 8 }]\
              [NotGate new { 12 13 }]\
              [NotGate new { 17 18 }]\
              [NotGate new { 22 23 }]\
              [AndGate new 1 { 25 }]\
              [AndGate new 2 { 25 }]\
              [AndGate new 2 { 25 }]\
              [AndGate new 3 { 26 }]\
              [AndGate new 3 { 26 }]\
              [AndGate new 1 { 27 }]\
              [AndGate new 2 { 27 }]\
              [AndGate new 2 { 27 }]\
              [AndGate new 3 { 28 }]\
              [AndGate new 3 { 28 }]\
              [AndGate new 1 { 29 }]\
              [AndGate new 2 { 29 }]\
              [AndGate new 2 { 29 }]\
              [AndGate new 3 { 30 }]\
              [AndGate new 3 { 30 }]\
              [AndGate new 1 { 31 }]\
              [AndGate new 2 { 31 }]\
              [AndGate new 2 { 31 }]\
              [AndGate new 3 { 32 }]\
              [AndGate new 3 { 32 }]\
              [NorGate new 3 { 34 35 39 44 49 }]\
              [NorGate new 2 { 36 40 45 47 48 53 }]\
              [NorGate new 3 { 37 38 43 50 }]\
              [NorGate new 2 { 39 40 44 45 47 48 49 55 }]\
              [NorGate new 3 { 41 42 51 }]\
              [NorGate new 2 { 43 44 45 47 48 49 50 57 }]\
              [NorGate new 3 { 46 52 }]\
              [NorGate new 2 { 47 48 49 50 51 59 }]\
              [NandGate new 2 { 61 }]\
              [NotGate new { 53 }]\
              [AndGate new 2 { 54 }]\
              [AndGate new 3 { 54 }]\
              [NotGate new { 55 }]\
              [AndGate new 2 { 56 }]\
              [AndGate new 3 { 56 }]\
              [AndGate new 4 { 56 }]\
              [NotGate new { 57 }]\
              [AndGate new 2 { 58 }]\
              [AndGate new 3 { 58 }]\
              [AndGate new 4 { 58 }]\
              [AndGate new 5 { 58 }]\
              [NotGate new { 59 }]\
              [NandGate new 4 { 72 }]\
              [NandGate new 5 { 66 }]\
              [AndGate new 4 { 60 }]\
              [AndGate new 3 { 60 }]\
              [AndGate new 2 { 60 }]\
              [AndGate new 1 { 60 }]\
              [AndGate new 2 { 61 }]\
              [NorGate new 2 { 62 }]\
              [AndGate new 2 { 62 }]\
              [NorGate new 3 { 64 }]\
              [AndGate new 2 { 64 }]\
              [NorGate new 4 { 65 }]\
              [AndGate new 2 { 65 }]\
              [NorGate new 4 { 66 74 }]\
              [XorGate new 2 { 63 67 }]\
              [XorGate new 2 { 63 68 }]\
              [AndGate new 4 { 69 }]\
              [XorGate new 2 { 63 70 }]\
              [XorGate new 2 { 63 71 }]\
              [OrGate new 2 { 73 }]\
              [Out new 0]\
              [Out new 1]\
              [Out new 2]\
              [Out new 3]\
              [Out new 4]\
              [Out new 5]\
              [Out new 6]\
              [Out new 7]\ "


    setAllPositions
    drawAllGates

    for {set i 0} {$i < [llength $input]} {incr i} {
      [lindex $input $i] sendSignal
    }

    puts $result
    puts "Result: [lindex $result 4] [lindex $result 3]\
                  [lindex $result 1] [lindex $result 0]"

}


main

