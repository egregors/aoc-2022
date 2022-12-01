import Data.List

main :: IO ()
main = interact (findNMax 3)

findNMax :: Int -> String -> String
findNMax n xs = show $ sum . take n . reverse . sort . getSums $ lines xs

getSums :: [String] -> [Integer]
getSums xs =
    map
        (sum . map (\n -> read n :: Integer))
        (splitString "" xs)

splitString :: String -> [String] -> [[String]]
splitString _ [] = []
splitString sep str =
    let (left, right) = break (== sep) str
     in left : splitString sep (drop 1 right)
