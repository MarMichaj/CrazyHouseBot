package de.tuberlin.sese.swtpp.gameserver.model.crazyhouse;

import java.io.Serializable;
import java.util.LinkedList;
import java.util.List;

public class Queen extends Piece implements Serializable {

	private static final long serialVersionUID = 9046702209262877700L;

	Queen(Board b, boolean isWhite) {
		super(b, isWhite);
		this.rep = 'q';
	}
	
	public List<Move> validMovesFromTile() {
		Position start = this.getTile().getPos();
		List<Position> p = new LinkedList<>();
		// all diagonals
		movesAlongDirection(start, new Position( 1,  1), p);
		movesAlongDirection(start, new Position(-1,  1), p);
		movesAlongDirection(start, new Position( 1, -1), p);
		movesAlongDirection(start, new Position(-1, -1), p);
		
		// all horizontal and vertical
		movesAlongDirection(start, new Position( 1,  0), p);
		movesAlongDirection(start, new Position(-1,  0), p);
		movesAlongDirection(start, new Position( 0,  1), p);
		movesAlongDirection(start, new Position( 0, -1), p);
		
		List<Move> m = new LinkedList<>();
		for (Position pos : p) {
			m.add(new Move(start, pos));
		}
		return m;
	}
}

