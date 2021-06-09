package de.tuberlin.sese.swtpp.gameserver.model.crazyhouse;

import java.io.Serializable;

public class PocketMove extends Move implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -3922210175463300299L;
	private char piece;
	
	public PocketMove(char piece, Position to) {
		
		super(null, to);
		this.piece = piece;
		
	}
	
	public boolean equals(Move m) {
		
		//conditions: same type, same Piece, same Destination
//		if(m instanceof PocketMove && (((PocketMove) m).getPiece() == this.getPiece()) && m.getTo().equals(this.getTo())) {
//			return true;
//		}
//		
//		return false;

		return m.getTo().equals(this.getTo());
		
	}

	public char getPiece() {
		return piece;
	}

//	public void setPiece(char piece) {
//		this.piece = piece;
//	}
	
}

