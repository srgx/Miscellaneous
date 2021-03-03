/* Euphoria Logic Programming */

integer pointer = 1
sequence facts = {}
sequence lastQuestion = ""

main()

-----------------------------------------------------------

procedure main()

  createDatabase()

  firstSession()
  line()
  secondSession()
  
end procedure

procedure addFact(sequence fact)
  facts = append(facts,fact)
end procedure

procedure showAnswer(sequence answer)
  integer le = length(answer)
  if le=1 then
    printf(1,"%s\n",{answer[1]})
  elsif le=2 then
    printf(1,"%s = %s\n",{answer[1],answer[2]})
  end if
end procedure

procedure showFacts()
  for i=1 to length(facts) do
    sequence currentFact = facts[i]
    integer le = length(currentFact)
    printf(1,"%s",{currentFact[1]})
    if le = 1 then
      puts(1,".")
    else
      puts(1,"(")
      for j=2 to le do
        printf(1,"%s",{currentFact[j]})
        if j=le then
          puts(1,").")
        else
          puts(1,",")
        end if
      end for
    end if
    puts(1,"\n")
  end for
end procedure

function askQuestion(sequence question)
  lastQuestion = question
  pointer = 1
  return searchFromPointer()
end function

function nextAnswer()
  return searchFromPointer()
end function

function searchFromPointer()

  integer qlen = length(lastQuestion)

  for i=pointer to length(facts) do
    
    sequence currentFact = facts[i]
    integer flen = length(currentFact)
    
    if qlen != flen then
      continue
    else
    
      integer wrong = 0
      for j=1 to qlen do
      
        sequence currentQuestionWord = lastQuestion[j]
        sequence currentFactWord = currentFact[j]
        integer firstLetter = currentQuestionWord[1]
        
        if firstLetter >= 65 and firstLetter < 90 then
          pointer = i + 1
          return {firstLetter,currentFactWord}
        elsif not equal(currentQuestionWord,currentFactWord) then
          wrong = 1
          exit
        end if
                
      end for
      
      if not wrong then
        pointer = i + 1
        return {"True"}
      end if
      
    end if
    
  end for
  
  return {"False"}
  
end function

procedure createDatabase()

  addFact({"woman","mia"})
  addFact({"woman","jody"})
  addFact({"woman","yolanda"})
  addFact({"playsAirGuitar","jody"})
  addFact({"loves","vincent","mia"})
  addFact({"party"})
  addFact({"woman","mia"})
  
end procedure

procedure firstSession()

  showAnswer(askQuestion({"woman","mia"}))
  
  for i = 1 to 2 do
    showAnswer(nextAnswer())
  end for
  
end procedure

procedure secondSession()

  showAnswer(askQuestion({"woman","X"}))
  
  for i = 1 to 4 do
    showAnswer(nextAnswer())
  end for
  
end procedure

procedure line()
  puts(1,"-----------------\n")
end procedure

