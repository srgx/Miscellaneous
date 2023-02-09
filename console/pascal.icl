
// ------------------------------------------------------------------

// Pascal Triangle

// ------------------------------------------------------------------

// Module name
module pascal

// Import predefined functions
import StdEnv

// Combine elements of two lists using function 'fn'
combineLists :: (Int Int -> Int) [Int] [Int] -> [Int]
combineLists fn [] _ = []
combineLists fn [f1:r1] [f2:r2] =
  [fn f1 f2:combineLists fn r1 r2]

// Zero on the left
shiftRight :: [Int] -> [Int]
shiftRight l = [0:l]

// Zero on the right
shiftLeft :: [Int] -> [Int]
shiftLeft [] = [0]
shiftLeft [f:r] = [f:shiftLeft r]

// Generic pascal function
pascal :: (Int Int -> Int) Int -> [Int]
pascal _ 1 = [1]
pascal fn n = let next = pascal fn (n - 1) in
  combineLists fn (shiftLeft next) (shiftRight next)

// Return zero or one
xor :: Int Int -> Int
xor x y = if (x == y) 0 1

// Sum rows
pascalAdd :: (Int -> [Int])
pascalAdd = pascal (+)

// Subtract rows
pascalSub :: (Int -> [Int])
pascalSub = pascal (-)

// Exclusive or
pascalXor :: (Int -> [Int])
pascalXor = pascal xor

// Change function for each row
pascalsHelper :: [Int -> [Int]] [Int -> [Int]] Int Int -> [[Int]]
pascalsHelper cFns fns c l =
  if (c > l)
    []
    case cFns of
      [] = pascalsHelper fns fns c l
      [f:r] = [f c:pascalsHelper r fns (c + 1) l]

// Collect n rows using three functions
pascals :: Int -> [[Int]]
pascals n = let fns = [pascalAdd, pascalSub, pascalXor] in
  pascalsHelper fns fns 1 n

// Map last list element
mapLast :: (Int -> Int) [[Int]] -> [[Int]]
mapLast fn [x:xs]
  | [] == xs = [map fn x:[]]
  | otherwise = [x:mapLast fn xs]

// List product
foldBlast :: [[Int]] -> [[Int]]
foldBlast [x, y] = [[foldr (*) 1 x], y]
foldBlast [x:xs] = [x:foldBlast xs]

// Return function that maps last element
mLast :: ([[Int]] -> [[Int]])
mLast = mapLast (\x -> x + 100)

// Composition operator
(o) infixr 9 :: (b -> c) (a -> b) -> (a -> c)
(o) g f = \x = g (f x)

// Function composition
fComp :: (Int -> [[Int]])
fComp = foldBlast o mLast o pascals

// Infinite list
inf :: Int -> [Int]
inf n = [n : inf (n + 1)]

// List comprehension
lComp :: Int -> [Int]
lComp n = [x * x \\ x <- [1..n]]

// Main expression
Start :: [[Int]]
Start = let n = 3
            vls = take n (inf 10)
            sqs = lComp n
        in  [sqs, vls:fComp 6]

