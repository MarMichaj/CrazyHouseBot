module GradingTest where

import Util -- splitOn
import CrazyhouseBot (listMoves)
import System.IO -- stdout
import Data.Set (Set, (\\))
import qualified Data.Set as Set
import Data.Map (Map)
import qualified Data.Map as Map
import Control.Monad -- unless
import Test.HUnit -- assertFailure


assertIncludes :: (Ord a, Show a) => String -> [a] -> [a] -> Assertion
assertIncludes preface actual' expected' =
  unless (expected `Set.isSubsetOf` actual) (assertFailure msg)
  where 
    (expected, actual) = (Set.fromList expected', Set.fromList actual')
    msg =
      (if null preface then "" else preface ++ "\n")
      ++ "missing: " ++ show (Set.toList $ expected \\ actual) ++ "\n"

assertExcludes :: (Ord a, Show a) => String -> [a] -> [a] -> Assertion
assertExcludes preface actual' unexpected' =
  unless (Set.disjoint unexpected actual) (assertFailure msg)
  where
    (unexpected, actual) = (Set.fromList unexpected', Set.fromList actual')
    msg = 
      (if null preface then "" else preface ++ "\n")
      ++ "invalid: " ++ show (Set.toList $ Set.intersection unexpected actual) ++ "\n"

assertSameElems :: (Ord a, Show a) => String -> [a] -> [a] -> Assertion
assertSameElems preface actual' expected' =
  unless (actual == expected) (assertFailure msg)
  where
    (actual, expected) = (Set.fromList actual', Set.fromList expected')
    missing = expected \\ actual
    invalid = actual \\ expected
    msg = concat
      $ [ preface ++ "\n" | not (null preface) ]
      ++ [ "missing: " ++ show (Set.toList missing) | not (Set.null missing) ]
      ++ [ "invalid: " ++ show (Set.toList invalid) | not (Set.null invalid) ]

assertNoDuplicates :: (Ord a, Show a) => String -> [a] -> Assertion
assertNoDuplicates preface items =
  unless (null repeated) (assertFailure msg)
  where
    itemCounts = foldr (\k -> Map.insertWith (+) k 1) Map.empty items
    repeated = Map.keys $ Map.filter (>1) itemCounts
    msg = 
      (if null preface then "" else preface ++ "\n")
      ++ "repeated: " ++ show repeated ++ "\n"

assertOnListMoves assertionFunction game expected =
    let moves = parseMoves expected
    in assertionFunction ("State: " ++ game) (parseMoves $ listMoves game) moves

assertALL = assertOnListMoves assertSameElems
assertINC = assertOnListMoves assertIncludes
assertEXC = assertOnListMoves assertExcludes
assertNODUP game = assertNoDuplicates ("State: " ++ game) (parseMoves $ listMoves game)

parseMoves :: String -> [String]
parseMoves s = filter ((>0) . length) (Util.splitOn ',' (init (tail s)))

--------------------------------------------------------------------------
grades :: Test
grades =
 TestList [
  TestLabel "knightCaptureResolveCheck_Black" . TestCase $
    assertINC "rnbqkbnr/pppQ1ppp/8/8/2P1p3/8/PP1PPPPP/RNB1KBNR/P b" "[b8-d7]",
  TestLabel "pawnWrongDirection_Black" . TestCase $
    assertEXC "rnbqkbnr/pppp1ppp/4p3/6B1/3P4/8/PPP1PPPP/RN1QKBNR/ b" "[e6-e7]",
  TestLabel "rookHitOwnFigure_Black" . TestCase $
    assertEXC "rnbqkbnr/pppppppp/8/8/3P4/8/PPP1PPPP/RNBQKBNR/ b" "[h8-h7]",
  TestLabel "captureAndPromotion_White" . TestCase $
    assertINC "rnbq3r/pppp1kPp/8/8/1P6/8/PP2PnPP/RNBQKBNR/BPPpp w" "[g7-h8]",
  TestLabel "pawnDiagonal_Black" . TestCase $
    assertEXC "rnbqkbnr/pppppppp/8/8/3P4/8/PPP1PPPP/RNBQKBNR/ b" "[d7-c6]",
  TestLabel "dropQueenNotInPocket_White" . TestCase $
    assertEXC "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR/ w" "[Q-a5]",
  TestLabel "pawnDiagonal_White" . TestCase $
    assertEXC "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR/ w" "[c2-b3]",
  TestLabel "queenCapturesKnight_White" . TestCase $
    assertINC "r1bqkbnr/pppp1ppp/4p3/6B1/P2n4/8/1PP1PPPP/RN1QKBNR/p w" "[d1-d4]",
  TestLabel "noFigureAtSource_White" . TestCase $
    assertEXC "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR/ w" "[d3-d4]",
  TestLabel "pawnJumpOver_Black" . TestCase $
    assertEXC "rnbqkbnr/pppp1ppp/B7/4p3/4P3/8/PPPP1PPP/RNBQK1NR/ b" "[a7-a5]",
  TestLabel "pawnLongJumpWrongPosition_White" . TestCase $
    assertEXC "rnbqkbnr/pppp1ppp/4p3/8/3P4/8/PPP1PPPP/RNBQKBNR/ w" "[d4-d6]",
  TestLabel "bishopThroughOwnFigure_Black" . TestCase $
    assertEXC "rnbqkbnr/pppppppp/8/8/3P4/8/PPP1PPPP/RNBQKBNR/ b" "[f8-a3]",
  TestLabel "invalidMoveFormat1" . TestCase $
    assertEXC "rnbqkbnr/pppppppp/8/8/3P4/8/PPP1PPPP/RNBQKBNR/ b" "[k2-b9]",
  TestLabel "invalidMoveFormat3" . TestCase $
    assertEXC "rnbqkbnr/pppppppp/8/8/3P4/8/PPP1PPPP/RNBQKBNR/ b" "[geradeaus-dannlinks]",
  TestLabel "knightCapturesPawn_Black" . TestCase $
    assertINC "r1bqkbnr/pppp1ppp/2n1p3/6B1/P2P4/8/1PP1PPPP/RN1QKBNR/ b" "[c6-d4]",
  TestLabel "bishopMoveNotDiagonal_Black" . TestCase $
    assertEXC "r1bqkbnr/pppn1ppp/8/8/2P1p3/3P4/PP2PPPP/RNB1KBNR/Pq b" "[f8-a5]",
  TestLabel "wrongPlayer" . TestCase $
    assertEXC "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR/ b" "[b2-b3]",
  TestLabel "bishopMoveResolveCheck_White" . TestCase $
    assertINC "r1bqk1nr/pppn1ppp/8/8/1bP1p3/3P4/PP2PPPP/RNB1KBNR/Pq w" "[c1-d2]",
  TestLabel "startupFormationOk_White" . TestCase $
    assertINC "r1bqk1nr/pppn1ppp/8/8/1bP1p3/3P4/PP2PPPP/RNB1KBNR/Pq w" "[c1-d2]",
  TestLabel "pawnCaptureWrongDirection_Black" . TestCase $
    assertEXC "rnbQ4/pppp1kPp/8/8/1P6/8/Pn2P1PP/RNB1KBNR/BPQRpppq b" "[c7-d8]",
  TestLabel "captureIntoFullPocket_Black" . TestCase $
    assertINC "rnbq3Q/pppp1k1p/8/8/1P6/8/PP2PnPP/RNBQKBNR/BPPRpp b" "[f2-d1]",
  TestLabel "promotionRegular_White" . TestCase $
    assertINC "rnbQ4/pppp2Pp/6k1/8/1P6/8/Pn1pPKPP/RNB2BNR/BPQRppq w" "[g7-g8]",
  TestLabel "checkMateRegular_White" . TestCase $
    assertINC "rnbqkbnr/ppppp2p/8/6p1/4Pp2/1P1P4/P1P2PPP/RNBQKBNR/ w" "[d1-h5]",
  TestLabel "kingMoveStillCheck_Black" . TestCase $
    assertEXC "rnbqkbnr/pppQ1ppp/8/8/2P1p3/8/PP1PPPPP/RNB1KBNR/P b" "[e8-e7]",
  TestLabel "kingDiagonal_White" . TestCase $
    assertINC "r1bqkbnr/pp1p1ppp/3pp3/2p3B1/P3Q3/8/1PP1PPPP/RN2KBNR/N w" "[e1-d2]",
  TestLabel "kingMovesIntoCheck_Black" . TestCase $
    assertEXC "r1bqkbnr/pppp1ppp/4p3/6B1/P2Q4/8/1PP1PPPP/RN2KBNR/Np b" "[e8-e7]",
  TestLabel "dropIntoCheckMate_Black" . TestCase $
    assertINC "r1bq2nr/pppn1ppp/4Bk2/8/1BP1p3/3P4/PP2PPPP/RN2KBNR/Pq b" "[q-c1]",
  TestLabel "pawnDropRowOne_White" . TestCase $
    assertEXC "r1bq2nr/pppnkppp/8/8/1bP1p3/3P4/PP1BPPPP/RN2KBNR/Pq w" "[P-c1]",
  TestLabel "dropOnFigure_White" . TestCase $
    assertEXC "r1bq2nr/pppn1ppp/5k2/8/1BP1p3/3P4/PP2PPPP/RN2KBNR/BPq w" "[B-d8]",
  TestLabel "noMove_White" . TestCase $
    assertEXC "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR/ w" "[a7-a7]",
  TestLabel "pawnMoveRegular_Black" . TestCase $
    assertINC "rnbqkbnr/pppppppp/8/8/3P4/8/PPP1PPPP/RNBQKBNR/ b" "[e7-e6]",
  TestLabel "bishopAttackOwnPlayer_White" . TestCase $
    assertEXC "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR/ w" "[c1-b2]",
  TestLabel "queenNotStraight_White" . TestCase $
    assertEXC "r1bqkbnr/pppp1ppp/2n1p3/6B1/3P4/8/PPP1PPPP/RN1QKBNR/ w" "[d1-b4]",
  TestLabel "queenCaptureSetCheck_White" . TestCase $
    assertINC "rnbqkbnr/pppp1ppp/8/8/Q1P1p3/8/PP1PPPPP/RNB1KBNR/ w" "[a4-d7]",
  TestLabel "pawnDropRowEight_White" . TestCase $
    assertEXC "r1bq2nr/pppnkppp/8/8/1bP1p3/3P4/PP1BPPPP/RN2KBNR/Pq w" "[P-f8]",
  TestLabel "dropPawn_Black" . TestCase $
    assertINC "r1bqkbnr/pp1p1ppp/4p3/2p3B1/P3Q3/8/1PP1PPPP/RN2KBNR/Np b" "[p-d6]",
  TestLabel "pawnLongJump_Black" . TestCase $
    assertINC "r1bqkbnr/pppp1ppp/4p3/6B1/P2Q4/8/1PP1PPPP/RN2KBNR/Np b" "[c7-c5]",
  TestLabel "bishopRegular_White" . TestCase $
    assertINC "rnbqkbnr/pppp1ppp/4p3/8/3P4/8/PPP1PPPP/RNBQKBNR/ w" "[c1-g5]",
  TestLabel "pawnLongJump_White" . TestCase $
    assertINC "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR/ w" "[d2-d4]",
  TestLabel "bishopCaptureBishop_White" . TestCase $
    assertINC "r1bq2nr/pppnkppp/8/8/1bP1p3/3P4/PP1BPPPP/RN2KBNR/Pq w" "[d2-b4]",
  TestLabel "dropQueenWhileCheck_Black" . TestCase $
    assertEXC "r1bq2nr/pppnkppp/8/8/1BP1p3/3P4/PP2PPPP/RN2KBNR/BPq b" "[q-c1]",
  TestLabel "bishopMoveRegular_Black" . TestCase $
    assertINC "r1bqkbnr/pppn1ppp/8/8/2P1p3/3P4/PP2PPPP/RNB1KBNR/Pq b" "[f8-b4]",
  TestLabel "rookThroughPawn_White" . TestCase $
    assertEXC "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR/ w" "[a1-a5]",
  TestLabel "knightRegular_Black" . TestCase $
    assertINC "rnbqkbnr/pppp1ppp/4p3/6B1/3P4/8/PPP1PPPP/RN1QKBNR/ b" "[b8-c6]",
  TestLabel "dropOneOfTwoPawns_White" . TestCase $
    assertINC "rnbqk2r/pppp2pp/5P1n/8/1b6/2P5/PP2PPPP/RNBQKBNR/PP w" "[P-f7]",
  TestLabel "kingTooFar_White" . TestCase $
    assertEXC "r1bqkbnr/pppp1ppp/2n1p3/6B1/3P4/8/PPP1PPPP/RN1QKBNR/ w" "[e1-c3]",
  TestLabel "useBlackPawn_White" . TestCase $
    assertEXC "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR/ w" "[a7-a6]",
  TestLabel "queenHorizontal_White" . TestCase $
    assertINC "r1bqkbnr/pp1p1ppp/4p3/2p3B1/P2Q4/8/1PP1PPPP/RN2KBNR/Np w" "[d4-e4]",
  TestLabel "bishopHorizontal_White" . TestCase $
    assertEXC "r1bqkbnr/pppp1ppp/2n1p3/6B1/3P4/8/PPP1PPPP/RN1QKBNR/ w" "[g5-g3]",
  TestLabel "pawnTooFar_Black" . TestCase $
    assertEXC "rnbqkbnr/pppppppp/8/8/3P4/8/PPP1PPPP/RNBQKBNR/ b" "[e7-e4]",
  TestLabel "pawnTooFar_White" . TestCase $
    assertEXC "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR/ w" "[c2-c5]",
  TestLabel "dropKnightToCheck_White" . TestCase $
    assertEXC "r1b1kbnr/pp1p1ppp/3pp3/2p3q1/P3Q3/8/1PPKPPPP/RN3BNR/Nb b" "[N-c7]",
  TestLabel "knightWrongDistance_Black" . TestCase $
    assertEXC "r1bqkbnr/pppp1ppp/4p3/6B1/P2Q4/8/1PP1PPPP/RN2KBNR/Np b" "[g8-e6]",
  TestLabel "queenHitsBishop_Black" . TestCase $
    assertINC "r1bqkbnr/pp1p1ppp/3pp3/2p3B1/P3Q3/8/1PPKPPPP/RN3BNR/N b" "[d8-g5]",
  TestLabel "kingMoveRegular_Black" . TestCase $
    assertINC "r1bqk1nr/pppn1ppp/8/8/1bP1p3/3P4/PP1BPPPP/RN2KBNR/Pq b" "[e8-e7]",
  TestLabel "knightTooFar_White" . TestCase $
    assertEXC "r1bqkbnr/pppp1ppp/2n1p3/6B1/3P4/8/PPP1PPPP/RN1QKBNR/ w" "[b1-c4]",
  TestLabel "captureSecondPawn_White" . TestCase $
    assertINC "rnbqkbnr/pppp2pp/5p2/4P3/8/8/PPP1PPPP/RNBQKBNR/P w" "[e5-f6]",
  TestLabel "exampleTest" . TestCase $
    assertINC "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR/ w" "[b2-b3]",

  TestLabel "initialBoard_noDuplicates" . TestCase $
    assertNODUP "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR/ w",
  TestLabel "initialBoard_allMoves" . TestCase $
    assertALL "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR/ w"
      "[b1-a3,b1-c3,g1-f3,g1-h3,a2-a3,a2-a4,b2-b3,b2-b4,c2-c3,c2-c4,d2-d3,d2-d4,e2-e3,e2-e4,f2-f3,f2-f4,g2-g3,g2-g4,h2-h3,h2-h4]",

  -- TestLabel "moveBishopPawnsKnightKing_dropPawn_white_noDuplicates" . TestCase $
  --   assertNODUP "r1b1k1nr/pppnqppp/8/8/1BP1p3/3P4/PP2PPPP/RN2KBNR/PPq w",
  -- TestLabel "moveBishopPawnsKnightKing_dropPawn_white_allMoves" . TestCase $
  --   assertALL "r1b1k1nr/pppnqppp/8/8/1BP1p3/3P4/PP2PPPP/RN2KBNR/PPq w"
  --     "[a2-a3,a2-a4,b1-a3,b1-c3,b1-d2,b2-b3,b4-a3,b4-a5,b4-c5,b4-d6,b4-e7,b4-c3,b4-d2,c4-c5,d3-d4,d3-e4,e1-d1,e1-d2,e2-e3,f2-f3,f2-f4,g1-f3,g1-h3,g2-g3,g2-g4,h2-h3,h2-h4,P-c2,P-d2,P-a3,P-b3,P-c3,P-e3,P-f3,P-g3,P-h3,P-a4,P-d4,P-f4,P-g4,P-h4,P-a5,P-b5,P-c5,P-d5,P-e5,P-f5,P-g5,P-h5,P-a6,P-b6,P-c6,P-d6,P-e6,P-f6,P-g6,P-h6,P-c2,P-d2,P-a3,P-b3,P-c3,P-e3,P-f3,P-g3,P-h3,P-a4,P-d4,P-f4,P-g4,P-h4,P-a5,P-b5,P-c5,P-d5,P-e5,P-f5,P-g5,P-h5,P-a6,P-b6,P-c6,P-d6,P-e6,P-f6,P-g6,P-h6]",

  TestLabel "moveRookPawnsKnightKingQueen_black_noDuplicates" . TestCase $
    assertNODUP "r1b1k1nr/1ppnqppp/1p6/8/1BP1p3/3P4/PP2PPPP/RN2KBNR/BPq b",
  TestLabel "moveRookPawnsKnightKingQueen_black_allMoves" . TestCase $
    assertALL "r1b1k1nr/1ppnqppp/1p6/8/1BP1p3/3P4/PP2PPPP/RN2KBNR/BPq b"
      "[a8-a2,a8-a3,a8-a4,a8-a5,a8-a6,a8-a7,a8-b8,b6-b5,c7-c6,c7-c5,d7-b8,d7-c5,d7-e5,d7-f6,d7-f8,e8-d8,e8-f8,e7-b4,e7-c5,e7-d6,e7-d8,e7-e5,e7-e6,e7-f6,e7-f8,e7-g5,e7-h4,e4-d3,e4-e3,f7-f6,f7-f5,g8-f6,g8-h6,g7-g6,g7-g5,h7-h6,h7-h5,q-a3,q-a4,q-a5,q-a6,q-a7,q-b3,q-b5,q-b8,q-c1,q-c2,q-c3,q-c5,q-c6,q-d1,q-d2,q-d4,q-d5,q-d6,q-d8,q-e3,q-e5,q-e6,q-f3,q-f4,q-f5,q-f6,q-f8,q-g3,q-g4,q-g5,q-g6,q-h3,q-h4,q-h5,q-h6]",

  TestLabel "inCheck_black_noDuplicates" . TestCase $
    assertNODUP "r1bq2nr/1ppnkppp/1p6/8/1BP1p3/3P4/PP2PPPP/RN2KBNR/BPq b",
  TestLabel "inCheck_black_allMoves" . TestCase $
    assertALL "r1bq2nr/1ppnkppp/1p6/8/1BP1p3/3P4/PP2PPPP/RN2KBNR/BPq b"
      "[c7-c5,d7-c5,e7-e6,e7-e8,e7-f6,q-c5,q-d6]"

  ] -- end test list,

main :: IO (Counts, Int)
main =  runTestText (putTextToHandle stdout False) grades