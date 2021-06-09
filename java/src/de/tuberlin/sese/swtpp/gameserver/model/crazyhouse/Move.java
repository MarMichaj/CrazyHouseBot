package de.tuberlin.sese.swtpp.gameserver.model.crazyhouse;

import java.io.Serializable;

public class Move implements Serializable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -2531345097527609677L;
	private Position from;
	private Position to;
	
	public Move(Position from, Position to) {
		
		this.from = from;
		this.to = to;
		
	}
	
//	public void setFrom(Position from){
//		this.from = from;
//	}
	
	public Position getFrom(){
		return this.from;
	}
	
//	public void setTo(Position to){
//		this.to = to;
//	}
	
	public Position getTo(){
		return this.to;
	}
	
	public boolean equals(Move m) {
		return this.to.equals(m.to); // this.from.equals(m.from) is always true
		//return (this.from.equals(m.from) && this.to.equals(m.to));
	}

	public boolean isStationary() {
		// if (from == null) return false;
		return this.from.equals(this.to);
	}
	
//	public Move reverseMove() {
//		Move rm = new Move(getTo(),getFrom());
//		return rm;
//	}
	
//	public String toString() {
//		return from.toString() + " -> " + to.toString();
//	}

}
