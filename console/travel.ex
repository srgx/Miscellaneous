/* Cities & Travel */
-----------------------------------------------------------
include std/mathcons.e
include std/sort.e
-----------------------------------------------------------
constant nCities = 5
constant distanceRange = 1000
-----------------------------------------------------------
sequence cities = {}
sequence degrees = {}
-----------------------------------------------------------

main()

-----------------------------------------------------------

procedure main()

  createCities(nCities)
  -- showCities()
  
  -- Visit first random city
  integer index = rand(nCities)
  visitCity(index)
  
  printf(1,"Początkowe miasto: %d\n",index)
  
  
  -- Visit other cities
  atom totalDistance = 0
  for i=2 to nCities do
    
    -- Find nearest unvisited city
    sequence answer = findNearest(index)
    
    -- Get answer values
    index = answer[1]
    atom distance = answer[2]
    
    -- Visit new city and add distance
    visitCity(index)
    totalDistance += distance
    
    printf(1,"Do miasta %d, ",index)
    printf(1,"odległość %f\n",distance)
    
  end for
  
  printf(1,"Całkowita odległość: %f\n",totalDistance)
  
  -- Sorted edges
  sequence collected = custom_sort(routine_id("byDistance"),collectEdges())
  
  print(1,collected)
  puts(1,"\n")
  
  -- Number of connected edges
  print(1,degrees)
  puts(1,"\n")
  
end procedure

-----------------------------------------------------------

-- City - {visited: bool, x: integer, y: integer}
procedure createCities(integer numCities)
  for i=1 to numCities do
    degrees = append(degrees,0)
    sequence city = {0}
    for j=1 to 2 do
      city = append(city,rand(distanceRange))
    end for
    cities = append(cities,city)
  end for
end procedure

procedure showCities()
  for i=1 to length(cities) do
    printf(1,"Miasto %d: (%d,%d)\n",{i,cityX(cities[i]),cityY(cities[i])})
  end for
end procedure

function findNearest(integer index)
  
  -- City position
  sequence cityPos = cityPosition(cities[index])
  
  -- Initial distance is positive infinity
  atom minDistance = PINF
  integer result = 0
  
  for i=1 to length(cities) do
    
    -- Check all unvisited cities
    if not cityVisited(i) then
    
      sequence otherPos = cityPosition(cities[i])
      atom cDistance = distance(cityPos,otherPos)
      
      -- City is closer than last candidate
      if cDistance < minDistance then
        minDistance = cDistance
        result = i
      end if
      
    end if
  end for
  
  -- Return nearest city index and distance
  return {result,minDistance}
  
end function

function collectEdges()
  integer le = length(cities)
  sequence edges = {}
  for i=1 to le-1 do
    sequence p1 = cityPosition(cities[i])
    for j=i+1 to le do
      sequence p2 = cityPosition(cities[j])
      edges = append(edges,{i,j,distance(p1,p2)})
    end for
  end for
  return edges
end function

function byDistance(sequence a,sequence b)
  return compare(a[3],b[3])
end function

-----------------------------------------------------------

function distance(sequence a, sequence b)
  return sqrt(squared(a[1]-b[1])+squared(a[2]-b[2]))
end function

function squared(integer n)
  return power(n,2)
end function

function factorial(integer n)
  if n=1 then
    return 1
  else
    return n*factorial(n-1)
  end if
end function

-----------------------------------------------------------

procedure visitCity(integer i)
  cities[i][1] = 1
end procedure

function cityVisited(integer i)
  return cities[i][1]
end function

function cityX(sequence city)
  return city[2]
end function

function cityY(sequence city)
  return city[3]
end function

function cityPosition(sequence city)
  return {cityX(city),cityY(city)}
end function

-----------------------------------------------------------
