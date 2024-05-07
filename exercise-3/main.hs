import Data.List (maximumBy)
import Data.Ord (comparing)

maxLengthIncreasingSegment :: [Int] -> Int
maxLengthIncreasingSegment [] = 0
maxLengthIncreasingSegment xs = length $ maximumBy (comparing length) $ increasingSegments xs []

increasingSegments :: [Int] -> [Int] -> [[Int]]
increasingSegments [] _ = []
increasingSegments (x : xs) previousSegment
  | null previousSegment || x > head previousSegment = (x : previousSegment) : increasingSegments xs (x : previousSegment)
  | otherwise = previousSegment : increasingSegments xs [x]

main :: IO ()
main = do
  inputNumbers <- getLine
  let numbers = map read (words inputNumbers) :: [Int]
  print (maxLengthIncreasingSegment numbers)
