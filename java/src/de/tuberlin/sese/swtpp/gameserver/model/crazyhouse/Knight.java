package de.tuberlin.sese.swtpp.gameserver.model.crazyhouse;

import java.io.Serializable;
import java.util.LinkedList;
import java.util.List;

public class Knight extends Piece implements Serializable{

	private static final long serialVersionUID = 5675025274601779185L;
	
	// all possible jumping positions for a knight
	private final Position[] possibleOffsets = new Position[] {
			new Position(1, 2), new Position(-1,2),
			new Position(1, -2), new Position(-1, -2),
			new Position(2, 1), new Position(-2, 1),
			new Position(2, -1), new Position(-2, -1)
	};

	Knight(Board b, boolean isWhite) {
		super(b, isWhite);
		this.rep = 'n';
	}
	
	public List<Move> validMovesFromTile() {
		List<Move> moves = new LinkedList<>();
		Position start = this.getTile().getPos();
		//List<Position> p = new LinkedList<>();
		for (Position off : possibleOffsets) {
			Position p_new = start.add(off);
			Tile t = board.getTile(p_new);
			if (t == null) continue;
			if (t.isOccupied()) {
				if (t.getPiece().isWhite() != isWhite) {
					moves.add(new Move(start, p_new)); // capturable piece
				}
			} else {
				moves.add(new Move(start, p_new)); // free tile
			}
		}
		return moves;
	}
}
