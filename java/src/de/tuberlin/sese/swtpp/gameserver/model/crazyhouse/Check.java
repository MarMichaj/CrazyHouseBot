package de.tuberlin.sese.swtpp.gameserver.model.crazyhouse;

import java.util.List;

public class Check {
	
	private Check() {
		
	}
	
	/*
	 * checks if king (isWhite ->white king) is in check
	 */	
	public static boolean check(boolean isWhite, Board board) {
		//List<Pieces> oppPieces = get
		List<Tile> oppTiles = board.getTilesOfPlayer(!isWhite);
		Piece king = getKing(isWhite,board);
		if (king == null) return true; //

		for (Tile t: oppTiles) {
			List<Move> tValidMoves = t.getPiece().getValidMoves();
			for(Move m: tValidMoves) {
				if (m.getTo().equals(king.getPosition())) return true; // TO-DO this throws NullPointer
			}
		}
		return false;
	}
	/*
	 * returns King of color isWhite
	 */
	public static Piece getKing(boolean isWhite, Board board) {
		List<Tile> tiles = board.getTilesOfPlayer(isWhite);
		for (Tile t: tiles) {
			if (t.getPiece() instanceof King) return t.getPiece();
		}
		return null;
	}
	
	/*
	 * checks if player(isWhite -> white player) is checkMate 
	 */
	public static boolean checkMate(boolean isWhite, Board board) {
		if(check(isWhite,board)==false) return false;
		
		List<Move> moves = board.getValidMovesOfPlayer(isWhite);
		for (Move m: moves) {
			if (checkResolved(isWhite,m,board)==true) return false;
		}		
		return true;
	}
	/*
	 * check if Move m resolves check
	 */
	public static boolean checkResolved(boolean isWhite, Move m, Board board) {
		boolean ret=false;
		Board B=board.copy();
		B.tryMove(m);
		if(!check(isWhite,B)) ret=true;
		return ret;
	}
	
}
