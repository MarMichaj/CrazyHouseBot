package de.tuberlin.sese.swtpp.gameserver.model.crazyhouse;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public class King extends Piece implements Serializable{

	private static final long serialVersionUID = 6111361389194582246L;
	private final int[] possibleMoves = {0, 1, -1}; // kings range of motion

	King(Board b, boolean isWhite) {
		super(b, isWhite);
		this.rep = 'k';
	}
	
	@Override
	public List<Move> validMovesFromTile() {
		ArrayList<Move> moves = new ArrayList<Move>();
		Position start = getTile().getPosition();
		for(int i : possibleMoves) {
			for(int j : possibleMoves) {
				if (i == 0 && j == 0) continue; // ignore not moving move
				Position p_new = start.add(i, j);
				Tile t = board.getTile(p_new);
				if (t == null) continue; // tile out of bounds
				if (t.isOccupied() && (t.getPiece().isWhite() != isWhite)) {
					moves.add(new Move(start, p_new)); // capturable piece
				} else if(!t.isOccupied()) {
					moves.add(new Move(start, p_new)); // free tile
				}				
			}
		}
		return moves;
	}
}
