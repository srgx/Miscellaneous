include std/sequence.e
enum ADD, SUB, MUL, DIV

sequence dictionary = {}
sequence stack = {}

main()

-------------------------------------------------

procedure main()

  push(12)
  push(34)
  push(55)
  
  show()
  
  add()

  show()
  
end procedure

procedure processInput(sequence input)
end procedure

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

procedure drop()
  stack = slice(stack, ,length(stack)-1)
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

procedure over()
  stack = append(stack,stack[length(stack)-1])
end procedure

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

procedure show()
  puts(1,"Stack: ")
  for i=1 to length(stack) do
    printf(1,"%d ",stack[i])
  end for
  puts(1,"\n")
end procedure



