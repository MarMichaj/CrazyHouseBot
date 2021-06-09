package de.tuberlin.sese.swtpp.gameserver.model.crazyhouse;
import java.io.Serializable;
import java.util.LinkedList;
import java.util.List;
// import de.tuberlin.sese.swtpp.gameserver.model.Move;

public abstract class Piece implements Serializable {

	private static final long serialVersionUID = 6410006008014962631L;
	protected boolean isWhite;
	private Tile tile;
	protected Board board; //added by Martin
	
	char rep;
	
	public static Piece newPiece(Board b, char type) {
		boolean color = !Character.isLowerCase(type);
		type = Character.toLowerCase(type);
		switch (type) {
		case 'p': return new Pawn(b, color);
		case 'n': return new Knight(b, color);
		case 'b': return new Bishop(b, color);
		case 'r': return new Rook(b, color);
		case 'q': return new Queen(b, color);
		case 'k': return new King(b, color);
		}
		return null;
	}
	
	Piece(Board b, boolean isWhite) {
		this.isWhite = isWhite;
		this.board = b;
	}
	
	public char getRep() {
		return this.rep;
	}
	
	public void setTile(Tile t) {
		this.tile = t;
	}
	
	public Tile getTile() {
		return this.tile;
	}
	
	public boolean isInPocket() {
		return this.tile == null;
	}
	
	boolean isWhite() {
		return this.isWhite;
	}
	
	void changeSide() { // change piece color
		this.isWhite = !this.isWhite;
	}
	
	Position getPosition() {
		// if (getTile()==null) return null;
		return getTile().getPosition();
	}
	
	public List<Move> getValidMoves() {
		if (this.isInPocket()) {
			return this.validMovesFromPocket(); // pocket piece
		} else {
			return this.validMovesFromTile(); // chessfield piece
		}
	}
	
	// needs to be implemented in each specific piece
	public abstract List<Move> validMovesFromTile();

	protected List<Move> validMovesFromPocket() {
		List<Position> freePos = board.getFreePosition();
		List<Move> m = new LinkedList<>();
		for (Position p : freePos) {
			m.add(new PocketMove(this.toString().charAt(0), p));
		}
		return m;
	}
	
	public void capture(Piece p) {
		//if(p.isWhite != this.isWhite) {
		Tile t = p.getTile();
		this.getTile().setPiece(null);
		p.changeSide();
		p.board.movePieceToPocket(p);
		t.setPiece(this);
		//}
	}
	
	// utility function for generating valid moves along a axis (rook, bishop, queen)
	protected void movesAlongDirection(Position start, Position direction, List<Position> pos) {
		Position next = start.add(direction);
		Tile t = board.getTile(next); // advance along direction
		if (t == null) return; // not on the chess board anymore
		if (t.isOccupied()) { // not free space
			if (t.getPiece().isWhite() != this.isWhite) { // enemy piece
				pos.add(t.getPos());
				return;
			} else {
				return;
			}
		} else { // free space
			pos.add(t.getPos());
			movesAlongDirection(t.getPos(), direction, pos); // go recursively along axis
		}
	}

	public String toString() {
		char c = isWhite ? Character.toUpperCase(rep) : rep;
		return "" + c;
	}
	
	public boolean equals(Piece other) {
		return this.toString().equals(other.toString());
	}
	
//	public Piece copy() {
//		
//		Piece newPiece = Piece.newPiece(board, this.toString().charAt(0));
//		newPiece.setTile(this.tile);
//		return newPiece;
//		
//	}
}
