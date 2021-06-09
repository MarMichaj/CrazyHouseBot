package de.tuberlin.sese.swtpp.gameserver.model.crazyhouse;

import java.io.Serializable;
import java.util.*;

public class Pawn extends Piece implements Serializable {

	private static final long serialVersionUID = -3425364623500975930L;

	Pawn(Board b, boolean isWhite) {
		super(b, isWhite);
		this.rep = 'p';
	}
	
	// TO-DO refactor, maybe into seperate methods
	public List<Move> validMovesFromTile(){

		return isWhite? validMovesFromTileWhite() : validMovesFromTileBlack();
		
	}
	
private List<Move> validMovesFromTileBlack(){
		
		List<Move> moves = new ArrayList<Move>();
		Position currPos = getTile().getPosition();
		int upOrDown = -1;
		
		//tile in front of pawn free?
		Position nextPos = currPos.add(0, 1 * upOrDown);
		Tile nextTile = getTile().getBoard().getTile(nextPos);
		if( nextTile.getPiece() == null) moves.add(new Move(currPos, nextPos)); // nextPos != null
		
		//pawn in beginning position and tile two in front of pawn free?
		if(currPos.getY() == 7) {
			nextPos = currPos.add(0, 2 * upOrDown);
			nextTile = getTile().getBoard().getTile(nextPos);
			if(nextTile.getPiece() == null) moves.add(new Move(currPos, nextPos)); // nextPos != null
		}
		
		//can pawn capture opposing piece?
		for(int i = 0; i < 2; i ++) {
			nextPos = currPos.add(i == 0 ? -1 : 1, 1 * upOrDown);
			nextTile = getTile().getBoard().getTile(nextPos);
			//check if Pieces on the two diagonal tiles are of opposite color
			if(nextPos != null && nextTile.getPiece() != null) {
				if(isWhite != nextTile.getPiece().isWhite()) moves.add(new Move(currPos, nextPos));
			}
		}
		
		return moves;
		
	}

private List<Move> validMovesFromTileWhite(){
	
	List<Move> moves = new ArrayList<Move>();
	Position currPos = getTile().getPosition();
	int upOrDown = 1;
	
	//tile in front of pawn free?
	Position nextPos = currPos.add(0, 1 * upOrDown);
	Tile nextTile = getTile().getBoard().getTile(nextPos);
	if(nextTile.getPiece() == null) moves.add(new Move(currPos, nextPos)); // nextPos != null
	
	//pawn in beginning position and tile two in front of pawn free?
	if(currPos.getY() == 2) {
		nextPos = currPos.add(0, 2 * upOrDown);
		nextTile = getTile().getBoard().getTile(nextPos);
		if(nextTile.getPiece() == null) moves.add(new Move(currPos, nextPos)); // nextPos != null
	}
	
	//can pawn capture opposing piece?
	for(int i = 0; i < 2; i ++) {
		nextPos = currPos.add(i == 0 ? -1 : 1, 1 * upOrDown);
		nextTile = getTile().getBoard().getTile(nextPos);
		//check if Pieces on the two diagonal tiles are of opposite color
		if(nextPos != null && nextTile.getPiece() != null) {
			if(isWhite != nextTile.getPiece().isWhite()) moves.add(new Move(currPos, nextPos));
		}
	}
	
	return moves;
	
}
	
	public List<Move> validMovesFromPocket(){
		List<Move> moves = super.validMovesFromPocket(); // all pocket moves
		Iterator<Move> itr = moves.iterator();
		while(itr.hasNext()) {
			Move m = itr.next();
			if (m.getTo().getY() == 1 || m.getTo().getY() == 8) { // remove all moves, with x pos = 1 or = 8
				itr.remove();
			}
		}
		return moves;
	}
	
	public void promote() {
		if((this.isWhite? this.getPosition().getY() == 8 : this.getPosition().getY() == 1)) { //!this.isInPocket()
			Queen q = new Queen(this.board, this.isWhite);
			Tile t = this.getTile();
			t.setPiece(q);
			//board.pocket.add(this);
			this.setTile(null);
		}
	}
}
