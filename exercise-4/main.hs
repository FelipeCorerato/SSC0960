type Roll = Int
type Frame = [Roll]

readRolls :: IO [Roll]
readRolls = do
  map read . words <$> getLine

splitFrames :: [Roll] -> [Frame]
splitFrames [] = []
splitFrames rolls = splitFrames' rolls 1
  where
    splitFrames' :: [Roll] -> Int -> [Frame]
    splitFrames' [] _ = []
    splitFrames' (10 : xs) n
      | n < 10 = [10] : splitFrames' xs (n + 1)
      | otherwise = [[10, head xs, xs !! 1]]
    splitFrames' (x : y : xs) n
      | n == 10 = [[x, y] ++ take 1 xs]
      | x + y == 10 = [x, y] : splitFrames' xs (n + 1)
      | otherwise = [x, y] : splitFrames' xs (n + 1)
    splitFrames' rolls _ = [rolls]

scoreFrame :: [Frame] -> Int
scoreFrame [] = 0
scoreFrame ([x] : xs) = x + strikeBonus xs + scoreFrame xs
scoreFrame ([x, y] : xs)
  | x + y == 10 = x + y + spareBonus xs + scoreFrame xs
  | otherwise = x + y + scoreFrame xs
scoreFrame (frame : xs) = sum frame + scoreFrame xs

strikeBonus :: [Frame] -> Int
strikeBonus (x : y : _) = sum (take 2 (x ++ y))
strikeBonus (x : _) = sum (take 2 x)
strikeBonus _ = 0

spareBonus :: [Frame] -> Int
spareBonus (x : _) = head x
spareBonus _ = 0

formatFrame :: Frame -> String
formatFrame [10] = "X _"
formatFrame [x, y]
  | x + y == 10 = show x ++ " /"
  | otherwise = show x ++ " " ++ show y
formatFrame [10, x, y]
  | x == 10 && y == 10 = "X X X"
  | x == 10 = "X X " ++ formatRoll y
  | x + y == 10 = "X " ++ show x ++ " /"
  | otherwise = "X " ++ show x ++ " " ++ show y
formatFrame [x, y, z]
  | x + y == 10 && z == 10 = show x ++ " / X"
  | x + y == 10 = show x ++ " / " ++ show z
  | otherwise = show x ++ " " ++ show y ++ " " ++ show z
formatFrame rolls = unwords (map show rolls)

formatRoll :: Roll -> String
formatRoll 10 = "X"
formatRoll x = show x

main :: IO ()
main = do
  rolls <- readRolls
  let frames = splitFrames rolls
  putStrLn $ formatFramesAndScore frames (scoreFrame frames)

formatFramesAndScore :: [Frame] -> Int -> String
formatFramesAndScore frames score =
  unwords (map (\frame -> formatFrame frame ++ " |") (init frames)) ++ " " ++ formatFrame (last frames) ++ " | " ++ show score
