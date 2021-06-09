module ValidMoves where

import DataTypes
import PieceMoves
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
