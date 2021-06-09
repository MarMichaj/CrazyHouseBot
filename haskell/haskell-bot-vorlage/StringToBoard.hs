module StringToBoard where

import DataTypes
import Util

--computes Board state from input string
-- this function uses strToWhites, strToBlacks, strToFrees
strToBoard :: String -> Board
strToBoard s = let l = getBoardList s in Board (listToWhites l) (listToBlacks l) (listToFrees l)


--
--begin: subfunctions of strToBoard begin
--

--turns input string into list of strings, representing rows and pocket
getBoardList :: String ->[String]
getBoardList str = stripPlayer (splitOn '/' str)
-- strips List of board rows (and pocket) of player char   
stripPlayer :: [String] -> [String]
stripPlayer [] = []
stripPlayer (x:xs) = if xs == [] then [head (splitOn ' ' x)] else x:stripPlayer xs
    --if null xs then ((head (tail (splitOn ' ' x))):xs) else x:stripPlayer xs

 

--
--Whites
--

--input: List of Strings of rows and pocket
--output: white pieces
--calls listToWhitesCount with row number 8
listToWhites :: [String] -> [Piece]
listToWhites s = listToWhitesCount s 8

--input: List of Strings of rows and pocket with row counter i
--output: white pieces
listToWhitesCount :: [String] -> Int -> [Piece]
listToWhitesCount [] _ = []
listToWhitesCount (x:xs) i = if i>0 then (rowStringToWhites x 1 i) ++ (listToWhitesCount xs (i-1)) else pocketStringToWhites x

--input: single row decoded as string, x-coordinate of current char (should be 1 for first call), y-coordinate of row
--output: white pieces in that row
rowStringToWhites :: String -> Int -> Int-> [Piece]
rowStringToWhites []_ _=  []
rowStringToWhites (c : cs) x y
  | isWhiteChar c
  = [White (Pos x y) c] ++ (rowStringToWhites cs (x + 1) y)
  | isInt c = rowStringToWhites cs (x + charToInt c) y
  | otherwise = rowStringToWhites cs (x + 1) y                      
                                        
--input: pocket decoded as string
--output: white pieces in pocket
pocketStringToWhites :: String -> [Piece]
pocketStringToWhites [] = []
pocketStringToWhites (c:cs) = if isWhiteChar c
                                 then ([White(Pos 0 0) c] ++ (pocketStringToWhites cs))
                                 else pocketStringToWhites cs

isWhiteChar :: Char -> Bool
isWhiteChar c = c `elem` ['K','Q','B','R','N','P']

--
--Blacks
--

--input: List of Strings of rows and pocket
--output: black pieces
--calls listToBlacksCount with row number 8
listToBlacks :: [String] -> [Piece]
listToBlacks s = listToBlacksCount s 8

--input: List of Strings of rows and pocket with row counter i
--output: black pieces
listToBlacksCount :: [String] -> Int -> [Piece]
listToBlacksCount [] _ = []
listToBlacksCount (x:xs) i = if i>0 then ((rowStringToBlacks x 1 i)++(listToBlacksCount xs (i-1))) else pocketStringToBlacks x

--input: single row decoded as string, x-coordinate of current char (should be 1 for first call), y-coordinate of row
--output: black pieces in that row
rowStringToBlacks :: String -> Int -> Int-> [Piece]
rowStringToBlacks []_ _=  []
rowStringToBlacks (c : cs) x y
  | isBlackChar c
  = ([Black (Pos x y) c] ++ (rowStringToBlacks cs (x + 1) y))
  | isInt c = rowStringToBlacks cs (x + charToInt c) y
  | otherwise = rowStringToBlacks cs (x + 1) y

--input: pocket decoded as string
--output: black pieces in pocket
pocketStringToBlacks :: String -> [Piece]
pocketStringToBlacks [] = []
pocketStringToBlacks (c:cs) = if isBlackChar c
                                 then ( [Black(Pos 0 0) c] ++ (pocketStringToBlacks cs))
                                 else pocketStringToBlacks cs

isBlackChar :: Char -> Bool
isBlackChar c = c `elem` ['k','q','b','r','n','p']

--
--Frees
--

--input: List of Strings of rows and pocket
--output: free positions on board
--calls listToFreesCount with row number 8
listToFrees :: [String] -> [Pos]
listToFrees s = listToFreesCount s 8

--input: List of Strings of rows and pocket with row counter i
--output: free positions on board
listToFreesCount :: [String] -> Int -> [Pos]
listToFreesCount [] _ = []
listToFreesCount (x:xs) 0 = []
listToFreesCount (x:xs) i = (rowStringToFrees x 1 i) ++ (listToFreesCount xs (i-1))



--input: single row decoded as string, x-coordinate of current char (should be 1 for first call), y-coordinate of row
--output: free positions in that row
rowStringToFrees :: String -> Int -> Int -> [Pos]
rowStringToFrees [] _ _ = []
rowStringToFrees (c:cs) i j = if isInt c
                                then(  if (c/='0')
                                    then ( [Pos i j] ++ (rowStringToFrees ((intToChar((charToInt c)-1)):cs) (i+1) j) )
                                    else (rowStringToFrees cs (i) j)
                                  )else (rowStringToFrees cs (i+1) j)
                                        
                    

--
--Integer-Char Operations:
--

isInt :: Char -> Bool
isInt c = c `elem` ['0','1','2','3','4','5','6','7','8','9']

charToInt :: Char -> Int
charToInt '1' = 1
charToInt '2' = 2
charToInt '3' = 3
charToInt '4' = 4
charToInt '5' = 5
charToInt '6' = 6
charToInt '7' = 7
charToInt '8' = 8
charToInt _ = 0

intToChar :: Int -> Char
intToChar  1 = '1'
intToChar  2 = '2'
intToChar  3 = '3'
intToChar  4 = '4'
intToChar  5 = '5'
intToChar  6 = '6'
intToChar  7 = '7'
intToChar  8 = '8'
intToChar  9 = '9'
intToChar  _ = '0'


--
--end: subfunctions of stringToBoard begin
--
