/* Euphoria Logic Programming */
include std/sequence.e


sequence pointers = {}
sequence facts = {}
sequence questions = {}
sequence boundVariables = {}

-----------------------
integer pointer = 1
-----------------------

main()

-----------------------------------------------------------------------------

procedure main()

  newWorld()

  --createDatabase()

  --rules()
  --onlyFacts()


  -- Set pointer
  --firstSession()
  --line()
  --secondSession()
  --line()
  --thirdSession()
  
end procedure

-------------------------------------------------

procedure newWorld()

  addFact({"woman","mia"})
  addFact({"woman","jody"})
  addFact({"woman","yolanda"})
  addFact({"girl","annie"})

  addFact({"playsAirGuitar","jody"})
  addFact({"party"})
  addFact({"woman","mia"})

  addFact({"loves","john","mary"})
  addFact({"loves","peter","mary"})

  --addRule({{"loves","john","X"},{{"woman","X"},{"blabla","X"}}})

  sequence question = {"loves","X","X"}

  for i=1 to 6 do
    sequence result = lookFor(question)
    showResult(result)
  end for

end procedure

function lookFor(sequence question)

  sequence varsToFind = getVarsToFind(question)

  boundVariables = {}

  for i=pointer to length(facts) do

    -- Fact
    if facts[i][1] = 1 then

      if unify(facts[i][2],question) then
        pointer = i + 1
        if 0 = length(varsToFind) then
          return {"b",1}
        else
          return {"v",getVars(varsToFind)}
        end if
      end if

    -- Rule
    elsif facts[i][1] = 2 then

      if unify(facts[i][2][1],question) then
        sequence questions = facts[i][2][2]
      end if

    end if

  end for

  return {"b",0}

end function

function unify(sequence a, sequence b)

  -- Test length
  if length(a) = length(b) then

    -- Already the same
    if equal(a,b) then
      return 1
    else

      sequence tempVars = {}

      for i=1 to length(a) do

        -- X : 12
        if isVariable(a[i]) and (not isVariable(b[i])) then

          sequence val = getBoundValue(tempVars,a[i])
          if equal(val,{}) then
            tempVars = append(tempVars,{a[i], b[i]})
          elsif not equal(val[2],b[i]) then
            return 0
          end if

        -- 12 : X
        elsif isVariable(b[i]) and (not isVariable(a[i])) then

          sequence val = getBoundValue(tempVars,b[i])
          if equal(val,{}) then
            tempVars = append(tempVars,{b[i], a[i]})
          elsif not equal(val[2],a[i]) then
            return 0
          end if

        -- X : Y, X : X
        elsif isVariable(a[i]) and isVariable(a[i]) then

          sequence valA = getBoundValue(tempVars,a[i])
          sequence valB = getBoundValue(tempVars,b[i])

          if equal(valA,{}) and equal(valB,{}) then
            -- ?
          elsif equal(valA,{}) and not equal(valB,{}) then
            tempVars = append(tempVars,{a[i],valB[2]})
          elsif not equal(valA,{}) and equal(valB,{}) then
            tempVars = append(tempVars,{b[i],valA[2]})
          elsif not equal(valA,{}) and not equal(valB,{}) then
            if not equal(a[i],b[i]) then
              return 0
            end if
          end if

        -- 5 : 5, 5 : 7
        else
          if not equal(a[i],b[i]) then
            return 0
          end if
        end if
      end for

      -- Copy after successful unification
      for i=1 to length(tempVars) do
        boundVariables = append(boundVariables,tempVars[i])
      end for

      return 1

    end if
  else
    return 0
  end if

end function

function isVariable(sequence word)
  integer w = word[1]
  return w >= 65 and w < 90
end function

function getVarsToFind(sequence question)

  sequence vars = {}

  for i=1 to length(question) do
    if isVariable(question[i]) and not isMember(vars,question[i]) then
      vars = append(vars,question[i])
    end if
  end for

  return vars

end function

function getVars(sequence varsToFind)

  sequence vars = {}
  for i=1 to length(varsToFind) do
    vars = append(vars,getBoundValue(boundVariables,varsToFind[i]))
  end for

  return vars

end function

function getBoundValue(sequence boundVariables,sequence toFind)
  sequence result = {}
  for i=1 to length(boundVariables) do
    if equal(boundVariables[i][1],toFind) then
      result = boundVariables[i]
      exit
    end if
  end for
  return result
end function

procedure showResult(sequence result)
  if equal(result[1],"b") then
    if result[2] = 1 then
      puts(1,"true\n")
    elsif result[2] = 0 then
      puts(1,"false\n")
    end if
  elsif equal(result[1],"v") then
    for i=1 to length(result[2]) do
      printf(1,"%s - %s\n",{result[2][i][1],result[2][i][2]})
    end for
  else
    puts(1,"Error\n")
  end if
end procedure

procedure addFact(sequence fact)
  facts = append(facts,{1,fact})
end procedure

procedure addRule(sequence rule)
  facts = append(facts,{2,rule})
end procedure

function isMember(sequence list, sequence element)

  for i=1 to length(list) do
    if equal(element,list[i]) then
      return 1
    end if
  end for

  return 0

end function

-------------------------------------------------

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

  --addFact({"f","ala"})
  addFact({"c","ala"})
  addFact({"r","ala"})
  addFact({"c","ola"})
  addFact({"m","ola"})
  addFact({"f","X",":-","c","X",",","m","X"})

end procedure

procedure rules()

  --print(1,askQuestion({"f","something"}))
  print(1,askQuestion({"f","ola"}))
  --print(1,nextAnswer())

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
      if length(variablesToFind) = 0 then
        return {{"true"}}
      else
        for j=1 to length(variablesToFind) do
          result = append(result,getBoundValue(boundVariables,variablesToFind[j]))
        end for
        return result
      end if

    end if

  end while

end function


-- Should only bind variables in head!
procedure bindVars(sequence rule,sequence question)
  for i=1 to length(question) do
    sequence r = rule[i]
    sequence q = question[i]
    if isVariable(r) and not isVariable(q) then
      boundVariables = append(boundVariables,{ r, q })
    end if
  end for
end procedure

function bindQuestion(sequence question)
  sequence result = {}
  for i=1 to length(question) do
    sequence cw = question[i]
    if isVariable(cw) and (not equal(getBoundValue(boundVariables,cw),{})) then
      sequence v = getBoundValue(boundVariables,cw)
      result = append(result,v[2])
    else
      result = append(result,cw)
    end if
  end for
  return result
end function

function bindQuestions(sequence localQuestions)
  sequence result = {}
  for i=1 to length(localQuestions) do
    sequence qst = localQuestions[i]
    result = append(result,bindQuestion(qst))
  end for
  return result
end function

function getQuestionsAndVars(sequence currentFact)

  -- Get variables to find from last question
  sequence variablesToFind = {}
  sequence lastQuestion = questions[length(questions)]
  for j=1 to length(lastQuestion) do
    sequence cw = lastQuestion[j]
    if isVariable(cw) then
      variablesToFind = append(variablesToFind,cw)
    end if
  end for

  integer index = 1
  for j=1 to length(currentFact) do
    if equal(":-",currentFact[j]) then
      index = j+1
      exit
    end if
  end for

  sequence localQuestions = slice(currentFact,index,length(currentFact))
  localQuestions = split(localQuestions,{","})

  -- Fill rule questions with bound variables
  localQuestions = bindQuestions(localQuestions)

  return { localQuestions, variablesToFind }

end function



function processRule(sequence currentFact)

  -- Check if rule head matches
  if checkHead(currentFact,questions[length(questions)]) then


    -- Bind variables from head
    -- If variable from head is not bound
    -- it must be found later

    -- Should only bind variables in head!
    -- Return variables to find
    -- Get raw questions
    -- Process those questions and return
    -- false or necessary variables

    bindVars(currentFact,questions[length(questions)])

    sequence questionsAndVars = getQuestionsAndVars(currentFact)

    -- Go through all questions
    return processLocalQuestions(questionsAndVars[1],questionsAndVars[2],1,0)

  else
    return {{"false"}}
  end if

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

