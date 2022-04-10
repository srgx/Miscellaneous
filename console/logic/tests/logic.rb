#!/usr/bin/env ruby

$database = []

def isVariable(w)
  l = w[0]
  return l == l.upcase
end

def addFact(fact)
  $database.push(["f",fact])
end

def getVariablesToFind(q)
  vars = []
  q.each do |w|
    if isVariable(w) and not vars.member?(w)
      vars.push(w)
    end
  end
  return vars
end

addFact(["woman","mia"])
addFact(["woman","jody"])
addFact(["woman","yolanda"])
addFact(["woman","mia"])

class Context

  def initialize
    @pointer = 0
  end

  def askQuestion(q)
    variablesToFind = getVariablesToFind(q)
    for i in @pointer...$database.size do
      if $database[i][1] == q
        @pointer = i + 1
        return true
      end
    end
    @pointer = 0
    return false
  end

end

c = Context.new
puts c.askQuestion(["woman","mia"])
