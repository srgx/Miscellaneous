#!/usr/bin/wish

#------------------#
# Definiuj funkcje #
#------------------#

proc every {ms body} {
  eval $body; after $ms [namespace code [info level 0]]
}

proc createShape {cn data color tg} {
  $cn create oval\
  [lindex $data 0] [lindex $data 1]\
  [lindex $data 2] [lindex $data 3]\
  -outline #777\
  -fill $color\
  -tag $tg\
}

#------------------------------------#
# Ustaw pozycje komór i przedsionków #
#------------------------------------#

set a 50
set b 40
set c [expr {$a+50}]
set d [expr {$b+50}]

set leftAtrium "$a $b $c $d"

set a [expr {$a+80}]
set c [expr {$c+80}]

set rightAtrium "$a $b $c $d"

set a 70
set b 150
set c [expr {$a+50}]
set d [expr {$b+50}]

set leftVentricle "$a $b $c $d"

set a [expr {$a+110}]
set c [expr {$c+110}]

set rightVentricle "$a $b $c $d"

#-----------------------------------------#
# Maksymalny rozmiar przedsionków i komór #
#-----------------------------------------#

set maxAtriumSize 10
set maxVentricleSize 15

#-----------------------------------------#
# Tworzenie canvas i obiektów graficznych #
#-----------------------------------------#

canvas .can

createShape .can $leftAtrium blue przedsionek
createShape .can $rightAtrium red przedsionek2

createShape .can $leftVentricle yellow komora
createShape .can $rightVentricle green komora2

pack .can

wm title . "Heart"

#----------------------------------------------#
# Liczba iteracji wzrostu komór i przedsionków #
#----------------------------------------------#

set blood 1
set bigblood 1

#------------------------------------------#
# Aktualny kierunek przepływu krwi w sercu #
#------------------------------------------#

set direction 1

#-----------------------------------------------#
# Szybkość zmiany rozmiaru komór i przedsionków #
#-----------------------------------------------#

set grate 2
set grate2 1

#-----------------------#
# Główna pętla programu #
#-----------------------#

every 40 {

  upvar grate grate
  upvar grate2 grate2

  upvar leftAtrium leftAtrium
  upvar rightAtrium rightAtrium

  upvar leftVentricle leftVentricle
  upvar rightVentricle rightVentricle

  upvar blood blood
  upvar direction direction

  upvar bigblood bigblood

  upvar maxAtriumSize maxAtriumSize
  upvar maxVentricleSize maxVentricleSize

  if {$direction==1} {

    # Komora rosnie do konca cyklu
    set bigblood [expr {$bigblood+1}]

    lset leftVentricle 0 [expr {[lindex $leftVentricle 0]-$grate2}]
    lset leftVentricle 1 [expr {[lindex $leftVentricle 1]-$grate2}]
    lset leftVentricle 2 [expr {[lindex $leftVentricle 2]+$grate2}]
    lset leftVentricle 3 [expr {[lindex $leftVentricle 3]+$grate2}]

    lset rightVentricle 0 [expr {[lindex $rightVentricle 0]-$grate2}]
    lset rightVentricle 1 [expr {[lindex $rightVentricle 1]-$grate2}]
    lset rightVentricle 2 [expr {[lindex $rightVentricle 2]+$grate2}]
    lset rightVentricle 3 [expr {[lindex $rightVentricle 3]+$grate2}]

    # Przedsionek kończy rosnąć po osiągnięciu
    # maksymalnego rozmiaru
    if {$blood < $maxAtriumSize} {

      set blood [expr {$blood+1}]

      lset leftAtrium 0 [expr {[lindex $leftAtrium 0]-$grate2}]
      lset leftAtrium 1 [expr {[lindex $leftAtrium 1]-$grate2}]
      lset leftAtrium 2 [expr {[lindex $leftAtrium 2]+$grate2}]
      lset leftAtrium 3 [expr {[lindex $leftAtrium 3]+$grate2}]

      lset rightAtrium 0 [expr {[lindex $rightAtrium 0]-$grate2}]
      lset rightAtrium 1 [expr {[lindex $rightAtrium 1]-$grate2}]
      lset rightAtrium 2 [expr {[lindex $rightAtrium 2]+$grate2}]
      lset rightAtrium 3 [expr {[lindex $rightAtrium 3]+$grate2}]

    }

  } else {

    # Najpierw kurczy sie przedsionek
    if {$blood >= 2} {

      set blood [expr {$blood-1}]

      lset leftAtrium 0 [expr {[lindex $leftAtrium 0]+$grate2}]
      lset leftAtrium 1 [expr {[lindex $leftAtrium 1]+$grate2}]
      lset leftAtrium 2 [expr {[lindex $leftAtrium 2]-$grate2}]
      lset leftAtrium 3 [expr {[lindex $leftAtrium 3]-$grate2}]

      lset rightAtrium 0 [expr {[lindex $rightAtrium 0]+$grate2}]
      lset rightAtrium 1 [expr {[lindex $rightAtrium 1]+$grate2}]
      lset rightAtrium 2 [expr {[lindex $rightAtrium 2]-$grate2}]
      lset rightAtrium 3 [expr {[lindex $rightAtrium 3]-$grate2}]


    # Później kurczy sie komora
    } else {

      set bigblood [expr {$bigblood-1}]

      lset leftVentricle 0 [expr {[lindex $leftVentricle 0]+$grate2}]
      lset leftVentricle 1 [expr {[lindex $leftVentricle 1]+$grate2}]
      lset leftVentricle 2 [expr {[lindex $leftVentricle 2]-$grate2}]
      lset leftVentricle 3 [expr {[lindex $leftVentricle 3]-$grate2}]

      lset rightVentricle 0 [expr {[lindex $rightVentricle 0]+$grate2}]
      lset rightVentricle 1 [expr {[lindex $rightVentricle 1]+$grate2}]
      lset rightVentricle 2 [expr {[lindex $rightVentricle 2]-$grate2}]
      lset rightVentricle 3 [expr {[lindex $rightVentricle 3]-$grate2}]

    }

  }

  # Aktualizuj obiekty
  .can coords przedsionek\
    [lindex $leftAtrium 0] [lindex $leftAtrium 1]\
    [lindex $leftAtrium 2] [lindex $leftAtrium 3]\

  .can coords przedsionek2\
    [lindex $rightAtrium 0] [lindex $rightAtrium 1]\
    [lindex $rightAtrium 2] [lindex $rightAtrium 3]\

  .can coords komora\
    [lindex $leftVentricle 0] [lindex $leftVentricle 1]\
    [lindex $leftVentricle 2] [lindex $leftVentricle 3]\

  .can coords komora2\
    [lindex $rightVentricle 0] [lindex $rightVentricle 1]\
    [lindex $rightVentricle 2] [lindex $rightVentricle 3]\

  # Aktualizuj kierunek
  if {$bigblood==$maxVentricleSize} {
    set direction 0
  } elseif {$bigblood==1 } {
    set direction 1
  }

}

