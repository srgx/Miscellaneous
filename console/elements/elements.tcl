#!/usr/bin/tclsh

proc readFile {} {
  set fi [open "elements_data.txt" r]
  set fd [read $fi]
  close $fi
  return $fd
}

proc prepareData {} {
  set data [split [readFile] "\n"]
  set le [expr {[llength $data]-1}]
  set data [lreplace $data $le $le]
  set result {}
  for {set i 0} {$i < $le} {incr i 3} {
    set el "[lindex $data $i] {[lindex $data [expr {$i+1}]]}
                               [lindex $data [expr {$i+2}]]"
    lappend result $el
  }
  return $result
}

proc findElement {symbol} {
  upvar 2 data d
  return [lindex $d [lsearch -index 0 $d $symbol]]
}

proc findElementAt {inx var} {
  return [findElement [lindex $var $inx]]
}

proc checkBond {elem1 elem2} {
  set diff [expr {abs([getElectro $elem1]-[getElectro $elem2])}]
  puts -nonewline "Wiązanie "
  if {0 == $diff} {
    puts -nonewline "kowalencyjne niespolaryzowane (atomowe)"
  } elseif {1.7 > $diff} {
    puts -nonewline "kowalencyjne spolaryzowane"
  } else {
    puts -nonewline "jonowe"
  }
  puts " ([format {%.2f} $diff])"
}

proc getValence {elem} {
  return [lindex $elem 1]
}

proc getElectro {elem} {
  return [lindex $elem 2]
}

proc checkAndGet {el fn} {
  if {{} != $el} {
    puts [$fn $el]
  } else {
    unknownElement
  }
}

proc unknownElement {} {
  puts "Nieznany symbol pierwiastka"
}

proc main {} {

  set data [prepareData]

  while 1 {

    puts -nonewline "> "
    flush stdout

    gets stdin input
    set input [string tolower $input]
    set fi [lindex $input 0]

    switch $fi {

      el {
        set el [findElementAt 1 $input]
        checkAndGet $el getElectro
      }

      wa {
        set el [findElementAt 1 $input]
        checkAndGet $el getValence
      }

      wi {
        if {[llength $input]<3} {
          puts "Aby określić rodzaj wiązania, wpisz dwa symbole pierwiastków"
        } else {
          set el1 [findElementAt 1 $input]
          set el2 [findElementAt 2 $input]
          if {$el1 != {} && $el2 != {}} {
            checkBond $el1 $el2
          } else {
            unknownElement
          }
        }
      }

      bye {
        puts "Bye!"
        break
      }

      default {
        puts "Nieprawidłowe polecenie"
      }

    }

  }

}

main
