-- module (NICHT ÄNDERN!)
module CrazyhouseBot
    ( getMove
    , listMoves
    ) 
    where

import Data.Char
-- Weitere Modulen können hier importiert werden

import Util


--- external signatures (NICHT ÄNDERN!)
getMove :: String -> String
getMove = _getMoveImpl -- YOUR IMPLEMENTATION HERE


listMoves :: String -> String
listMoves = _listMovesImpl -- YOUR IMPLEMENTATION HERE

--TODO : get signature right (_implementationGetMoves...)
_listMovesImpl :: String -> String
_listMovesImpl str = movesToString (filterCheck (playersTurn str) (boardToMoves (playersTurn str) (strToBoard str)) ((strToBoard str)))

_getMoveImpl :: String -> String
_getMoveImpl str = show( head (filterCheck (playersTurn str) (boardToMoves (playersTurn str) (strToBoard str)) ((strToBoard str))))

-- YOUR IMPLEMENTATION FOLLOWS HERE

--
--main functions
--
--determines from input string whose player's turn it is
playersTurn :: String -> String
playersTurn s = last (splitOn ' ' s)


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

--
-- computes valid Moves, given board state and whose player's turn
-- input: player, Board, output : Moves

boardToMoves :: String -> Board -> [Move]
boardToMoves s bo = if (s=="w") then (filterDublicatesM (validMovesW (whites(bo)) bo))  
                                else (if (s=="b") then (filterDublicatesM (validMovesB (blacks(bo)) bo)) 
                                                  else ([]))

--
--Whites
--
                                                 
--input: whites(Board), Board
--output: valid Moves for player white                                                 
validMovesW :: [Piece] -> Board -> [Move]
validMovesW [] _ = []
validMovesW (w:ws) bo = thisValidMovesW w bo ++ validMovesW ws bo

--input: White Piece, blacks(Board), frees(Board)
--output: valid moves with this white piece
thisValidMovesW :: Piece -> Board -> [Move]
thisValidMovesW w bo = (thisValidMovesCapW w ( filterPocketPieces (blacks(bo))) bo) ++ (thisValidMovesFreeW w (frees(bo)) bo)



--
--Blacks
--

--input: blacks(Board), Board
--output: valid Moves for player blacks
validMovesB :: [Piece] -> Board -> [Move]
validMovesB [] _ = []
validMovesB (b:bs) bo = thisValidMovesB b bo ++ validMovesB bs bo

--input: Black Piece, Board
--output: valid moves with this black piece
thisValidMovesB :: Piece -> Board -> [Move]
thisValidMovesB b bo = (thisValidMovesCapB b ( filterPocketPieces (whites(bo))) bo) ++ (thisValidMovesFreeB b (frees(bo)) bo)

-- filters pocket pieces out of a list of pieces
filterPocketPieces :: [Piece] -> [Piece] 
filterPocketPieces [] = []
filterPocketPieces (p:ps) = case p of
                                 White po c -> if (po == (Pos 0 0)) then (filterPocketPieces ps) else (p:(filterPocketPieces ps))
                                 Black po c -> if (po == (Pos 0 0)) then (filterPocketPieces ps) else (p:(filterPocketPieces ps))
                                 
                                 
--
--Whites : Begin
--

--input: white Piece, blacks(Board), Board
--output: valid capture moves for this white piece
thisValidMovesCapW :: Piece -> [Piece] -> Board -> [Move]
thisValidMovesCapW _ [] _ = []
thisValidMovesCapW w (b:bs) bo = if thisWCapThisB w (posW w) (typeW w) b bo then ([createMove w (posW w) (posB b)] ++ (thisValidMovesCapW w bs bo))
                                                       else thisValidMovesCapW w bs bo

--input: white Piece w, its position, its type c black Piece b, Board
-- output: true, if w can capture b, false else
--whether the move is possible is checked by checking if its a pocketMove or if all necessary free positions are available
thisWCapThisB :: Piece -> Pos -> Char -> Piece -> Board -> Bool
thisWCapThisB _ (Pos 0 0) _ _ _ = False --pocket Moves can't capture
thisWCapThisB w _ 'K' b bo = wKingMove (posW w) (posB b) bo
thisWCapThisB w _ 'Q' b bo = wQueenMove (posW w) (posB b) bo
thisWCapThisB w _ 'B' b bo = wBishopMove (posW w) (posB b) bo
thisWCapThisB w _ 'R' b bo = wRookMove (posW w) (posB b) bo
thisWCapThisB w _ 'N' b bo = wKnightMove (posW w) (posB b) bo
thisWCapThisB w _ 'P' b bo = wPawnCap (posW w) (posB b) bo --distinguish caps and noCaps for Pawns


--input: white Piece, frees(Board), Board
--output: valid moves onto free positions for this white piece
thisValidMovesFreeW :: Piece -> [Pos] -> Board -> [Move]
thisValidMovesFreeW _ [] _ = []
thisValidMovesFreeW w (f:fs) bo = if thisWOnFree w (posW w) (typeW w) f bo then ([createMove w (posW w) f] ++ (thisValidMovesFreeW w fs bo))
                                                                        else thisValidMovesFreeW w fs bo
--input: white Piece w, its position, typeW(w) free Pos p, Board
--output : true if w can move on p, false else
--whether the move is possible is checked by checking if all necessary free positions are available
thisWOnFree :: Piece -> Pos -> Char -> Pos -> Board -> Bool
thisWOnFree _ (Pos 0 0) 'P' dst _ = pawnPocketMove (y dst)
thisWOnFree _ (Pos 0 0) _ _ _ = True
thisWOnFree w _ 'K' p bo = wKingMove (posW w) p bo
thisWOnFree w _ 'Q' p bo = wQueenMove (posW w) p bo
thisWOnFree w _ 'B' p bo = wBishopMove (posW w) p bo
thisWOnFree w _ 'R' p bo = wRookMove (posW w) p bo
thisWOnFree w _ 'N' p bo = wKnightMove (posW w) p bo
thisWOnFree w _ 'P' p bo = wPawnNoCap (posW w) p bo --distinguish caps and noCaps for Pawns                                                             
                                  

--
--Whites : End
--


--
--Blacks : Begin
--

--input: black Piece, whites(Board), Board
--output: valid capture moves for this black piece
thisValidMovesCapB :: Piece -> [Piece] -> Board -> [Move]
thisValidMovesCapB _ [] _ = []
thisValidMovesCapB b(w:ws) bo = if thisBCapThisW b (posB b) (typeB b) w bo then ([createMove b (posB b) (posW w)] ++ (thisValidMovesCapB b ws bo))
                                                       else thisValidMovesCapB b ws bo

--input: black Piece b, its position, its type c white Piece w, Board
-- output: true, if b can capture w, false else
--whether the move is possible is checked by checking if its a pocketMove or if all necessary free positions are available
thisBCapThisW :: Piece -> Pos -> Char -> Piece -> Board -> Bool
thisBCapThisW _ (Pos 0 0) _ _ _ = False --pocket Moves can't capture
thisBCapThisW b _ 'k' w bo = bKingMove (posB b) (posW w) bo
thisBCapThisW b _ 'q' w bo = bQueenMove (posB b) (posW w) bo
thisBCapThisW b _ 'b' w bo = bBishopMove (posB b) (posW w) bo
thisBCapThisW b _ 'r' w bo = bRookMove (posB b) (posW w) bo
thisBCapThisW b _ 'n' w bo = bKnightMove (posB b) (posW w) bo
thisBCapThisW b _ 'p' w bo = bPawnCap (posB b) (posW w) bo --distinguish caps and noCaps for Pawns


--input: black Piece, frees(Board), Board
--output: valid moves onto free positions for this black piece
thisValidMovesFreeB :: Piece -> [Pos] -> Board -> [Move]
thisValidMovesFreeB _ [] _ = []
thisValidMovesFreeB b (f:fs) bo = if thisBOnFree b (posB b) (typeB b) f bo then ([createMove b (posB b) f] ++ (thisValidMovesFreeB b fs bo))
                                                                        else thisValidMovesFreeB b fs bo
--input: black Piece b, its position, typeB(b) free Pos p, Board
--output : true if b can move on p, false else
--whether the move is possible is checked by checking if all necessary free positions are available
thisBOnFree :: Piece -> Pos -> Char -> Pos -> Board -> Bool
thisBOnFree _ (Pos 0 0) 'p' dst _ = pawnPocketMove (y dst)
thisBOnFree _ (Pos 0 0) _ _ _ = True
thisBOnFree b _ 'k' p bo = bKingMove (posB b) p bo
thisBOnFree b _ 'q' p bo = bQueenMove (posB b) p bo
thisBOnFree b _ 'b' p bo = bBishopMove (posB b) p bo
thisBOnFree b _ 'r' p bo = bRookMove (posB b) p bo
thisBOnFree b _ 'n' p bo = bKnightMove (posB b) p bo
thisBOnFree b _ 'p' p bo = bPawnNoCap (posB b) p bo --distinguish caps and noCaps for Pawns                                                            
                                  

--
--Whites : End
--

--
--Whites
--

--input: Pos p1, Pos p2, frees(Board)
--output: true, if necessary positions are free, s.t. a white king can move from p1 to p2
wKingMove :: Pos -> Pos -> Board -> Bool
wKingMove p1 p2 bo = (((x p1) == ((x p2)-1)) && ((y p1) == (y p2)))  ||
                    (((x p1) == ((x p2)+1)) && ((y p1) == ((y p2))))  ||
                    (((x p1) == ((x p2))) && ((y p1) == ((y p2)-1)))  ||
                    (((x p1) == ((x p2))) && ((y p1) == ((y p2)+1)))  ||
                    (((x p1) == ((x p2)-1)) && ((y p1) == ((y p2)+1)))  ||
                    (((x p1) == ((x p2)+1)) && ((y p1) == ((y p2)+1)))  ||
                    (((x p1) == ((x p2)-1)) && ((y p1) == ((y p2)-1)))  ||
                    (((x p1) == ((x p2)+1)) && ((y p1) == ((y p2)-1))) 

--input: Pos p1, Pos p2, frees(Board)
--output: true, if necessary positions are free, s.t. a white queen can move from p1 to p2
wQueenMove :: Pos -> Pos -> Board -> Bool
wQueenMove p1 p2 bo = upOf p1 p2 bo || rightOf p1 p2 bo || downOf p1 p2 bo || leftOf p1 p2 bo
                        || rightUpOf p1 p2 bo || rightDownOf p1 p2 bo || leftUpOf p1 p2 bo || leftDownOf p1 p2 bo

--input: Pos p1, Pos p2, frees(Board)
--output: true, if necessary positions are free, s.t. a white bishop can move from p1 to p2
wBishopMove :: Pos -> Pos -> Board -> Bool
wBishopMove p1 p2 bo = rightUpOf p1 p2 bo || rightDownOf p1 p2 bo || leftUpOf p1 p2 bo || leftDownOf p1 p2 bo

--input: Pos p1, Pos p2, frees(Board)
--output: true, if necessary positions are free, s.t. a white rook can move from p1 to p2
wRookMove :: Pos -> Pos -> Board -> Bool
wRookMove p1 p2 bo = upOf p1 p2 bo || rightOf p1 p2 bo || downOf p1 p2 bo || leftOf p1 p2 bo

--input: Pos p1, Pos p2, frees(Board)
--output: true, if necessary positions are free, s.t. a white knight can move from p1 to p2
wKnightMove :: Pos -> Pos -> Board -> Bool
wKnightMove p1 p2 bo = ( ( ((x p1)-1 ) == (x p2) ) && ( ((y p1)+2 ) == (y p2) ) ) ||
                        ( ( ((x p1)+1 ) == (x p2) ) && ( ((y p1)+2 ) == (y p2) ) ) ||
                        ( ( ((x p1)+2 ) == (x p2) ) && ( ((y p1)+1 ) == (y p2) ) ) ||
                        ( ( ((x p1)+2 ) == (x p2) ) && ( ((y p1)-1 ) == (y p2) ) ) ||
                        ( ( ((x p1)+1 ) == (x p2) ) && ( ((y p1)-2 ) == (y p2) ) ) ||
                        ( ( ((x p1)-1 ) == (x p2) ) && ( ((y p1)-2 ) == (y p2) ) ) ||
                        ( ( ((x p1)-2 ) == (x p2) ) && ( ((y p1)-1 ) == (y p2) ) ) ||
                        ( ( ((x p1)-2 ) == (x p2) ) && ( ((y p1)+1 ) == (y p2) ) ) 

--input: Pos p1, Pos p2, frees(Board)
--output: true, if necessary positions are free, s.t. a white pawn can move from p1 to p2
wPawnNoCap :: Pos -> Pos -> Board -> Bool
wPawnNoCap (Pos 1 2) (Pos 1 4) bo = (Pos 1 3) `elem` (frees bo)
wPawnNoCap (Pos 2 2) (Pos 2 4) bo = (Pos 2 3) `elem` (frees bo)
wPawnNoCap (Pos 3 2) (Pos 3 4) bo = (Pos 3 3) `elem` (frees bo)
wPawnNoCap (Pos 4 2) (Pos 4 4) bo = (Pos 4 3) `elem` (frees bo)
wPawnNoCap (Pos 5 2) (Pos 5 4) bo = (Pos 5 3) `elem` (frees bo)
wPawnNoCap (Pos 6 2) (Pos 6 4) bo = (Pos 6 3) `elem` (frees bo)
wPawnNoCap (Pos 7 2) (Pos 7 4) bo = (Pos 7 3) `elem` (frees bo)
wPawnNoCap (Pos 8 2) (Pos 8 4) bo = (Pos 8 3) `elem` (frees bo)
wPawnNoCap p1 p2 bo = ((x p1)==(x p2)) && (((y p1)+1)==(y p2)) 

wPawnCap :: Pos -> Pos -> Board -> Bool
wPawnCap p1 p2 bo = ((x p1) == (((x p2) +1)) && (((y p1)+1) == (y p2)) ) ||
                    ((x p1) == (((x p2) -1)) && (((y p1)+1) == (y p2)) )
                        
--
--Blacks
--                     

--input: Pos p1, Pos p2, frees(Board)
--output: true, if necessary positions are free, s.t. a black king can move from p1 to p2
bKingMove :: Pos -> Pos -> Board -> Bool
bKingMove p1 p2 bo = (((x p1) == ((x p2)-1)) && ((y p1) == (y p2)))  ||
                    (((x p1) == ((x p2)+1)) && ((y p1) == ((y p2))))  ||
                    (((x p1) == ((x p2))) && ((y p1) == ((y p2)-1)))  ||
                    (((x p1) == ((x p2))) && ((y p1) == ((y p2)+1)))  ||
                    (((x p1) == ((x p2)-1)) && ((y p1) == ((y p2)+1)))  ||
                    (((x p1) == ((x p2)+1)) && ((y p1) == ((y p2)+1)))  ||
                    (((x p1) == ((x p2)-1)) && ((y p1) == ((y p2)-1)))  ||
                    (((x p1) == ((x p2)+1)) && ((y p1) == ((y p2)-1))) 

--input: Pos p1, Pos p2, frees(Board)
--output: true, if necessary positions are free, s.t. a black queen can move from p1 to p2
bQueenMove :: Pos -> Pos -> Board -> Bool
bQueenMove p1 p2 bo = upOf p1 p2 bo || rightOf p1 p2 bo || downOf p1 p2 bo || leftOf p1 p2 bo
                        || rightUpOf p1 p2 bo || rightDownOf p1 p2 bo || leftUpOf p1 p2 bo || leftDownOf p1 p2 bo

--input: Pos p1, Pos p2, frees(Board)
--output: true, if necessary positions are free, s.t. a black bishop can move from p1 to p2
bBishopMove :: Pos -> Pos -> Board -> Bool
bBishopMove p1 p2 bo = rightUpOf p1 p2 bo || rightDownOf p1 p2 bo || leftUpOf p1 p2 bo || leftDownOf p1 p2 bo

--input: Pos p1, Pos p2, frees(Board)
--output: true, if necessary positions are free, s.t. a black rook can move from p1 to p2
bRookMove :: Pos -> Pos -> Board -> Bool
bRookMove p1 p2 bo = upOf p1 p2 bo || rightOf p1 p2 bo || downOf p1 p2 bo || leftOf p1 p2 bo

--input: Pos p1, Pos p2, frees(Board)
--output: true, if necessary positions are free, s.t. a black kinght can move from p1 to p2
bKnightMove :: Pos -> Pos -> Board -> Bool
bKnightMove p1 p2 bo = ( ( ((x p1)-1 ) == (x p2) ) && ( ((y p1)+2 ) == (y p2) ) ) ||
                        ( ( ((x p1)+1 ) == (x p2) ) && ( ((y p1)+2 ) == (y p2) ) ) ||
                        ( ( ((x p1)+2 ) == (x p2) ) && ( ((y p1)+1 ) == (y p2) ) ) ||
                        ( ( ((x p1)+2 ) == (x p2) ) && ( ((y p1)-1 ) == (y p2) ) ) ||
                        ( ( ((x p1)+1 ) == (x p2) ) && ( ((y p1)-2 ) == (y p2) ) ) ||
                        ( ( ((x p1)-1 ) == (x p2) ) && ( ((y p1)-2 ) == (y p2) ) ) ||
                        ( ( ((x p1)-2 ) == (x p2) ) && ( ((y p1)-1 ) == (y p2) ) ) ||
                        ( ( ((x p1)-2 ) == (x p2) ) && ( ((y p1)+1 ) == (y p2) ) )

--input: Pos p1, Pos p2, frees(Board)
--output: true, if necessary positions are free, s.t. a black pawn can move from p1 to p2
bPawnNoCap :: Pos -> Pos -> Board -> Bool
bPawnNoCap (Pos 1 7) (Pos 1 5) bo = (Pos 1 6) `elem` (frees bo)
bPawnNoCap (Pos 2 7) (Pos 2 5) bo = (Pos 2 6) `elem` (frees bo)
bPawnNoCap (Pos 3 7) (Pos 3 5) bo = (Pos 3 6) `elem` (frees bo)
bPawnNoCap (Pos 4 7) (Pos 4 5) bo = (Pos 4 6) `elem` (frees bo)
bPawnNoCap (Pos 5 7) (Pos 5 5) bo = (Pos 5 6) `elem` (frees bo)
bPawnNoCap (Pos 6 7) (Pos 6 5) bo = (Pos 6 6) `elem` (frees bo)
bPawnNoCap (Pos 7 7) (Pos 7 5) bo = (Pos 7 6) `elem` (frees bo)
bPawnNoCap (Pos 8 7) (Pos 8 5) bo = (Pos 8 6) `elem` (frees bo)
bPawnNoCap p1 p2 bo = ((x p1)==(x p2)) && (((y p1)-1)==(y p2)) 

bPawnCap :: Pos -> Pos -> Board -> Bool
bPawnCap p1 p2 bo = ((x p1) == (((x p2) +1)) && (((y p1)-1) == (y p2)) ) ||
                    ((x p1) == (((x p2) -1)) && (((y p1)-1) == (y p2)) )


--
--Others:
--
                    
pawnPocketMove :: Int -> Bool
pawnPocketMove 1 = False
pawnPocketMove 8 = False
pawnPocketMove _ = True


rightOf :: Pos -> Pos -> Board -> Bool
rightOf p1 p2 bo = ((y p1 == y p2)
        && (x p1 < x p2))
        && toRight p1 p2 bo

toRight :: Pos -> Pos -> Board -> Bool
toRight p1 p2 bo
  | x p1 + 1 == x p2 = True
  | Pos ((x p1) + 1) (y p1) `elem` (frees bo)
  = toRight (Pos ((x p1) + 1) (y p1)) p2 bo
  | otherwise = False
                                                    
leftOf :: Pos -> Pos -> Board -> Bool
leftOf p1 p2 bo = ((y p1 == y p2)
        && (x p1 > x p2))
        && toLeft p1 p2 bo

toLeft :: Pos -> Pos -> Board -> Bool
toLeft p1 p2 bo
  | x p1 - 1 == x p2 = True
  | Pos ((x p1) - 1) (y p1) `elem` (frees bo)
  = toLeft (Pos ((x p1) - 1) (y p1)) p2 bo
  | otherwise = False
                                                    
upOf :: Pos -> Pos -> Board -> Bool
upOf p1 p2 bo = ((x p1 == x p2)
        && (y p1 < y p2))
        && toUp p1 p2 bo

toUp :: Pos -> Pos -> Board -> Bool
toUp p1 p2 bo
  | y p1 + 1 == y p2 = True
  | Pos (x p1) ((y p1) + 1) `elem` (frees bo)
  = toUp (Pos (x p1) ((y p1) + 1)) p2 bo
  | otherwise = False
                                                    
downOf :: Pos -> Pos -> Board -> Bool
downOf p1 p2 bo = (x p1 == x p2)
        && (y p1 > y p2)
        && toDown p1 p2 bo

toDown :: Pos -> Pos -> Board -> Bool
toDown p1 p2 bo
  | y p1 - 1 == y p2 = True
  | Pos (x p1) ((y p1) - 1) `elem` (frees bo)
  = toDown (Pos (x p1) ((y p1) - 1)) p2 bo
  | otherwise = False                                                  
                                                    
------------------------------------------------
                                                    
                 
rightUpOf :: Pos -> Pos -> Board -> Bool
rightUpOf p1 p2 bo = ((y p1) < (y p2))
        && (x p1 < x p2)
        && ((x p2) - (x p1)) == ((y p2) - (y p1))
        && toRightUp p1 p2 bo

toRightUp :: Pos -> Pos -> Board -> Bool
toRightUp p1 p2 bo
  | (((x p1) + 1) == (x p2)) && (((y p1) + 1) == (y p2)) = True
  | Pos ((x p1) + 1) ((y p1) + 1) `elem` (frees bo)
  = toRightUp (Pos ((x p1) + 1) ((y p1) + 1)) p2 bo
  | otherwise = False
                            
                            
rightDownOf :: Pos -> Pos -> Board -> Bool
rightDownOf p1 p2 bo = ((y p1) > (y p2))
        && ((x p1) < (x p2))
        && ((x p2) - (x p1)) == ((y p1) - (y p2))
        && toRightDown p1 p2 bo

toRightDown :: Pos -> Pos -> Board -> Bool
toRightDown p1 p2 bo
  | (((x p1) + 1) == x p2) && (((y p1) - 1) == y p2) = True
  | Pos ((x p1) + 1) ((y p1) - 1) `elem` (frees bo)
  = toRightDown (Pos ((x p1) + 1) ((y p1) - 1)) p2 bo
  | otherwise = False

                            
leftDownOf :: Pos -> Pos -> Board -> Bool
leftDownOf p1 p2 bo = ((y p1) > (y p2))
        && ((x p1) > (x p2))
        && (((x p1) - (x p2)) == ((y p1) - (y p2)))
        && toLeftDown p1 p2 bo

toLeftDown :: Pos -> Pos -> Board -> Bool
toLeftDown p1 p2 bo
  | (((x p1) - 1) == (x p2)) && (((y p1) - 1) == (y p2)) = True
  | Pos ((x p1) - 1) ((y p1) - 1) `elem` (frees bo)
  = toLeftDown (Pos ((x p1) - 1) ((y p1) - 1)) p2 bo
  | otherwise = False
                            
                            
leftUpOf :: Pos -> Pos -> Board -> Bool
leftUpOf p1 p2 bo = ((y p1) < (y p2))
        && ((x p1) > (x p2))
        && ((x p1) - (x p2)) == ((y p2) - (y p1))
        && toLeftUp p1 p2 bo

toLeftUp :: Pos -> Pos -> Board -> Bool
toLeftUp p1 p2 bo
  | (((x p1) - 1) == (x p2)) && (((y p1) + 1) == (y p2)) = True
  | Pos ((x p1) - 1) ((y p1) + 1) `elem` (frees bo)
  = toLeftUp (Pos ((x p1) - 1) ((y p1) + 1)) p2 bo
  | otherwise = False           


-- convert from [1,8] -> [a, h]
digitToChar :: Int -> Char
digitToChar x = chr (x + 96)

--
--data types
--
data Pos = Pos{x::Int,y::Int}--(0,0) for pocket pieces
instance Eq Pos where
    (Pos x1 y1) == (Pos x2 y2) = (x1==x2) && (y1 == y2)
instance Show Pos where
    show (Pos x y) = digitToChar x : show y


data Piece = White {posW::Pos,typeW::Char} | Black {posB::Pos, typeB::Char}
instance Eq Piece where
    (White p1 c1) == (White p2 c2) = ( (p1==p2) && (c1==c2) )
    (Black p1 c1) == (Black p2 c2) = ( (p1==p2) && (c1==c2) )
instance Show Piece where
    show (White (Pos 0 0) c) = [c]
    show (Black (Pos 0 0) c) = [c]
    show (White p c) =  show p ++ [c]
    show (Black p c) =  show p ++ [c]
    
data Board = Board {whites::[Piece],blacks::[Piece],frees::[Pos]}--no extra data type for pocket. Pocket pieces are initialized with Pos (0,0) 
instance Show Board where
    show (Board w b f) = "(Whites:" ++ show w ++ ", Blacks:" ++ show b ++ ", Frees:" ++ show f ++ ")"

data Move = BoardMove {src::Pos,dst::Pos} | PocketMove {pce::Piece,dst::Pos}
instance Eq Move where
    (BoardMove ps1 pd1) == (BoardMove ps2 pd2) =  (ps1==ps2) && (pd1==pd2)
    (PocketMove p1 pd1) == (PocketMove p2 pd2) =  (p1==p2) && (pd1==pd2)
    (BoardMove ps1 pd1) == (PocketMove p2 pd2) = False
    (PocketMove p1 pd1) == (BoardMove ps2 pd2) = False
instance Show Move where
    --show :: Move m -> String
    show (BoardMove src dst) = show src ++ "-" ++ show dst
    show (PocketMove pce dst) = show pce ++ "-" ++ show dst
    
--
-- basic functions
--

createMove :: Piece -> Pos -> Pos -> Move
createMove p (Pos 0 0) dst = PocketMove p dst
createMove _ src dst = BoardMove src dst


--
-- doMove and subfunctions: begin
--
-- returns board state thats yielded by given move
doMove :: String -> Move -> Board -> Board
--doMove _ _ _ = Board [] [] []
doMove "w" m bo = case m of
                       PocketMove pce dst -> doPocketMove "w" m bo
                       BoardMove src dst -> doBoardMove "w" m bo
doMove "b" m bo = case m of
                       PocketMove pce dst -> doPocketMove "b" m bo
                       BoardMove src dst -> doBoardMove "b" m bo                       
                       
                       
--returns board state thats yielded by given pocket move
doPocketMove :: String -> Move -> Board -> Board
doPocketMove "w" (PocketMove pce dst) bo = Board (changePiecePosInList "w" (Pos 0 0) dst (whites bo))  (blacks bo) (rmPos dst (frees bo))
doPocketMove "b" (PocketMove pce dst) bo = Board (whites bo) (changePiecePosInList "b" (Pos 0 0) dst (blacks bo))  (rmPos dst (frees bo))

--returns board state thats yielded by given Board move
doBoardMove :: String -> Move -> Board -> Board
doBoardMove "w" (BoardMove src dst) bo = if any (\x -> posB x==dst) (blacks bo) then doCap "w" (BoardMove src dst) bo
                                                                                    else doNonCap "w" (BoardMove src dst) bo
doBoardMove "b" (BoardMove src dst) bo = if any (\x -> posW x==dst) (whites bo) then doCap "b" (BoardMove src dst) bo
                                                                                    else doNonCap "b" (BoardMove src dst) bo                                                                                   
--returns board state thats yielded by given capture move
doCap :: String -> Move -> Board -> Board
doCap "w" (BoardMove src dst) bo = Board    (changePiecePosInList "w" src dst (whites bo))      
                                            (changePiecePosInList "b" dst (Pos 0 0) (blacks bo)) 
                                            (src : frees bo)
doCap "b" (BoardMove src dst) bo = Board    (changePiecePosInList "w" dst (Pos 0 0) (whites bo))      
                                            (changePiecePosInList "b" src dst (blacks bo)) 
                                            (src : frees bo)                                            

--returns board state thats yielded by given noncapture move (which is a Board move)
doNonCap :: String -> Move -> Board -> Board
doNonCap "w" (BoardMove src dst) bo = Board     (changePiecePosInList "w" src dst (whites bo))
                                                (blacks bo)
                                                (changePosInList dst src (frees bo))
doNonCap "b" (BoardMove src dst) bo = Board     (whites bo)
                                                (changePiecePosInList "b" src dst (blacks bo))
                                                (changePosInList dst src (frees bo))

-- finds piece with pos src in given list and changes pos to dst                                                
changePiecePosInList :: String -> Pos -> Pos -> [Piece] -> [Piece]
changePiecePosInList "w" src dst l = let pce = getPiece src l in 
                                           White dst (typeW pce) : rmP pce l
changePiecePosInList "b" src dst l = let pce = getPiece src l in 
                                           Black dst (typeB pce) : rmP pce l                                       

-- finds pos src in given list and changes it to dst                                           
changePosInList :: Pos -> Pos -> [Pos] -> [Pos]
changePosInList src dst l = dst : rmPos src l
                                                                                    
--removes given piece from list of pieces                       
rmP :: Piece -> [Piece] -> [Piece]
rmP _ [] = []
rmP pce (p:ps) = if pce == p then ps else p: rmP pce ps

--removes given move from list of moves
rmM :: Move -> [Move] -> [Move]
rmM _ [] = []
rmM mv (m:ms) = if mv == m then ms else m: rmM mv ms

--removes given position from list of positions
rmPos :: Pos -> [Pos] -> [Pos]
rmPos _ [] = []
rmPos po (p:ps) = if po == p then ps else p: rmPos po ps

--

--returns Piece out of List that has given position
--assertion: demanded piece is element of list
getPiece :: Pos -> [Piece] -> Piece
getPiece po (p:ps) = case p of
                          White x y -> if po == posW p then p else getPiece po ps
                          Black x y -> if po == posB p then p else getPiece po ps
                                                    
--
-- doMove and subfunctions: end
--                          

filterDublicatesM :: [Move] -> [Move]
filterDublicatesM m = filterdbM m []

filterdbM :: [Move] -> [Move] -> [Move]
filterdbM [] already = already
filterdbM (m:ms) already = if (m `elem` already) then (filterdbM ms already) else (filterdbM ms (m:already))

--computes output String from list of moves
movesToString :: [Move] -> String
movesToString m = show m

--
--filterCheck : BEGIN
--
-- filters all moves from a list of moves that yield check for respective player
filterCheck :: String -> [Move] -> Board -> [Move]
filterCheck _ [] _ = []
filterCheck "w" (m:ms) bo = if check "w" (doMove "w" m bo) then (filterCheck "w" ms bo) else (m : (filterCheck "w" ms bo))
filterCheck "b" (m:ms) bo = if check "b" (doMove "b" m bo) then (filterCheck "b" ms bo) else (m : (filterCheck "b" ms bo))


--filterCheck : End
--


--
--Check : BEGIN
--

--input: Board, player string
--output: True, if player is in check, false else
check ::  String -> Board -> Bool
check "w" bo = hitsKing  "w" (filterPocketMoves (boardToMoves "b" bo)) bo
check "b" bo = hitsKing  "b" (filterPocketMoves (boardToMoves "w" bo)) bo

--filters out all pocket moves from list of moves
filterPocketMoves :: [Move] -> [Move]
filterPocketMoves [] = []
filterPocketMoves (m:ms) = case m of 
                                PocketMove _ _ -> filterPocketMoves ms
                                BoardMove _ _ -> m: filterPocketMoves ms

-- checks if at least one move of list of moves hits king of respective player
hitsKing :: String -> [Move] -> Board -> Bool
hitsKing _ [] _ = False
hitsKing "w" (m:ms) bo = thisHitsKing "w" m bo || hitsKing "w" ms bo
hitsKing "b" (m:ms) bo = thisHitsKing "b" m bo || hitsKing "b" ms bo

-- checks if given moves hits king of respective player
thisHitsKing :: String -> Move -> Board -> Bool
thisHitsKing "w" m bo = getKingPos "w" (whites bo) == dst m
thisHitsKing "b" m bo = getKingPos "b" (blacks bo) == dst m

-- returns the position of the king in given list of pieces. asserts that king exists in this list
getKingPos :: String -> [Piece] -> Pos
getKingPos _ [] = Pos (-1) (-1)
getKingPos "w" (w:ws) = if typeW w == 'K' then posW w else getKingPos "w" ws
getKingPos "b" (b:bs) = if typeB b == 'k' then posB b else getKingPos "b" bs

--
--Check : END
--




