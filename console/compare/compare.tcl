#!/usr/bin/tclsh
package require struct::set 2.2.3

# ------------------------------------------

proc readFile {name} {
  set file [open $name r]
  set data [read $file]
  close $file
  return $data
}

proc getDatabase {} {
  return [lreplace [split [readFile "database.txt"] "\n"] end end]
}

proc idToSub {id} {
  upvar 2 database db
  return [lindex $db [expr {$id-1}]]
}

proc displayResults {result} {
  for {set i 0} {$i < 3} {incr i} {
    puts [expr {0 == $i ? "Both products contain:" :\
                          "Only product $i contains:"}]
    foreach {id} [lindex $result $i] {
      puts " * [idToSub $id]"
    }
    puts ""
  }
}

# ------------------------------------------

proc main {} {

  puts ""

  # Prepare database
  set database [getDatabase]

  # Read both files
  set fileData1 [readFile "one.txt"]
  set fileData2 [readFile "two.txt"]

  # Compare data
  set result [::struct::set intersect3 $fileData1 $fileData2]

  # Show results
  displayResults $result

}

# ------------------------------------------
main
# ------------------------------------------

