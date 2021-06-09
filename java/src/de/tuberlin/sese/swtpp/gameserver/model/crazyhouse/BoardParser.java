package de.tuberlin.sese.swtpp.gameserver.model.crazyhouse;

import java.util.Collections;
import java.util.LinkedList;
import java.util.List;

public class BoardParser {
	
	private BoardParser() {
		
	}
	
	public static Board parse(String s, CrazyhouseGame game) {
		Board b = new Board(game);
		b.setupTiles();
		String[] ls = s.split("/");
		parsePlayingField(ls, b); // parse the 8x8 chess board
		parsePocket(ls, b); // parse the pocket
		return b;
	}
	
	private static void parsePlayingField(String[] ls, Board b) {
		for (int r = 0; r < 8; r++) {
			int x_pos = 1; // x_pos on the chessfield
			for (int c_i = 0; c_i < ls[r].length(); c_i++) {
				Piece p = Piece.newPiece(b, ls[r].charAt(c_i)); // get Piece from char representation
				if (p != null) {
					Position pos = new Position(x_pos,8-r); // calculate position from array position
					Tile t = b.getTile(pos);
					t.setPiece(p);
					x_pos++; // increments x pos
				} else { // skip if numeric
					x_pos += Character.getNumericValue(ls[r].charAt(c_i)); // skip tiles
				}
			}
		}
	}
	
	private static void parsePocket(String[] ls, Board b) {
		if (ls.length != 9) return;
		String ps = ls[8];
		for (int i = 0; i < ps.length(); i++) {
			Piece p = Piece.newPiece(b, ps.charAt(i));
			b.pocket.add(p);
		}
	}
	
	public static String parse(Board b) {
		String s = "";
		s += parsePlayingField(b);
		String p = parsePocket(b);
		if (!p.isBlank()) s += p;
		
		return s;
	}
	
	private static String parsePocket(Board b) {
		List<String> l = new LinkedList<>();
		for (Piece p : b.pocket) {
			l.add(p.toString());
		}
		Collections.sort(l);
		String s = "";
		for (String c : l) {
			s += c;
		}
		return s;
	}
	
	private static String parsePlayingField(Board b) {
		String s = "";
		int skip = 0;
		for (int i = 8; i > 0; i--) { // loop through all tiles
			for (int j = 1; j < 9; j++) {
				Piece p = b.getPiece(new Position(j, i)); // get Piece at Position
				if (p == null) {
					skip++;
					continue;
				}
				if (skip > 0) {
					s += "" + skip;
					skip = 0;
				}
				s += p.toString();
			}
			if (skip > 0) s += "" + skip;
			skip = 0;
			s += "/";
		}
		return s;
	}
}
