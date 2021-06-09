package de.tuberlin.sese.swtpp.gameserver.model.crazyhouse;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import de.tuberlin.sese.swtpp.gameserver.model.Player;

//TO DO: right visibilities?
public class Board implements Serializable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -5811185845793289677L;
	public CrazyhouseGame game;
	//TO DO: is List right iterable type?
	
	// protected final List<Piece> pieces = new LinkedList<>(); //unnecessary?
	
	protected final List<Tile> tiles = new LinkedList<>();
	
	protected List<Piece> pocket = new LinkedList<>();
	
	public Board(CrazyhouseGame game) {
		this.game=game;
		
	}
	
	public Board copy() {
		return BoardParser.parse(this.toString(), this.game);
	}
	
	void setupTiles() {
		for (int i = 1; i < 9; i++) {
			for (int j = 1; j < 9; j++) {
				Position p = new Position(i, j);
				tiles.add(new Tile(this, p, null));
			}
		}
	}
	
	ArrayList<Position> getFreePosition() {
		ArrayList<Position> p = new ArrayList<>();
		for (Tile t : tiles) {
			if (t.getPiece() == null) p.add(t.getPos()); 
		}
		return p;
	}
	
	void putPiece(Position po, Piece pi, boolean pMove) {
		Tile t = getTile(po); // if t != null
		if(t.getPiece() == null) {
			if(pi.getTile() != null) pi.getTile().setPiece(null);
			t.setPiece(pi);
		}else { //if(!pi.isInPocket())
			//only capture if pi is not currently in pocket;
			pi.capture(t.getPiece());
		}

		
		if(pMove) {
			this.removePieceFromPocket(pi);
		}
		//promote a pawn if necessary (promote() only executes if necessary conditions are true)
		if (pi instanceof Pawn) {
			((Pawn)pi).promote();
		}
	}
	
	public Tile getTile(Position p) { // get the Tile for one
		if (p == null) return null;
		Tile found = null;
		for (Tile t: tiles) {
			if (t.getPosition().equals(p)) {
				found = t;
				// break // break skips one branch
			}
		}
		return found;
	}
	
	
	public List<Tile> getTiles(){
		return tiles;
	}
	
	public List<Piece> getPocket(){
		return pocket;
	}
	
	public Piece getPiece(Position p) {
		Tile t = getTile(p);
		// if (t == null) return null;
		return t.getPiece();
	}
	
	
	boolean isWhiteTurn() {
		return game.isWhiteNext();
	}
	
	// entrypoint for crazyhouse game
	public boolean tryMove(String s) {
		Move m = MoveParser.parseString(s);
		String beforeGameState = this.toString();
		if (this.tryMove(m)) {
			//Change next player
			List<Player> players = game.getPlayers();
			Player player = game.getNextPlayer();
			Player nextP = players.stream().filter(o -> !game.isPlayersTurn(o)).findFirst().get();
			game.setNextPlayer(nextP);
			
			//update history
			List<de.tuberlin.sese.swtpp.gameserver.model.Move> history = game.getHistory();
			de.tuberlin.sese.swtpp.gameserver.model.Move new_move = new de.tuberlin.sese.swtpp.gameserver.model.Move(beforeGameState, s, player);
			history.add(new_move);
			game.setHistory(history);
			
			
			//check if other players in checkMate now
			if (Check.checkMate(isWhiteTurn(), this)) {
				//TODO: end game
				game.regularGameEnd(player);
			}
			return true;
		}
		return false;
	}
	
	public boolean tryMove(Move m) {
		return m instanceof PocketMove? tryPocketMove(m) : tryNormalMove(m);
	}
	
	private boolean tryPocketMove(Move m) {

		//if (m == null) return false; // wrong parsed ? there are no wrongly parsed pocket moves

		//get the piece associated with the move
		Piece p = Piece.newPiece(this, ((PocketMove) m).getPiece());

		List<Move> validMoves = p.getValidMoves();
		
		//check if color of moved piece and isWhiteTurn() match
		if(!this.isWhiteTurn() == p.isWhite) return false;

		//check if proposed move is in getValidMoves()
		if (!validMoves.stream().filter(o -> o.equals(m)).findFirst().isPresent()) return false;
		
		//check if p is in pocket, in the case of m being a pocket move
		boolean inPocket = false;
		for (Piece pi : pocket) {
			if (pi.equals(p)) inPocket = true;
		}
		if (!inPocket) return false;
		
		//check if the current player is in check after executing the move
		Board bCopy = this.copy();
		bCopy.doMove(m);
		if (Check.check(isWhiteTurn(), bCopy)) return false;
		
		this.doMove(m);
		
		return true;
	}
	
	public boolean tryNormalMove(Move m) {

		if (m == null) return false; // wrong parsed //? there are no wrongly parsed pocket moves
		if (m.isStationary()) return false; // move does not change position
		
		//get the piece associated with the move
		Piece p = this.getPiece(m.getFrom());

		//check if there is no piece at given position
		if (p == null) return false;
		List<Move> validMoves = p.getValidMoves();
		
		//check if color of moved piece and isWhiteTurn() match
		if(!this.isWhiteTurn() == p.isWhite) return false;

		//check if proposed move is in getValidMoves()
		if (!validMoves.stream().filter(o -> o.equals(m)).findFirst().isPresent()) return false;

		//check if the current player is in check after executing the move
		Board bCopy = this.copy();
		bCopy.doMove(m);
		if (Check.check(isWhiteTurn(), bCopy)) return false;
		
		this.doMove(m);
		
		return true;
	}
	
	void movePieceToPocket(Piece p) {
		this.pocket.add(p);
		p.setTile(null);
	}
	
	public void removePieceFromPocket(Piece p) {
		Iterator<Piece> itr = pocket.iterator();
		while (itr.hasNext()) {
			Piece pocket_p = itr.next();
			if (pocket_p.equals(p)) {
				itr.remove();
			}
		}
	}
	
	private void doMove(Move m) {

		Piece p = (m instanceof PocketMove? Piece.newPiece(this, ((PocketMove) m).getPiece()): this.getPiece(m.getFrom()));
		this.putPiece(m.getTo(), p, m instanceof PocketMove);
		// TO-DO remove old reference to old piece
	}
	
	/*
	 * returns list of tiles which have pieces of isWhite
	 */
	List<Tile> getTilesOfPlayer(boolean isWhite) {
		List<Tile> tiles = new ArrayList<Tile>();
		for (Tile t : getTiles()) {
			if (t.getPiece()!=null) {
				if (t.getPiece().isWhite() == isWhite) tiles.add(t);
			}
		}
		return tiles;
	}
	/*
	 * returns valid moves of player isWhite
	 */
	List<Move> getValidMovesOfPlayer(boolean isWhite) {
		List<Move> moves = new ArrayList<Move>();
		for (Tile t: getTilesOfPlayer(isWhite)) {
			moves.addAll(t.getPiece().getValidMoves());
		}
		for (Piece p:getPocket()) {
			if(p.isWhite==isWhite) moves.addAll(p.getValidMoves());
		}
		return moves;
	}
	
	public String toString() {
		return BoardParser.parse(this);
	}
	
	
}
