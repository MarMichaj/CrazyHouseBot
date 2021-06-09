package de.tuberlin.sese.swtpp.gameserver.model.crazyhouse;

import java.io.Serializable;

public class Position implements Serializable {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -6899786173543134866L;
	private int x;
	private int y;
	
	public Position(int x, int y){
		this.x=x;
		this.y=y;
	}
	
	
	public int getX() {
		return x;
	}

//	public void setX(int x) {
//		this.x = x;
//	}

	public int getY() {
		return y;
	}

//	public void setY(int y) {
//		this.y = y;
//	}
	
	public boolean equals(Position other) {
		// if (other == null) return false;
		return (this.x == other.getX() && this.y == other.getY());
	}
	
	public Position add(int x, int y) {
		
		//only return new Position if it still lies on the board
		if(this.x + x >= 1 && this.x + x <= 8 && this.y + y >= 1 && this.y +y <= 8) {
			return new Position(this.x + x, this.y + y);
		}
		
		return null;
		
	}
	
	public Position add(Position pos) {
		return add(pos.getX(), pos.getY());
	}
	
//	public String toString() {
//		return "(" + x + "," + y + ")";
//	}


	
}
