package de.tuberlin.sese.swtpp.gameserver.model.crazyhouse;

import java.io.Serializable;
import java.util.LinkedList;
import java.util.List;

public class Bishop extends Piece implements Serializable{

	private static final long serialVersionUID = 4032230665508764928L;

	Bishop(Board b, boolean isWhite) {
		super(b, isWhite);
		this.rep = 'b';
	}
	
	public List<Move> validMovesFromTile() {
		Position start = this.getTile().getPos();
		List<Position> p = new LinkedList<>();
		// all diagonals
		movesAlongDirection(start, new Position( 1,  1), p);
		movesAlongDirection(start, new Position(-1,  1), p);
		movesAlongDirection(start, new Position( 1, -1), p);
		movesAlongDirection(start, new Position(-1, -1), p);
		
		List<Move> m = new LinkedList<>();
		for (Position pos : p) {
			m.add(new Move(start, pos));
		}
		return m;
	}
}
