/* Euphoria Logic Programming */
include std/sequence.e

integer pointer = 1
sequence facts = {}
sequence lastQuestion = ""
sequence boundVariables = {}

main()

-----------------------------------------------------------------------------

procedure main()

  createDatabase()
  
  onlyFacts()
  
  --firstSession()
  --line()
  --secondSession()
  --line()
  --thirdSession()
  
end procedure

procedure onlyFacts()
  
  sequence message = "!!!!ERROR!!!!"
  sequence tests = {}
  
  -----------------------------------------------------------------------------
  
  sequence session = {}
  
  session = append(session,askQuestion({"woman","mia"}))
  
  for i=1 to 2 do
    session = append(session,nextAnswer())
  end for
  
  integer test = equal(session,{{{"true"}},{{"true"}},{{"false"}}})
  
  tests = append(tests,test)
  
  -----------------------------------------------------------------------------
  
  session = {}
  
  session = append(session,askQuestion({"woman","Name"}))
  
  for i=1 to 4 do
    session = append(session,nextAnswer())
  end for
  
  test = equal(session,{{{"Name","mia"}},{{"Name","jody"}},
                        {{"Name","yolanda"}},{{"Name","mia"}},{{"false"}}})
            
  
  tests = append(tests,test)
  
  -----------------------------------------------------------------------------
  
  session = {}
  
  session = append(session,askQuestion({"loves","First","Second"}))
  
  for i=1 to 4 do
    session = append(session,nextAnswer())
  end for
    
  test = equal(session,
    {{{"First","vincent"},{"Second","mia"}},
    {{"First","victoria"},{"Second","robin"}},
    {{"First","amanda"},{"Second","gregg"}},
    {{"First","joan"},{"Second","shawna"}},{{"false"}}})
  
  tests = append(tests,test)
  
  -----------------------------------------------------------------------------
  
  session = {}
  
  session = append(session,askQuestion({"loves","First","First"}))
  
  test = equal(session,{{{"false"}}})
  
  tests = append(tests,test)
  
  -----------------------------------------------------------------------------
  
  showTests(tests)
  
  -----------------------------------------------------------------------------
  
end procedure

-----------------------------------------------------------------------------

procedure addFact(sequence fact)
  facts = append(facts,fact)
end procedure

procedure showAnswer(sequence answer)
  integer le = length(answer)
  if le=1 then
    printf(1,"%s",{answer[1]})
  elsif le=2 then
    printf(1,"%s = %s",{answer[1],answer[2]})
  end if
end procedure

procedure showSession(sequence session)
  for i=1 to length(session) do
    for j=1 to length(session[i]) do
      showAnswer(session[i][j])
      if j != length(session[i]) then
        puts(1,",")
      end if
      puts(1,"\n")
    end for
  end for
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
  boundVariables = {}
  return searchFromPointer()
end function

function searchFromPointer()

  integer qlen = length(lastQuestion)

  for i=pointer to length(facts) do
    
    sequence currentFact = facts[i]
    integer flen = length(currentFact)
    
    if isRule(currentFact) then
      
      integer index = 1
      for j=1 to length(currentFact) do
        if equal(":-",currentFact[j]) then
          index = j+1
          exit
        end if
      end for
      
      -- Lista pytań rozdzielonych przecinkami
      sequence questions = slice(currentFact,index,length(currentFact))
      
      questions = split(questions,{","})
      
      -- Sprawdź po kolei wszystkie warunki
      -- Jeśli wszystkie są spełnione zwróć
      -- odpowiedni wynik
      puts(1,"Warunki do spełnienia:\n")
      for j=1 to length(questions) do
      
        sequence condition = questions[j]
        print(1,condition)
        
        askQuestion(condition)
        
      end for
      puts(1,"\n--------\n")
      
    else
      
      if qlen = flen then
    
        integer error = 0
        
        for j=1 to qlen do
        
          sequence currentQuestionWord = lastQuestion[j]
          sequence currentFactWord = currentFact[j]
          integer firstLetter = currentQuestionWord[1]
          
          if firstLetter >= 65 and firstLetter < 90 then
            
            for k=1 to length(boundVariables) do
              if equal(boundVariables[k][1],currentQuestionWord) then
                error = 1
                exit
              end if
            end for
            
            if error then
              exit
            else
              boundVariables = append(boundVariables,{currentQuestionWord,currentFactWord})
            end if
            
          elsif not equal(currentQuestionWord,currentFactWord) then
            error = 1
            exit
          end if
          
        end for
        
        if error then
          boundVariables = {}
        else
          pointer = i + 1
          if not equal(boundVariables,{}) then
            return boundVariables
          else
            return {{"true"}}
          end if
        end if
      
      end if
      
    end if
    
  end for
  
  return {{"false"}}
  
end function

procedure createDatabase()

  addFact({"woman","mia"})
  addFact({"woman","jody"})
  addFact({"woman","yolanda"})
  addFact({"playsAirGuitar","jody"})
  addFact({"party"})
  addFact({"woman","mia"})
  
  addFact({"loves","vincent","mia"})
  addFact({"loves","victoria","robin"})
  addFact({"loves","amanda","gregg"})
  addFact({"loves","joan","shawna"})
  
  addFact({"car","vw_beatle"})
  addFact({"car","ford_escort"})
  addFact({"bike","harley_davidson"})
  addFact({"red","vw_beatle"})
  addFact({"red","ford_escort"})
  addFact({"blue","harley_davidson"})
  
  addFact({"mortal","plato"})
  addFact({"human","socrates"})
  
  --addFact({"fun","X",":-","red","X",",","car","X"})
  --addFact({"fun","X",":-","blue","X",",","bike","X"})
  --addFact({"mortal","X",":-","human","X"})
  
end procedure

procedure secondSession()

  showAnswer(askQuestion({"woman","X"}))
  
  for i = 1 to 4 do
    showAnswer(nextAnswer())
  end for
  
end procedure

procedure thirdSession()
  showAnswer(askQuestion({"mortal","socrates"}))
end procedure

procedure line()
  puts(1,"-----------------\n")
end procedure

function isRule(sequence w)
  for i=1 to length(w) do
    if equal(w[i],":-") then
      return 1
    end if
  end for
  return 0
end function

procedure showTests(sequence tests)

  integer p = 0
  integer l = length(tests)
  
  for i=1 to l do
    integer t = tests[i]
    printf(1,"%d ",t)
    p += t
  end for
  
  printf(1,"\nTests: %d/%d\n",{p,l})
  
end procedure

