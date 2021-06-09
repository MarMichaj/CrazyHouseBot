package de.tuberlin.sese.swtpp.gameserver.test.crazyhouse;

import static org.junit.Assert.assertEquals;

import org.junit.Before;
import org.junit.Test;

import de.tuberlin.sese.swtpp.gameserver.control.GameController;
import de.tuberlin.sese.swtpp.gameserver.model.Game;
import de.tuberlin.sese.swtpp.gameserver.model.Player;
import de.tuberlin.sese.swtpp.gameserver.model.User;

public class TryMoveIntegrationTest {

	User user1 = new User("Alice", "alice");
	User user2 = new User("Bob", "bob");
	
	Player whitePlayer = null;
	Player blackPlayer = null;
	Game game = null;
	GameController controller;
	
	@Before
	public void setUp() throws Exception {
		controller = GameController.getInstance();
		controller.clear();
		
		int gameID = controller.startGame(user1, "", "crazyhouse");
		
		game =  controller.getGame(gameID);
		whitePlayer = game.getPlayer(user1);

	}
	
	public void startGame() {
		controller.joinGame(user2, "crazyhouse");		
		blackPlayer = game.getPlayer(user2);
	}
	
	public void startGame(String initialBoard, boolean whiteNext) {
		startGame();
		
		game.setBoard(initialBoard);
		game.setNextPlayer(whiteNext? whitePlayer:blackPlayer);
	}
	
	public void assertMove(String move, boolean white, boolean expectedResult) {
		if (white)
			assertEquals(expectedResult, game.tryMove(move, whitePlayer));
		else 
			assertEquals(expectedResult,game.tryMove(move, blackPlayer));
	}
	
	public void assertGameState(String expectedBoard, boolean whiteNext, boolean finished, boolean whiteWon) {
		String board = game.getBoard().replaceAll("e", "");
		
		assertEquals(expectedBoard,board);
		assertEquals(finished, game.isFinished());

		if (!game.isFinished()) {
			assertEquals(whiteNext, game.getNextPlayer() == whitePlayer);
		} else {
			assertEquals(whiteWon, whitePlayer.isWinner());
			assertEquals(!whiteWon, blackPlayer.isWinner());
		}
	}
	

	/*******************************************
	 * !!!!!!!!! To be implemented !!!!!!!!!!!!
	 *******************************************/
	@Test
	public void exampleTest() {
		startGame("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR/",true);
		assertMove("b2-b7",true,false);
		assertGameState("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR/",true,false,false);
	}
	/*
	 * Parser
	 */
	@Test
	public void boardParserT1() { // test for correct parsing
		startGame("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR/",true);
		assertGameState("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR/",true, false, false);
	}
	@Test
	public void boardParserT2() { // test for correct parsing
		startGame("8/kq6/8/pp6/8/8/6QK/8/p", true);
		assertGameState("8/kq6/8/pp6/8/8/6QK/8/p", true, false, false);
	}
	/*
	 * Player Turn
	 */
	@Test
	public void playerTurnT1() { // invalid player turn
		startGame("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR/", true);
		assertMove("d7-d5", false, false);
		assertGameState("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR/", true, false, false);
	}
	@Test
	public void playerTurnT2() { // white player moving black piece
		startGame("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR/", true);
		assertMove("d7-d5", true, false);
		assertGameState("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR/", true, false, false);
	}
	/*
	 * Pieces - valid moves
	 */
	@Test
	public void validBishopT1() { 
		startGame("rnbqkbnr/ppp1pppp/3p4/8/4P3/8/PPPP1PPP/RNBQKBNR/",true);
		assertMove("f1-c4",true,true);
		assertGameState("rnbqkbnr/ppp1pppp/3p4/8/2B1P3/8/PPPP1PPP/RNBQK1NR/", false, false, false);
	}
	@Test
	public void validBishopT2() { 
		startGame("rnbqkbnr/ppp1pp1p/3p2p1/8/2B1P3/8/PPPP1PPP/RNBQK1NR/",true);
		assertMove("c4-d5",true,true);
		assertGameState("rnbqkbnr/ppp1pp1p/3p2p1/3B4/4P3/8/PPPP1PPP/RNBQK1NR/", false, false, false);
	}
	@Test
	public void validBishopT3() { 
		startGame("rnbqkbnr/ppp1pp1p/3p2p1/8/2B1P3/8/PPPP1PPP/RNBQK1NR/",true);
		assertMove("c4-b3",true,true);
		assertGameState("rnbqkbnr/ppp1pp1p/3p2p1/8/4P3/1B6/PPPP1PPP/RNBQK1NR/", false, false, false);
	}
	@Test
	public void validBishopT4() { 
		startGame("rnbqkbnr/ppp1pp1p/3p2p1/8/2B1P3/8/PPPP1PPP/RNBQK1NR/",true);
		assertMove("c4-d3",true,true);
		assertGameState("rnbqkbnr/ppp1pp1p/3p2p1/8/4P3/3B4/PPPP1PPP/RNBQK1NR/", false, false, false);
	}
	@Test
	public void validKingT1() { 
		startGame("r4k2/8/8/4K3/8/8/8/8/",true);
		assertMove("e5-e4",true,true);
		assertGameState("r4k2/8/8/8/4K3/8/8/8/", false, false, false);
	}
	@Test
	public void validKingT2() { 
		startGame("r4k2/8/8/4K3/8/8/8/8/",true);
		assertMove("e5-f4",true,true);
		assertGameState("r4k2/8/8/8/5K2/8/8/8/", false, false, false);
	}
	@Test
	public void validKingT3() { 
		startGame("r4k2/8/8/4K3/8/8/8/8/",true);
		assertMove("e5-f5",true,true);
		assertGameState("r4k2/8/8/5K2/8/8/8/8/", false, false, false);
	}
	@Test
	public void validKingT4() { 
		startGame("r4k2/8/8/4K3/8/8/8/8/",true);
		assertMove("e5-f6",true,true);
		assertGameState("r4k2/8/5K2/8/8/8/8/8/", false, false, false);
	}
	@Test
	public void validKingT5() { 
		startGame("r4k2/8/8/4K3/8/8/8/8/",true);
		assertMove("e5-e6",true,true);
		assertGameState("r4k2/8/4K3/8/8/8/8/8/", false, false, false);
	}
	@Test
	public void validKingT6() { 
		startGame("r4k2/8/8/4K3/8/8/8/8/",true);
		assertMove("e5-d6",true,true);
		assertGameState("r4k2/8/3K4/8/8/8/8/8/", false, false, false);
	}
	@Test
	public void validKingT7() { 
		startGame("r4k2/8/8/4K3/8/8/8/8/",true);
		assertMove("e5-d5",true,true);
		assertGameState("r4k2/8/8/3K4/8/8/8/8/", false, false, false);
	}
	@Test
	public void validKingT8() { 
		startGame("r4k2/8/8/4K3/8/8/8/8/",true);
		assertMove("e5-d4",true,true);
		assertGameState("r4k2/8/8/8/3K4/8/8/8/", false, false, false);
	}
	@Test
	public void validKnightT1() { 
		startGame("k7/8/8/8/3N4/8/8/7K/",true);
		assertMove("d4-b3",true,true);
		assertGameState("k7/8/8/8/8/1N6/8/7K/", false, false, false);
	}@Test
	public void validKnightT2() { 
		startGame("k7/8/8/8/3N4/8/8/7K/",true);
		assertMove("d4-c2",true,true);
		assertGameState("k7/8/8/8/8/8/2N5/7K/", false, false, false);
	}
	@Test
	public void validKnightT3() { 
		startGame("k7/8/8/8/3N4/8/8/7K/",true);
		assertMove("d4-e2",true,true);
		assertGameState("k7/8/8/8/8/8/4N3/7K/", false, false, false);
	}
	@Test
	public void validKnightT4() { 
		startGame("k7/8/8/8/3N4/8/8/7K/",true);
		assertMove("d4-f3",true,true);
		assertGameState("k7/8/8/8/8/5N2/8/7K/", false, false, false);
	}
	@Test
	public void validKnightT5() { 
		startGame("k7/8/8/8/3N4/8/8/7K/",true);
		assertMove("d4-f5",true,true);
		assertGameState("k7/8/8/5N2/8/8/8/7K/", false, false, false);
	}
	@Test
	public void validKnightT6() { 
		startGame("k7/8/8/8/3N4/8/8/7K/",true);
		assertMove("d4-e6",true,true);
		assertGameState("k7/8/4N3/8/8/8/8/7K/", false, false, false);
	}
	@Test
	public void validKnightT7() { 
		startGame("k7/8/8/8/3N4/8/8/7K/",true);
		assertMove("d4-c6",true,true);
		assertGameState("k7/8/2N5/8/8/8/8/7K/", false, false, false);
	}
	@Test
	public void validKnightT8() { 
		startGame("k7/8/8/8/3N4/8/8/7K/",true);
		assertMove("d4-b5",true,true);
		assertGameState("k7/8/8/1N6/8/8/8/7K/", false, false, false);
	}
	@Test
	public void validPawnT1() { 
		startGame("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR/",true);
		assertMove("c2-c3",true,true);
		assertGameState("rnbqkbnr/pppppppp/8/8/8/2P5/PP1PPPPP/RNBQKBNR/", false, false, false);
	}
	@Test
	public void validPawnT2() { 
		startGame("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR/",true);
		assertMove("c2-c4",true,true);
		assertGameState("rnbqkbnr/pppppppp/8/8/2P5/8/PP1PPPPP/RNBQKBNR/", false, false, false);
	}
	@Test
	public void validQueenToBorderT1() { 
		startGame("5k2/8/8/3Q4/8/8/8/1K6/",true);
		assertMove("d5-a5",true,true);
		assertGameState("5k2/8/8/Q7/8/8/8/1K6/", false, false, false);
	}
	@Test
	public void validQueenToBorderT2() { 
		startGame("5k2/8/8/3Q4/8/8/8/1K6/",true);
		assertMove("d5-a8",true,true);
		assertGameState("Q4k2/8/8/8/8/8/8/1K6/", false, false, false);
	}
	@Test
	public void validQueenToBorderT3() { 
		startGame("5k2/8/8/3Q4/8/8/8/1K6/",true);
		assertMove("d5-d8",true,true);
		assertGameState("3Q1k2/8/8/8/8/8/8/1K6/", false, false, false);
	}
	@Test
	public void validQueenToBorderT4() { 
		startGame("5k2/8/8/3Q4/8/8/8/1K6/",true);
		assertMove("d5-g8",true,true);
		assertGameState("5kQ1/8/8/8/8/8/8/1K6/", false, false, false);
	}
	@Test
	public void validQueenToBorderT5() { 
		startGame("5k2/8/8/3Q4/8/8/8/1K6/",true);
		assertMove("d5-d1",true,true);
		assertGameState("5k2/8/8/8/8/8/8/1K1Q4/", false, false, false);
	}
	@Test
	public void validQueenToBorderT6() { 
		startGame("5k2/8/8/3Q4/8/8/8/1K6/",true);
		assertMove("d5-h5",true,true);
		assertGameState("5k2/8/8/7Q/8/8/8/1K6/", false, false, false);
	}
	@Test
	public void validQueenToBorderT7() {
		startGame("5k2/8/8/3Q4/8/8/8/1K6/",true);
		assertMove("d5-a2",true,true);
		assertGameState("5k2/8/8/8/8/8/Q7/1K6/", false, false, false);
	}
	@Test
	public void validQueenToBorderT8() { 
		startGame("5k2/8/8/3Q4/8/8/8/1K6/",true);
		assertMove("d5-h1",true,true);
		assertGameState("5k2/8/8/8/8/8/8/1K5Q/", false, false, false);
	}

	@Test
	public void pawnMoveT1() { // valid pawn move
		startGame("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR/", true);
		assertMove("b2-b4", true, true);
		assertGameState("rnbqkbnr/pppppppp/8/8/1P6/8/P1PPPPPP/RNBQKBNR/", false, false, false);
	}
	@Test
	public void knightMoveT1() { // valid knight move
		startGame("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR/", true);
		assertMove("g1-f3", true, true);
		assertGameState("rnbqkbnr/pppppppp/8/8/8/5N2/PPPPPPPP/RNBQKB1R/", false, false, false);
	}
	@Test
	public void knightMoveT2() { // invalid knight move
		startGame("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR/", true);
		assertMove("g1-e2", true, false);
		assertGameState("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR/", true, false, false);
	}
	@Test
	public void narrenMatt() {
		startGame("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR/", true);
		assertMove("f2-f3", true, true);
		assertGameState("rnbqkbnr/pppppppp/8/8/8/5P2/PPPPP1PP/RNBQKBNR/", false, false, false);
		assertMove("e7-e5", false, true);
		assertGameState("rnbqkbnr/pppp1ppp/8/4p3/8/5P2/PPPPP1PP/RNBQKBNR/", true, false, false);
		assertMove("g2-g4", true, true);
		assertGameState("rnbqkbnr/pppp1ppp/8/4p3/6P1/5P2/PPPPP2P/RNBQKBNR/", false, false, false);
		assertMove("d8-h4", false, true);
		assertGameState("rnb1kbnr/pppp1ppp/8/4p3/6Pq/5P2/PPPPP2P/RNBQKBNR/", true, true, false);	
	}
	@Test
	public void avoidCheckWithPocketMove() {
		startGame("rnb1kbnr/ppp2p1p/8/3qp1p1/8/2N5/PPPPQPPP/R1B1KBNR/Pp", true);
		assertMove("e2-e5", true, true);
		assertGameState("rnb1kbnr/ppp2p1p/8/3qQ1p1/8/2N5/PPPP1PPP/R1B1KBNR/PPp", false, false, false);
		assertMove("p-e6", false, true);
		assertGameState("rnb1kbnr/ppp2p1p/4p3/3qQ1p1/8/2N5/PPPP1PPP/R1B1KBNR/PP", true, false, false);
	}
	@Test
	public void validMoveFormatT1() { //format of the string is correct and should not result in a problem
		startGame("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR/", true);
		assertMove("a2-a4", true, true);
		assertGameState("rnbqkbnr/pppppppp/8/8/P7/8/1PPPPPPP/RNBQKBNR/", false, false, false);
	}
	/*
	 * Pieces - invalid Moves
	 */
	
	/*
	 * invalidMoveFormat
	 */
	@Test
	public void invalidMoveFormatT1() { // from-field of move is not in the correct format
		startGame("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR/", true);
		assertMove("z10-e2", true, false);
		assertGameState("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR/", true, false, false);
	}
	@Test
	public void invalidMoveFormatT2() { // to-field of move is not in the correct format
		startGame("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR/", true);
		assertMove("g1-e", true, false);
		assertGameState("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR/", true, false, false);
	}
	
	@Test
	public void invalidMoveFormatT3() { // pocket of move is not in the correct format
		startGame("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR/", true);
		assertMove("a-e2", true, false);
		assertGameState("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR/", true, false, false);
	}
	@Test
	public void invalidMoveFormatT4() { // random string as move string
		startGame("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR/", true);
		assertMove("1uzge", true, false);
		assertGameState("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR/", true, false, false);
	}
	@Test
	public void invalidMoveFormatT5() { // Kings cant be in pocket
		startGame("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR/", true);
		assertMove("K-e3", true, false);
		assertGameState("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR/", true, false, false);
	}
	@Test
	public void invalidMoveFormatT6() { // move does not change position
		startGame("r1b1k1nr/pppp1ppp/2nb1q2/4p3/3PP3/2B2B2/PPP2PPP/RN1QK1NR/", false);
		assertMove("f6-f6", false, false);
		assertGameState("r1b1k1nr/pppp1ppp/2nb1q2/4p3/3PP3/2B2B2/PPP2PPP/RN1QK1NR/", false, false, false);
	}
	@Test
	public void emptyPocketMoveT1() { // move out of empty pocket
		startGame("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR/",true);
		assertMove("R-c4",true,false);
		assertGameState("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR/", true, false, false);
	}
	
	@Test
	public void invalidMoveNoPiece() { // move with out piece at location
		startGame("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR/", true);
		assertMove("f4-g5", true, false);
		assertGameState("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR/", true, false, false);
	}
	/*
	 * checkMate
	 */
	@Test
	public void boardWithNoKing() {
		startGame("8/5ppp/pp3Q2/5b2/1q6/5PPP/8/2R1B1K1/", false);
		assertMove("f5-g6", false, false);
		startGame("8/5ppp/pp3Q2/5b2/1q6/5PPP/8/2R1B1K1/", false);		
	}
	
	@Test
	public void checkMateWhiteWpnT1() { 
		startGame("6k1/3Q4/4R3/8/8/2K3p1/8/8/",true);
		assertMove("e6-e8",true,true);
		assertGameState("4R1k1/3Q4/8/8/8/2K3p1/8/8/", false, true, true);
	}
	@Test
	public void checkMateBlackWonT1() { 
		startGame("8/2k5/5P2/8/8/3r4/4q3/1K6/",false);
		assertMove("d3-d1",false,true);
		assertGameState("8/2k5/5P2/8/8/8/4q3/1K1r4/", true, true, false);
	}
	/*
	 * Pawn -  promotion
	 */
	@Test
	public void promotionWhiteT1() { 
		startGame("8/1k3P2/8/8/8/8/8/1K6/",true);
		assertMove("f7-f8",true,true);
		assertGameState("5Q2/1k6/8/8/8/8/8/1K6/", false, false, false);
	}
	@Test
	public void promotionBlackT1() { 
		startGame("1k6/8/8/8/8/8/1K3p2/8/",false);
		assertMove("f2-f1",false,true);
		assertGameState("1k6/8/8/8/8/8/1K6/5q2/", true, false, false);
	}
	/*
	 * Valid Captures
	 */
	@Test
	public void validCaptureWhiteKnightBlackPawn() {
		startGame("rnbqkbnr/pppp1ppp/8/4p3/8/5N2/PPPPPPPP/RNBQKB1R/", true);
		assertMove("f3-e5", true, true);
		assertGameState("rnbqkbnr/pppp1ppp/8/4N3/8/8/PPPPPPPP/RNBQKB1R/P", false, false, false);
	}
	@Test
	public void validCaptureWhitePawnBlackQueenT1() { 
		startGame("1k6/8/5q2/4P3/8/8/1K6/8/",true);
		assertMove("e5-f6",true,true);
		assertGameState("1k6/8/5P2/8/8/8/1K6/8/Q", false, false, false);
	}
	@Test
	public void validCaptureBlackPawnWhiteQueenT1() { 
		startGame("1k6/8/5p2/4Q3/8/8/1K6/8/",false);
		assertMove("f6-e5",false,true);
		assertGameState("1k6/8/8/4p3/8/8/1K6/8/q", true, false, false);
	}
	@Test
	public void validCaptureWhitePawnBlackPawnT1() { 
		startGame("rnbqkbnr/pppp1ppp/8/4p3/3P4/8/PPP1PPPP/RNBQKBNR/",true);
		assertMove("d4-e5",true,true);
		assertGameState("rnbqkbnr/pppp1ppp/8/4P3/8/8/PPP1PPPP/RNBQKBNR/P", false, false, false);
	}
	@Test
	public void validCaptureWhitePawnBlackPawnT2() { 
		startGame("rnbq1bnr/pp1pkp1p/6p1/2p1p3/1P1P4/3BP3/P1P2PPP/RNBQK1NR/",true);
		assertMove("d4-e5",true,true);
		assertGameState("rnbq1bnr/pp1pkp1p/6p1/2p1P3/1P6/3BP3/P1P2PPP/RNBQK1NR/P", false, false, false);
	}
	@Test
	public void validCaptureWhitePawnBlackPawnT3() { 
		startGame("6k1/8/3p4/2P5/8/8/1K6/8/",true);
		assertMove("c5-d6",true,true);
		assertGameState("6k1/8/3P4/8/8/8/1K6/8/P", false, false, false);
	}
	@Test
	public void validCaptureWhiteQueenBlackPawnT1() { 
		startGame("rnbqkbnr/pppp1ppp/8/4p3/3Q4/8/PPP1PPPP/RNBQKBNR/",true);
		assertMove("d4-e5",true,true);
		assertGameState("rnbqkbnr/pppp1ppp/8/4Q3/8/8/PPP1PPPP/RNBQKBNR/P", false, false, false);
	}
	/*
	 * pocketToBoard
	 */
	@Test
	public void validPocketToBoardT1() { 
		startGame("1k6/8/8/4p3/8/8/1K6/8/Q",true);
		assertMove("Q-d6",true,true);
		assertGameState("1k6/8/3Q4/4p3/8/8/1K6/8/", false, false, false);
	}
	
	@Test
	public void validPawnFromPocketToBoard() {
		startGame("rnb1kbnr/ppp1pppp/8/3q4/8/8/PPPP1PPP/RNBQKBNR/Pp", true);
		assertMove("P-g5", true, true);
		assertGameState("rnb1kbnr/ppp1pppp/8/3q2P1/8/8/PPPP1PPP/RNBQKBNR/p", false, false, false);
	}
	
	@Test
	public void invalidPawnToBaseLine() {
		startGame("rnb1kbnr/ppp1pppp/8/3q4/6Q1/8/PPPP1PPP/RNB1KBNR/Pp", false);
		assertMove("p-d1", false, false);
		assertGameState("rnb1kbnr/ppp1pppp/8/3q4/6Q1/8/PPPP1PPP/RNB1KBNR/Pp", false, false, false);
		assertMove("p-d8", false, false);
		assertGameState("rnb1kbnr/ppp1pppp/8/3q4/6Q1/8/PPPP1PPP/RNB1KBNR/Pp", false, false, false);
	}
	
	@Test
	public void invalidPocketCapture() {
		startGame("rnb1kbnr/ppp1pppp/8/3q4/8/8/PPPP1PPP/RNBQKBNR/Pp", true);
		assertMove("P-d5", true, false);
		assertGameState("rnb1kbnr/ppp1pppp/8/3q4/8/8/PPPP1PPP/RNBQKBNR/Pp", true, false, false);
	}
	
	@Test
	public void invalidPocketInCheck() {
		startGame("rnb1kbnr/pppp2pp/8/4pP2/7q/5P2/PPPPP2P/RNBQKBNR/P", true);
		assertMove("P-c4", true, false);
		assertGameState("rnb1kbnr/pppp2pp/8/4pP2/7q/5P2/PPPPP2P/RNBQKBNR/P", true, false, false);
	}
	
	@Test
	public void QueenNotInPocketT1() { 
		startGame("1k6/8/8/4p3/8/8/1K6/8/",true);
		assertMove("q-d6",true,false);
		assertGameState("1k6/8/8/4p3/8/8/1K6/8/", true, false, false);
	}	
	
}
