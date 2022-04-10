#!/usr/bin/env ruby

# Logic Programming

# ---------------------------------------------------------
SU = 'All tests passed!'
FA = 'Some tests failed!'
# ---------------------------------------------------------

def rule?(fr)
  return 'r' == fr.first
end

def fact?(fr)
  return 'f' == fr.first
end

def testSuccess(qs,db,fu)
  puts method(fu).call(qs,db) ? SU : FA
end

def runTests(qs,db)
  testSuccess(qs,db,:askAllQuestions)
end

def runTestsAllFail(qs,db)
  testSuccess(qs,db,:askAllQuestionsFail)
end

def testAll(qs,db,fu)
  for i in 0...qs.size do
    if method(fu).call(qs[i],db) then
      return false
    end
  end
  return true
end

def askAllQuestionsFail(qs,db)
  return testAll(qs,db,:askQuestion)
end

def askAllQuestions(qs,db)
  return testAll(qs,db,:askQuestionNot)
end

def askQuestion(qs,db)
  for i in 0...db.size do
    fr = db[i]
    if(fact?(fr))
      if qs == fr.drop(1) then
        return true
      end
    elsif(rule?(fr)) then
      if qs == fr[1] && askAllQuestions(fr.drop(2),db) then
        return true
      end
    else
      raise 'Error'
    end
  end
  return false
end

def askQuestionNot(qs,db)
  return !askQuestion(qs,db)
end

# ---------------------------------------------------------

database_1 =
  [['f','party'],
   ['f','happy','yolanda'],
   ['f','listens','mia'],
   ['r',['listens','yolanda'],
        ['happy','yolanda']],
   ['r',['plays','mia'],
        ['listens','mia']],
   ['r',['plays','yolanda'],
        ['listens','yolanda']]]

questions_1 =
  [['party'],
   ['happy','yolanda'],
   ['listens','mia'],
   ['listens','yolanda'],
   ['plays','mia'],
   ['plays','yolanda']]

fail_questions_1 =
  [['concerto'],
   ['happy','mia']]

# ---------------------------------------------------------

database_2 =
  [['f','happy','vincent'],
   ['f','listens','butch'],
   ['r',['plays','vincent'],
        ['listens','vincent'],['happy','vincent']],
   ['r',['plays','butch'],
        ['happy','butch']],
   ['r',['plays','butch'],
        ['listens','butch']]]

questions_2 =
  [['happy', 'vincent'],
   ['listens', 'butch'],
   ['plays', 'butch']]

fail_questions_2 =
  [['plays', 'vincent'],
   ['happy', 'butch']]

# ---------------------------------------------------------

print 'Set 1: '
runTests(questions_1,database_1)

print 'Set 2: '
runTests(questions_2,database_2)

print 'Set 3: '
runTestsAllFail(fail_questions_1,database_1)

print 'Set 4: '
runTestsAllFail(fail_questions_2,database_2)

# ---------------------------------------------------------
