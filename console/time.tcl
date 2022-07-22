#!/usr/bin/tclsh

# Time

# ----------------------------------------------------

# Constants
set mih 60 ; set hid 24
set totalMin [expr {$hid*$mih}]

# Conversion function
proc toMinutes {mh} {
  upvar mih m
  return [expr {[lindex $mh 0]*$m+[lindex $mh 1]}]
}

# ----------------------------------------------------

# Input
set start {10 40} ; set stop {12 20}

# ----------------------------------------------------

# Conversion to minutes
set startMin [toMinutes $start]
set stopMin [toMinutes $stop]

# Calculate result
set minutes\
  [expr {$stopMin>=$startMin ?\
    $stopMin-$startMin :
    $totalMin-$startMin+$stopMin}]

# Display result
puts "[expr {$minutes/60}]:[expr {$minutes%60}]"

# ----------------------------------------------------


