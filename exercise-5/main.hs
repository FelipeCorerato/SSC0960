import Data.List
import Data.Ord (comparing)
import System.IO

data CountryData = CountryData
  { country :: String,
    confirmed :: Int,
    deaths :: Int,
    recovery :: Int,
    active :: Int
  }
  deriving (Show)

parseLine :: String -> Maybe CountryData
parseLine line = case split ',' line of
  [c, con, d, r, a] -> Just $ CountryData c (read con) (read d) (read r) (read a)
  _ -> Nothing

split :: Char -> String -> [String]
split delim s = case dropWhile (== delim) s of
  "" -> []
  s' -> w : split delim s''
    where
      (w, s'') = break (== delim) s'

readCSV :: FilePath -> IO [CountryData]
readCSV filePath = do
  contents <- readFile filePath
  return $ map parseMaybeLine (lines contents)
  where
    parseMaybeLine line = case parseLine line of
      Just cd -> cd
      Nothing -> error $ "Invalid line: " ++ line

main :: IO ()
main = do
  input <- getLine
  let [n1, n2, n3, n4] = map read (words input) :: [Int]

  countryData <- readCSV "dados.csv"

  let activeSum = sum [active cd | cd <- countryData, confirmed cd >= n1]
  print activeSum

  let topN2ActiveCountries = take n2 $ sortBy (flip (comparing active)) countryData
  let sortedByConfirmed = take n3 $ sortBy (comparing confirmed) topN2ActiveCountries
  let deathsSum = sum [deaths cd | cd <- sortedByConfirmed]
  print deathsSum

  let topN4ConfirmedCountries = take n4 $ sortBy (flip (comparing confirmed)) countryData
  let sortedNames = sort [country cd | cd <- topN4ConfirmedCountries]
  mapM_ putStrLn sortedNames
