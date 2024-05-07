isPrime :: Int -> Int -> Bool
isPrime n i
  | n <= 1 || n `mod` i == 0 = False
  | n <= 3 || i * i > n = True
  | otherwise = isPrime n (i + 1)

findNextPrime :: Int -> Int -> Maybe Int
findNextPrime current end
  | current > end = Nothing
  | isPrime current 2 = Just current
  | otherwise = findNextPrime (current + 1) end

primeInterval :: Int -> Int -> Maybe Int -> Int
primeInterval x y lastPrime
  | x > y = 0
  | otherwise = case findNextPrime x y of
      Nothing -> 0
      Just nextPrime -> let interval = maybe 0 (nextPrime -) lastPrime
                        in max interval (primeInterval (nextPrime + 1) y (Just nextPrime))

largestPrimeInterval :: Int -> Int -> Int
largestPrimeInterval x y = primeInterval x y Nothing

main :: IO ()
main = do
  x <- readLn
  y <- readLn
  print $ largestPrimeInterval x y