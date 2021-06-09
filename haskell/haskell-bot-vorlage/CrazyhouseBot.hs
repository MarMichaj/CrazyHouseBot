-- module (NICHT ÄNDERN!)
module CrazyhouseBot
    ( getMove
    , listMoves
    ) 
    where

import Data.Char
-- Weitere Modulen können hier importiert werden

import Util

import StringToBoard
import BoardToMoves
import MovesToString
import DataTypes
import Check

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






