main :: IO ()
main = interact findMax

findMax :: String -> String
findMax xs =
    show $
        maximum $
            map
                (sum . map (\n -> read n :: Integer))
                (splitString "" $ lines xs)

splitString :: String -> [String] -> [[String]]
splitString _ [] = []
splitString sep str =
    let (left, right) = break (== sep) str
     in left : splitString sep (drop 1 right)
