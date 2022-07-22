include std/sequence.e
include std/text.e

/*

  uh - variable definition
  eeh, aah, ugh - variable names
  ooh - print

*/

sequence vars = {}

-----------------------------------------------
main()
-----------------------------------------------

procedure main()

  integer tests = 3

  line()

  -- Print integer literal
  processInput("ooh ah ah ah ah ah ah")

  line()

  -- Define and print 1 variable
  processInput("uh eeh ah ; ooh eeh")

  line()

  -- Define and print 2 variables
  processInput("uh eeh ah ; uh aah ah ah ; ooh aah ; ooh eeh")

  line()

  -- Sum 3 variables
  processInput("uh eeh ah ah ah ah ; uh aah ah ah ah ; uh ugh ah ; ooh aah eeh ugh")

  line()

  showVariables()


end procedure

procedure processInput(sequence input)

  sequence lines = split(input,";")

  for i=1 to length(lines) do
    processLine(trim(lines[i]))
  end for

end procedure



procedure processLine(sequence line)

  sequence words = split(line)
  sequence w = words[1]

  if equal(w,"uh") then

    sequence id = words[2]
    sequence result = getDefValue(id)
    words = slice(words,3,length(words))
    integer val = getValue(words)

    if result[1] = 0 then

      -- New variable
      vars = append(vars,{id,val})

    else

      -- Update value
      vars[result[1]][2] = val

    end if

  elsif equal(w,"ooh") then

    words = tail(words)
    integer num = getValue(words)
    printf(1,"%d\n",num)

  end if

end procedure

function getValue(sequence words)

  integer num = 0

  for i=1 to length(words) do

    sequence w = words[i]
    if equal(w,"ah") then
      num += 1
    elsif equal(w,"u") then
      continue
    else
      sequence result = getDefValue(w)
      num += result[2]
    end if

  end for

  return num

end function

function getDefValue(sequence word)
  for i=1 to length(vars) do
    if equal(vars[i][1],word) then
      return {i,vars[i][2]}
    end if
  end for
  return {0,0}
end function

procedure line()
  puts(1,"----------------------\n")
end procedure

procedure showVariables()
  for i=1 to length(vars) do
    printf(1,"%s = %d\n",{vars[i][1],vars[i][2]})
  end for
end procedure

