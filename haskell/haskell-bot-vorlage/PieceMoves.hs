module PieceMoves where

import DataTypes

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



