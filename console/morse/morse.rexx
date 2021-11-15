#!/usr/bin/rexx

/* Morse Code */

file = 'morse_data.txt'

lettersToCodesList. = '|'
codesToLettersList. = ''

/* Read file */
do while lines(file) > 0
  parse value linein(file) with lt cd
  lettersToCodesList.lt = cd
  codesToLettersList.cd = lt
end

/* Close file */
call lineout file

/* Main loop */
do forever
  call charout ,'> '
  pull input
  if input = 'BYE' then
    do
      say 'Bye!'
      leave
    end
  else
    do
      fst = substr(input,1,1)
      if fst = '.' | fst = '-' then
        say translateCodes(input)
      else
        say translateLetters(input)
    end
end

exit 0

translateLetters: procedure expose lettersToCodesList.
  arg letters
  out = ''
  do i = 1 to (length(letters))
    letter = substr(letters,i,1)
    out = out || ' ' || lettersToCodesList.letter
  end
  return out

translateCodes: procedure expose codesToLettersList.
  arg codes
  out = ' '
  do until codes = ''
    parse value codes with first rest
    out = out || codesToLettersList.first
    codes = rest
  end
  return out

