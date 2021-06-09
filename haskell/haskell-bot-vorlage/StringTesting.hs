module StringTesting where

import DataTypes
sPlus :: String -> String
sPlus [] = []
sPlus (c:cs) = 'b':sPlus(cs)

a:: Pos -> [Pos]
a p = [p]

