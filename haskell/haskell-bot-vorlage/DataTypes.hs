module DataTypes where
import Data.Char

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

