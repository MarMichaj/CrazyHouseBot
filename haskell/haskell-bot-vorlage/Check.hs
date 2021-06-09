module Check where

import DataTypes
import BoardToMoves

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









