# find marker position based on text position
proc calculateMarkerPosition { textPosition textHeight windowHeight } {
  return [expr {$textPosition / $textHeight * $windowHeight}]
}

# find text position based on marker position
proc calculateTextPosition { markerPosition textHeight windowHeight } {
  return [expr {$markerPosition / $windowHeight * $textHeight}]
}

set textHeight 200.0
set windowHeight 50.0
set minTextPosition 0
set maxTextPosition [expr {$textHeight - $windowHeight}]
set markerHeight [expr {$windowHeight ** 2 / $textHeight}]

puts "Wysokość tekstu: $textHeight"

puts "Wysokość okna: $windowHeight"

puts "Minimalna pozycja w tekście: $minTextPosition"
puts "Maksymalna pozycja w tekście: $maxTextPosition"

puts "Minimalna pozycja markera: $minTextPosition"
puts "Maksymalna pozycja markera: [expr {$windowHeight - $markerHeight}]"

puts "Rozmiar markera: $markerHeight"

set currentTextPosition 75
set currentMarkerPosition 18.75

puts [calculateMarkerPosition $currentTextPosition $textHeight $windowHeight]
puts [calculateTextPosition $currentMarkerPosition $textHeight $windowHeight]
