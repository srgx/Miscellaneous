/* Euphoria Stack Programming */
-----------------------------------------------------------

include std/sequence.e
include std/get.e
enum ADD, SUB, MUL, DIV
sequence WORDS =
  {"SWAP", "DUP", "OVER", "ROT","DROP",
   "2SWAP", "2DUP", "2OVER", "2DROP",
   "+", "-", "*", "/"}

sequence dictionary = {}
sequence stack = {6,4,2}

main()

-----------------------------------------------------------

procedure processInput(sequence input)
  input = split(input)
  if input[1][1] = 58 and input[length(input)][1] = 59 then
    input = tail(slice(input, ,length(input)-1))
    sequence newDefinition = {input[1]}
    for i=1 to length(input) do
      sequence currentWord = input[i]
      if simpleWord(currentWord) then
        newDefinition = append(newDefinition,currentWord)
      else
        newDefinition = splice(newDefinition,getDefinition(currentWord),length(newDefinition)+1)
      end if
    end for
    dictionary = append(dictionary,newDefinition)
  else
    for i=1 to length(input) do
      execute(input[i])
    end for
  end if
end procedure

procedure main()

  processInput(": POZAR ROT DUP ;")
  processInput(": KALINA SWAP POZAR SWAP POZAR SWAP ;")
  
  puts(1,"Słownik:\n")
  showDictionary()
  
  puts(1,"Stos: ")
  showStack()
  
  processInput("+ + 16 1")
  
  puts(1,"Stos: ")
  showStack()
  
end procedure

-----------------------------------------------------------

procedure push(integer n)
  stack = append(stack,n)
end procedure

procedure swap()
  integer b = length(stack)
  integer a = b-1
  integer temp = stack[b]
  stack[b] = stack[a]
  stack[a] = temp
end procedure

procedure dup()
  stack = append(stack,stack[length(stack)])
end procedure

procedure over()
  stack = append(stack,stack[length(stack)-1])
end procedure

procedure rot()
  integer c = length(stack)
  integer b = c - 1
  integer a = b - 1
  integer temp = stack[a]
  stack[a] = stack[b]
  stack[b] = stack[c]
  stack[c] = temp
end procedure

procedure drop()
  stack = slice(stack, ,length(stack)-1)
end procedure

-----------------------------------------------------------

procedure dup2()
  for i=1 to 2 do
    over()
  end for
end procedure

procedure drop2()
  for i=1 to 2 do
    drop()
  end for
end procedure

procedure swap2()
  integer d = length(stack)
  integer c = d - 1
  integer b = c - 1
  integer a = b - 1
  integer t1 = stack[a]
  integer t2 = stack[b]
  stack[a] = stack[c]
  stack[b] = stack[d]
  stack[c] = t1
  stack[d] = t2
end procedure

procedure over2()
  integer a = length(stack)-3
  integer b = a+1
  stack = append(append(stack,stack[a]),stack[b])
end procedure

-----------------------------------------------------------

procedure add()
  math(ADD)
end procedure

procedure sub()
  math(SUB)
end procedure

procedure mul()
  math(MUL)
end procedure

procedure div()
  math(DIV)
end procedure

procedure math(integer op)
  integer le = length(stack)
  integer v = stack[le]
  integer i = le-1
  switch op do
    case ADD then
      stack[i] += v
    case SUB then
      stack[i] -= v
    case MUL then
      stack[i] *= v
    case DIV then
      stack[i] /= v
  end switch
  drop()  
end procedure

-----------------------------------------------------------

procedure showStack()
  if length(stack) != 0 then
    for i=1 to length(stack) do
      printf(1,"%d ",stack[i])
    end for
    puts(1,"\n")
  else
    puts(1,"empty\n")
  end if
end procedure

procedure showDictionary()
  for i=1 to length(dictionary) do
    sequence definition = dictionary[i]
    for j=1 to length(definition) do
      printf(1,"%s ",{definition[j]})
    end for
    puts(1,"\n")
  end for
end procedure

function simpleWord(sequence w)
  for i=1 to length(WORDS) do
    if equal(w,WORDS[i]) then
      return 1
    end if
  end for
  return 0
end function

function getDefinition(sequence word)
  for i=1 to length(dictionary) do
    sequence definition = dictionary[i]
    if equal(word,definition[1]) then
      return tail(definition)
    end if
  end for
  return {}
end function

procedure execute(sequence word)
  if simpleWord(word) then
    switch word do
      case "+" then
        add()
      case "-" then
        sub()
      case "*" then
        mul()
      case "/" then
        div()
      case "SWAP" then
        swap()
      case "DUP" then
        dup()
      case "OVER" then
        over()
      case "ROT" then
        rot()
      case "DROP" then
        drop()
    end switch
  else
    sequence answer = value(word)
    if answer[1] = GET_SUCCESS then
      push(answer[2])
    else
      puts(1,"Nieprawidłowa wartość\n")
    end if
  end if
end procedure

-----------------------------------------------------------
