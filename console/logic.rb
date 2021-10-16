#!/usr/bin/env ruby

# Logic Programming

# ---------------------------------------------------------

def rule?(fr)
  return 'r' == fr.first
end

def fact?(fr)
  return 'f' == fr.first
end

def askQuestion(q,d)

  for i in 0...d.size do

    fr = d[i]

    if(fact?(fr))
      if q == fr.drop(1) then
        return true
      end
    elsif(rule?(fr)) then
      if q == fr[1] && askQuestion(fr[2],d) then
        return true
      end
    else
      raise 'Error'
    end

  end

  return false

end

# ---------------------------------------------------------

database =
  [['f','happy','yolanda'],
   ['f','listens','mia'],
   ['r',['listens','yolanda'],['happy','yolanda']],
   ['r',['plays','mia'],['listens','mia']],
   ['r',['plays','yolanda'],['listens','yolanda']]]

questions =
  [['happy', 'yolanda'],
   ['listens', 'mia'],
   ['listens', 'yolanda'],
   ['plays', 'mia'],
   ['plays', 'yolanda']]

# ---------------------------------------------------------

answers = Array.new(questions.size)

for i in 0...questions.size do
  answers[i] = askQuestion(questions[i],database)
end

if answers.all? then
  puts 'All tests passed!'
else
  puts 'Some tests failed!'
end

# ---------------------------------------------------------
