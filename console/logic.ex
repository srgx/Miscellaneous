/* Euphoria Logic Programming */
include std/sequence.e


sequence pointers = {}
sequence facts = {}
sequence questions = {}
sequence boundVariables = {}

main()

-----------------------------------------------------------------------------

procedure main()

  createDatabase()

  rules()

  onlyFacts()
  
  --firstSession()
  --line()
  --secondSession()
  --line()
  --thirdSession()
  
end procedure

procedure rules()

  sequence tests = {}
  sequence session = {}

  session = append(session,askQuestion({"f","X"}))
  session = append(session,nextAnswer())

  integer test = equal(session,{{{"X","ola"}},{{"false"}}})

  tests = append(tests,test)

  showTests(tests)

end procedure

procedure onlyFacts()
  
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

  session = {}

  session = append(session,askQuestion({"likes","X","X"}))
  session = append(session,nextAnswer())

  test = equal(session,{{{"X","mia"}},{{"false"}}})

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

-- Start new search
function askQuestion(sequence question)
  questions = { question }
  pointers = { 1 }
  boundVariables = {}
  return searchFromPointer()
end function

-- More questions
function askQuestionInside(sequence question)
  questions = append(questions,question)
  pointers = append(pointers,1)
  return searchFromPointer()
end function

function resatisfy(sequence rule)
  sequence qvs = getQuestionsAndVars(rule)
  sequence questions = qvs[1]
  sequence variables = qvs[2]
  integer ruleIndex = length(questions)
  return processLocalQuestions(questions,variables,ruleIndex,1)
end function

function nextAnswer()

  if isRule(facts[pointers[1]]) then
    sequence result = resatisfy(facts[pointers[1]])
    if equal(result,{{"false"}}) then
      pointers = { pointers[1] + 1 }
    else
      return result
    end if
  else
    boundVariables = {}
    return searchFromPointer()
  end if

  puts(1,"No more answers\n")

  return {{"false"}}

end function

function isVariable(sequence word)
  integer w = word[1]
  return w >= 65 and w < 90
end function

function checkHead(sequence rule,sequence question)
  for i=1 to length(question) do
    sequence r = rule[i]
    sequence q = question[i]
    if equal(r,":-") or (not equal(r,q) and not isVariable(r) and not isVariable(q)) then
      return 0
    end if
  end for
  return equal(rule[length(question)+1],":-")
end function

function getBoundValue(sequence toFind)
  sequence result = {}
  for i=1 to length(boundVariables) do
    if equal(boundVariables[i][1],toFind) then
      result = boundVariables[i]
      exit
    end if
  end for
  return result
end function

function processLocalQuestions(sequence localQuestions,sequence variablesToFind, integer ruleIndex, integer backtracking)

  sequence result = {}
  sequence temp = {}

  while 1 do

    if backtracking then
      temp = searchFromPointer()
    else
      temp = askQuestionInside(localQuestions[ruleIndex])
    end if

    if equal(temp,{{"false"}}) then
      pointers = removeLast(pointers)
      questions = removeLast(questions)
      boundVariables = removeLast(boundVariables) -- Which variable should be removed?
      ruleIndex -= 1
      backtracking = 1
    else
      ruleIndex += 1
      backtracking = 0
    end if

    if ruleIndex = 0 then
      return {{"false"}}
    elsif ruleIndex = length(localQuestions)+1 then
      for j=1 to length(variablesToFind) do
        result = append(result,getBoundValue(variablesToFind[j]))
      end for
      return result
    end if

  end while

end function

function getQuestionsAndVars(sequence currentFact)

  sequence variablesToFind = {}
  integer index = 1
  for j=1 to length(currentFact) do
    sequence cf = currentFact[j]
    if equal(":-",cf) then
      index = j+1
      exit
    elsif isVariable(cf) then
      variablesToFind = append(variablesToFind,cf)
    end if
  end for

  sequence localQuestions = slice(currentFact,index,length(currentFact))
  localQuestions = split(localQuestions,{","})

  return { localQuestions, variablesToFind }

end function

function processRule(sequence currentFact)

  -- Check if rule head matches
  if not checkHead(currentFact,questions[length(questions)]) then
    return {{"false"}}
  end if

  sequence questionsAndVars = getQuestionsAndVars(currentFact)

  -- Go through all questions
  return processLocalQuestions(questionsAndVars[1],questionsAndVars[2],1,0)

end function

function processFact(sequence currentFact)

  -- Increment pointer value
  pointers[length(pointers)] += 1

  -- Get question and fact lenghts
  integer qlen = length(questions[length(questions)])
  integer flen = length(currentFact)

  -- If lenghts are the same compare them
  if qlen = flen then

    -- Go through all words in question
    for j=1 to qlen do

      -- Get both words
      sequence currentQuestionWord = questions[length(questions)][j]
      sequence currentFactWord = currentFact[j]

      -- Variable in question
      if isVariable(currentQuestionWord) then

        -- Check is variable is already bound
        integer exists = 0
        for k=1 to length(boundVariables) do

          if equal(boundVariables[k][1],currentQuestionWord) then

            -- Return false if bound value doesnt match
            if not equal(boundVariables[k][2],currentFactWord) then
              return {{"false"}}
            else
              -- Save information that variable is bound and exit loop
              exists = 1
              exit
            end if
          end if
        end for

        -- Add new bound variable
        if not exists then
          boundVariables = append(boundVariables,{currentQuestionWord,currentFactWord})
        end if

      -- Return false because words dont match
      elsif not equal(currentQuestionWord,currentFactWord) then
        return {{"false"}}
      end if

    end for

    -- Return bound variables or true
    if not equal(boundVariables,{}) then
      return boundVariables
    else
      return {{"true"}}
    end if

  -- Lenghts are wrong so return false
  else
    return {{"false"}}
  end if

end function

function searchFromPointer()

  sequence result

  -- Search database starting from pointer
  for i=pointers[length(pointers)] to length(facts) do

    -- Get i'th fact or rule from database
    sequence currentFact = facts[i]

    -- Match last question with rule or fact
    if isRule(currentFact) then

      result = processRule(currentFact)
      if not equal(result,{{"false"}}) then
        return result
      end if

    else

      -- Go to next iteration if result is false
      -- Otherwise return answer
      result = processFact(currentFact)
      if not equal(result,{{"false"}}) then
        return result
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

  addFact({"likes","mia","mia"})

  addFact({"car","vw_beatle"})
  addFact({"car","ford_escort"})
  addFact({"bike","harley_davidson"})
  addFact({"red","vw_beatle"})
  addFact({"red","ford_escort"})
  addFact({"blue","harley_davidson"})

  addFact({"mortal","plato"})
  addFact({"human","socrates"})

--   addFact({"fun","X",":-","red","X",",","car","X"})
--
--   addFact({"fun","X",":-","blue","X",",","bike","X"})
--   addFact({"mortal","X",":-","human","X"})

  addFact({"c","ala"})
  addFact({"r","ala"})
  addFact({"c","ola"})
  addFact({"m","ola"})
  addFact({"f","X",":-","c","X",",","m","X"})
  
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

function removeLast(sequence lst)
  if length(lst) = 1 then
    return {}
  else
    return slice(lst,1,length(lst)-1)
  end if
end function

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

