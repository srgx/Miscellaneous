#!/usr/bin/tclsh

set buildOutput [exec dylan-compiler -build sudoku.lid]
set output [exec ./_build/bin/sudoku]

puts $buildOutput
puts $output
