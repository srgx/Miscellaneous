include std/math.e

integer days = 60
sequence temperatures = {}
sequence bugsInGround = {}
sequence bugsOutside = {}

main()

function temperatureChange(integer range)
  return rand(range)-(trunc(range/2)+1)
end function

function randomBug()
  integer outTemp = rand(10)+5
  integer hp = rand(4)
  return {outTemp, hp}
end function

procedure createBugs(integer n)
  for i=1 to n do
    bugsInGround = append(bugsInGround,randomBug())
  end for
end procedure

function bugTemperature(sequence bug)
  return bug[1]
end function

procedure main()

  createBugs(1000)
  
  integer averageTemperature = -5

  for i=1 to days do
  
    integer temperature = averageTemperature+temperatureChange(5)
    
    sequence newInGround = {}
    integer count = 0
    
    -- Robaki w ziemi
    for j=1 to length(bugsInGround) do
    
      sequence currentBug = bugsInGround[j]
      
      -- Jeśli temperatura jest odpowiednia i robak ma szczęście
      if temperature >= bugTemperature(currentBug) and rand(6) = 6 then
        count += 1
        bugsOutside = append(bugsOutside,currentBug)
      else
        newInGround = append(newInGround,currentBug)
      end if
      
    end for
    
    bugsInGround = newInGround
    
    
    integer dead = 0
    sequence newOutside = {}
    
    for j=1 to length(bugsOutside) do
    
      if temperature < bugTemperature(bugsOutside[j]) then
        bugsOutside[j][2] -= 1
      end if
      
      if bugsOutside[j][2] > 0 then
        newOutside = append(newOutside,bugsOutside[j])
      else
        dead += 1
      end if
      
    end for
    
    bugsOutside = newOutside
    
    printf(1,"Dzień %d\n",i)
    printf(1,"Temperatura %d\n",temperature)
    printf(1,"Na zewnątrz wyszło %d robaków\n",count)
    printf(1,"Zginęło %d robaków\n",dead)
    temperatures = append(temperatures,temperature)

    if remainder(i,3) = 0 then
      averageTemperature += 1
    end if
  
  end for
  
  printf(1,"W ziemi zostało %d robaków\n",length(bugsInGround))
  printf(1,"Na zewnątrz jest %d robaków\n",length(bugsOutside))
  
end procedure


