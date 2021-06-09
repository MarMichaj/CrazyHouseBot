package de.tuberlin.sese.swtpp.gameserver.model.crazyhouse;

import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class MoveParser {
	
	private MoveParser() {
		
	}
	
	private static Map<Character, Integer> columnToInt =  new HashMap<Character, Integer>()
	{
		private static final long serialVersionUID = -1113582265865921787L;
		{
		
		put('a', 1);
		put('b', 2);
		put('c', 3);
		put('d', 4);
		put('e', 5);
		put('f', 6);
		put('g', 7);
		put('h', 8);
		
		
		}
	};
	
	public static Move parseString(String fen) {
		
		if (fenValid(fen)) {
			String[] splitFEN = fen.split("-"); //seperate String using seperator "-"
			
			Move m;
			Position from;
			//convert split string to Position
			Position to = new Position(columnToInt.get(splitFEN[1].charAt(0)), 
										Character.getNumericValue(splitFEN[1].charAt(1)));
			
			if(splitFEN[0].length() == 2) {
				//not a pocketMove
				
				//convert split string to Position
				from = new Position(columnToInt.get(splitFEN[0].charAt(0)), 
									Character.getNumericValue(splitFEN[0].charAt(1)));
				
				m = new Move(from, to);
			}else {
				//pocketMove
				
				m = new PocketMove(splitFEN[0].charAt(0), to);
			}
			
			
			return m;
		}
		
		
		return null;
	}
	
	public static boolean fenValid(String fen) {
		
		Pattern pBoard = Pattern.compile("[abcdefgh][12345678]-[abcdefgh][12345678]", Pattern.CASE_INSENSITIVE);
		Matcher mBoard = pBoard.matcher(fen);
		
		Pattern pPocket = Pattern.compile("[qbnrp]-[abcdefgh][12345678]", Pattern.CASE_INSENSITIVE);
		Matcher mPocket = pPocket.matcher(fen);
	    return mBoard.find() || mPocket.find();
		
		
	}

}
