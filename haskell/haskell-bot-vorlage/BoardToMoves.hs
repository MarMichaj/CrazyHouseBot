module BoardToMoves where 

import DataTypes
import ValidMoves 

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
                                 
                                 
