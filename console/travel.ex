/* Cities & Travel */
-----------------------------------------------------------
include std/mathcons.e
include std/sort.e
include std/search.e
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
  showCities()
  nearest()
  greedy()
  insertion()
  
end procedure

-----------------------------------------------------------

procedure greedy()

  line()
  puts(1,"*** GREEDY ***\n")
  line()
  
  -- All edges sorted
  sequence allEdges = custom_sort(routine_id("byDistance"),collectEdges())
  
  puts(1,"Wszystkie połączenia\n")
  line()
  showEdges(allEdges)
  line()
  
  -- Collected edges
  sequence edges = {}
  
  for i=1 to length(allEdges) do
  
    sequence currentEdge = allEdges[i]
    integer fromCity = currentEdge[1]
    integer toCity = currentEdge[2]
    atom distance = currentEdge[3]
    
    -- City has maximum number of neighbours so this edge cant be used
    if degrees[fromCity] != 2 and degrees[toCity] != 2 then
    
      integer cycleS = cycleSize(fromCity, toCity, edges)
    
      -- Adding currentEdge will create cycle
      if cycleS > 0 then
        if cycleS = nCities then
          edges = append(edges,currentEdge)
          degrees[fromCity] += 1
          degrees[toCity] += 1
          exit
        end if
      else
        edges = append(edges,currentEdge)
        degrees[fromCity] += 1
        degrees[toCity] += 1
      end if
      
    end if
    
  end for
  
  puts(1,"Wybrane połączenia\n")
  line()
  showEdges(edges)
  line()
  
  atom totalDistance = 0
  for i=1 to length(edges) do
    totalDistance += edges[i][3]
  end for
  
  printf(1,"Całkowita odległość %f\n",totalDistance)
  
end procedure

procedure insertion()

  line()
  puts(1,"*** INSERTION ***\n")
  line()
  
  sequence allEdges = collectEdges()
  
  -- Find shortest edge
  sequence shortestEdge = allEdges[1]
  for i=2 to length(allEdges) do
    if allEdges[i][3] < shortestEdge[3] then
      shortestEdge = allEdges[i]
    end if
  end for
  
  -- Shortest edge is initial subtour
  sequence subTourEdges = { shortestEdge }
  
  -- Visited cities
  sequence subTourCities = { shortestEdge[1], shortestEdge[2] }
  
  -- Visit all cities
  while length(subTourCities) < nCities do
  
    -- Find city closest to subtour
    integer bestCity = closestToSubtour(subTourCities)
    
    atom bestBalance = PINF
    integer bestEdge = 0
    sequence edgesToAdd = {}
    
    -- Find best edge to replace with connections to new city 
    for i=1 to length(subTourEdges) do
    
      -- Old connection
      sequence currentEdge = subTourEdges[i]
      
      -- New connections
      atom distanceA = distance(bestCity,currentEdge[1])
      atom distanceB = distance(bestCity,currentEdge[2])
      
      -- Calculate cost of replacing 1 old connection with 2 new
      atom balance = distanceA + distanceB - currentEdge[3]
      
      -- Find best cost and set edges to add
      if balance < bestBalance then
        bestBalance = balance
        bestEdge = i
        edgesToAdd = {{bestCity,currentEdge[1],distanceA},{bestCity,currentEdge[2],distanceB}}
      end if
      
    end for
    
    -- Add visited city
    subTourCities = append(subTourCities,bestCity)
    
    -- Replace old edge with new one
    subTourEdges[bestEdge] = edgesToAdd[1]
    
    -- Add second new edge
    subTourEdges = append(subTourEdges,edgesToAdd[2])
    
  end while
  
  -- Add shortest edge
  subTourEdges = append(subTourEdges,shortestEdge)
  
  -- Calculate total distance
  atom totalDistance = 0
  for i=1 to length(subTourEdges) do
    totalDistance += subTourEdges[i][3]
  end for
  
  puts(1,"Wybrane połączenia\n")
  line()
  showEdges(subTourEdges)
  line()
  
  printf(1,"Całkowita odległość %f\n",totalDistance)
  line()
  
end procedure

procedure nearest()

  line()
  puts(1,"*** NEAREST NEIGHBOR ***\n")
  line()

  -- Visit first random city
  integer index = rand(nCities)
  integer firstCity = index
  visitCity(index)
  
  printf(1,"Początkowe miasto: %d\n",firstCity)
  
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
  
  atom lastStep = distance(firstCity,index)
  
  printf(1,"Do miasta %d, ",firstCity)
  printf(1,"odległość %f\n",lastStep)
  
  totalDistance += lastStep
  
  line()
  printf(1,"Całkowita odległość: %f\n",totalDistance)
  
end procedure

-----------------------------------------------------------

function closestToSubtour(sequence subTourCities)
  atom minDistance = PINF
  integer bestCity = 0
  for i=1 to length(subTourCities) do
    integer subtourCity = subTourCities[i]
    for j=1 to nCities do
      if not is_in_list(j,subTourCities) then
        atom cDistance = distance(subtourCity,j)
        if  cDistance < minDistance then
          bestCity = j
          minDistance = cDistance
        end if
      end if
    end for
  end for
  return bestCity
end function

function cycleSize(integer fromCity, integer toCity, sequence edges)
    integer currentNode = toCity
    sequence visited = { currentNode }
    integer cycleSize = 0
    while 1 do
      integer found = 0
      for j = 1 to length(edges) do
        integer a = edges[j][1]
        integer b = edges[j][2]
        if a = currentNode and not is_in_list(b,visited) then
          currentNode = b
          found = 1
          visited = append(visited,b)
          exit
        elsif b = currentNode and not is_in_list(a,visited) then
          currentNode = a
          found = 1
          visited = append(visited,a)
          exit
        end if
      end for
      if found then
        if currentNode = fromCity then
          cycleSize = length(visited)
          exit
        end if
      else
        exit
      end if
    end while
    return cycleSize
end function

procedure line()
  puts(1,"------------------------------------------\n")
end procedure

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
  
  line()
  puts(1,"*** POZYCJE MIAST ***\n")
  line()

  for i=1 to length(cities) do
    printf(1,"Miasto %d: (%d,%d)\n",{i,cityX(cities[i]),cityY(cities[i])})
  end for
end procedure

function findNearest(integer index)
  
  -- Initial distance is positive infinity
  atom minDistance = PINF
  integer result = 0
  
  for i=1 to length(cities) do
    
    -- Check all unvisited cities
    if not cityVisited(i) then
    
      atom cDistance = distance(index,i)
      
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

-- Edge - {city1: integer, city2: integer, distance: atom}
function collectEdges()
  integer le = length(cities)
  sequence edges = {}
  for i=1 to le-1 do
    for j=i+1 to le do
      edges = append(edges,{i,j,distance(i,j)})
    end for
  end for
  return edges
end function

procedure showEdges(sequence edges)
  for i=1 to length(edges) do
    printf(1,"Między miastami %d i %d, %f\n",{edges[i][1],edges[i][2],edges[i][3]})
  end for
end procedure

function byDistance(sequence a,sequence b)
  return compare(a[3],b[3])
end function

-----------------------------------------------------------

function distance(integer a, integer b)
  return sqrt(squared(cityX(cities[a])-cityX(cities[b]))+squared(cityY(cities[a])-cityY(cities[b])))
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

procedure unvisitCity(integer i)
  cities[i][1] = 0
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
