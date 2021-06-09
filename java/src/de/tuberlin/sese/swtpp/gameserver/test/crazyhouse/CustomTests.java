package de.tuberlin.sese.swtpp.gameserver.test.crazyhouse;

import static org.junit.Assert.*;

import java.util.List;

import org.junit.Test;

import de.tuberlin.sese.swtpp.gameserver.model.crazyhouse.*;

public class CustomTests {

	@Test
	public void test() {
		CrazyhouseGame g = new CrazyhouseGame();
		Board b = BoardParser.parse("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR/", g);
		System.out.println(b);
		Move m = MoveParser.parseString("b1-a2");
		System.out.println(b.getPiece(m.getFrom()));
		return;
	}
}
