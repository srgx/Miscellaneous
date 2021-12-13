#!/bin/sh
#\
exec tclsh "$0" "$@"

# ----------------------------
# Convert values
# ----------------------------
# dth - decimal to hexadecimal
# htd - hexadecimal to decimal
# dtb - decimal to binary
# btd - binary to decimal
# bye - quit

proc checkArguments {input} {
  if {[llength $input] >= 2} {
    return 1
  } else {
    puts "Not enough arguments!"
    return 0
  }
}

array set fns {dth %X htd %d dtb %llb}

while 1 {

  # Get user input
  puts -nonewline "> " ; flush stdout ; gets stdin input
  set fn [string tolower [lindex $input 0]]

  # Check if function exists
  if {[info exists fns($fn)]} {

    if {[checkArguments $input]} {

      # Convert value
      puts [format $fns($fn)\
           [expr {"htd" == $fn ? "0x" : ""}][lindex $input 1]]

    }

  # Binary to decimal
  } elseif {"btd" == $fn} {

    if {[checkArguments $input]} {
      puts [expr 0b[lindex $input 1]]
    }

  # End program
  } elseif {"bye" == $fn} {
    puts Bye! ; break

  # Function doesn't exist
  } else {
    puts "Unknown function!"
  }

}
