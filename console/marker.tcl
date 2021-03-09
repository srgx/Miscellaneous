#!/usr/bin/tclsh

oo::class create Program {

  constructor {} {
  
    variable textHeight 200.0
    variable windowHeight 50.0
    variable minTextPosition 0
    variable maxTextPosition [expr {$textHeight - $windowHeight}]
    variable markerHeight [expr {$windowHeight ** 2 / $textHeight}]
    variable currentTextPosition 75
    variable currentMarkerPosition 18.75
    
  }
  
  method showData {} {
  
    variable textHeight
    variable windowHeight
    variable minTextPosition
    variable maxTextPosition
    variable markerHeight
  
    puts "Wysokość tekstu: $textHeight"

    puts "Wysokość okna: $windowHeight"

    puts "Minimalna pozycja w tekście: $minTextPosition"
    puts "Maksymalna pozycja w tekście: $maxTextPosition"

    puts "Minimalna pozycja markera: $minTextPosition"
    puts "Maksymalna pozycja markera: [expr {$windowHeight - $markerHeight}]"

    puts "Rozmiar markera: $markerHeight"
  }
  
  # Find marker position based on text position
  method calculateMarkerPosition {} {
  
    variable textHeight
    variable windowHeight
    variable currentTextPosition
    
    return [expr {$currentTextPosition / $textHeight * $windowHeight}]
    
  }

  # Find text position based on marker position
  method calculateTextPosition {} {
    
    variable textHeight
    variable windowHeight
    variable currentMarkerPosition
    
    return [expr {$currentMarkerPosition / $windowHeight * $textHeight}]
    
  }
  
  method main {} {
  
    my showData
    
    puts "Pozycja markera: [my calculateMarkerPosition]"
    puts "Pozycja tekstu: [my calculateTextPosition]"
    
  }
  
}


# Main
[Program new] main
