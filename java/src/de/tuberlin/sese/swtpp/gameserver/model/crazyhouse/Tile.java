package de.tuberlin.sese.swtpp.gameserver.model.crazyhouse;

import java.io.Serializable;

public class Tile implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 2829030858844995197L;
	private Board board;
	private Position pos;
	private Piece piece;

	
	Tile(Board board, Position pos, Piece piece){
		this.board = board;
		this.pos = pos;
		this.piece = piece;
	}
	
	Piece getPiece() {
		return this.piece;
	}
	
	Position getPosition() {
		return this.pos;
	}
	
	void setPiece(Piece piece) {
		this.piece = piece;
		if(this.piece != null) this.piece.setTile(this);
	}
	
	boolean isOccupied() {
		return (this.piece != null);
	}
	
	void capture(Piece p) {
		//board.pieces.remove(this.piece); // remove piece from board
		this.piece.changeSide(); // change color
		this.piece.setTile(null); // null their tile
		board.pocket.add(this.piece); // add piece to pocket
		setPiece(p); // set this to capturing piece
	}
	
	public Board getBoard() {
		return board;
	}

	public Position getPos() {
		return pos;
	}

//	public String toString() {
//		String p = piece != null ? piece.toString() : ".";
//		return pos.toString() + ": " + p;
//	}
}
