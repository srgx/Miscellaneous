/* Stack Programming */
-----------------------------------------------------------

include std/sequence.e
include std/get.e
include std/text.e

enum ADD, SUB, MUL, DIV
sequence WORDS =
  {"SWAP", "DUP", "OVER", "ROT","DROP", "2SWAP",
   "2DUP", "2OVER", "2DROP", ".S", "+", "-", "*", "/"}

sequence dictionary = {}
sequence stack = {}
integer stop = 0

-----------------------------------------------------------

--tests()
main()

-----------------------------------------------------------

procedure main()
  puts(1,"        *** Stack Programming ***\n")
  puts(1,"-----------------------------------------\n")
  puts(1,"Show stack: '.s'. Exit: 'bye'.\n")
  puts(1,"-----------------------------------------\n")
  while 1 do
    sequence line = gets(0)
    processInput(upper(slice(line, ,length(line)-1)))
    if stop then
      exit
    end if
  end while
end procedure

procedure tests()

  processInput(": RODUP ROT DUP ;")
  processInput(": PRO SWAP RODUP SWAP RODUP SWAP ;")
  processInput(": SFUNC + 2 * 66 ;")
  processInput(": FNS SFUNC SFUNC ;")
  
  puts(1,"Dictionary\n")
  showDictionary()

  puts(1,"Stack: ")
  showStack()
  
  processInput("5 6 SFUNC +")
  
  puts(1,"Stack: ")
  showStack()
  
end procedure

-----------------------------------------------------------

procedure addDefinition(sequence input)
  
  -- Drop ':' and ';' symbols
  input = tail(slice(input, ,length(input)-1))
  
  -- First word is definition name
  sequence newDefinition = {input[1]}
  
  -- Add other words
  for i=2 to length(input) do
  
    sequence currentWord = input[i]
    
    -- Simple word
    if simpleWord(currentWord) then
      newDefinition = append(newDefinition,currentWord)
    else
    
      -- Number
      sequence maybeNumber = value(currentWord)
      if maybeNumber[1] = GET_SUCCESS then
        newDefinition = append(newDefinition,currentWord)
        
      -- Previously defined word
      else
      
        sequence definition = getDefinition(currentWord)
        
        if not equal(definition,{}) then
          newDefinition = splice(newDefinition,definition,length(newDefinition)+1)
        else
          puts(1,"Error\n")
        end if
        
      end if
      
    end if
    
  end for
  
  dictionary = append(dictionary,newDefinition)
  
end procedure

-- Execute sequence of simple words
procedure executeWords(sequence input)
  for i=1 to length(input) do
    sequence word = input[i]
    if equal(word,"BYE") then
      stop = 1
      exit
    else
      execute(word)
    end if
  end for
end procedure

-- Check if user input is word definition
function isDefinition(sequence input)
  return input[1][1] = 58 and input[length(input)][1] = 59
end function

-- Process word definition or sequence of words
procedure processInput(sequence input)
  input = split(input)
  if isDefinition(input) then
    addDefinition(input)
  else
    executeWords(input)
  end if
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
  integer le = length(stack)
  if le = 1 then
    stack = {}
  else
    stack = slice(stack, ,le-1)
  end if
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
  integer le = length(stack)
  printf(1,"<%d> ",le)
  if le != 0 then
    for i=1 to le do
      printf(1,"%d ",stack[i])
    end for
    puts(1,"\n")
  else
    puts(1,"--\n")
  end if
end procedure

procedure showDictionary()
  for i=1 to length(dictionary) do
    sequence definition = dictionary[i]
    printf(1,"%s: ",{definition[1]})
    for j=2 to length(definition) do
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

  -- Simple function
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
      case ".S" then
        showStack()
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
      case "2SWAP" then
        swap2()
      case "2DUP" then
        dup2()
      case "2OVER" then
        over2()
      case "2DROP" then
        drop2()
    end switch
  else
  
    -- Defined word
    sequence definition = getDefinition(word)
    if not equal(definition,{}) then
      executeWords(definition)
    else
    
      -- Number
      sequence answer = value(word)
      if answer[1] = GET_SUCCESS then
        push(answer[2])
      else
        puts(1,"Wrong value\n")
      end if
      
    end if
    
  end if
  
end procedure

-----------------------------------------------------------
