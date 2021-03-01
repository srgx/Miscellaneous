/* Euphoria Logic Programming */


sequence facts = {}

addFact({"woman","mia"})
addFact({"woman","jody"})
addFact({"woman","yolanda"})
addFact({"playsAirGuitar","jody"})
addFact({"loves","vincent","mia"})
addFact({"party"})

showFacts()

procedure addFact(sequence fact)
  facts = append(facts,fact)
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
