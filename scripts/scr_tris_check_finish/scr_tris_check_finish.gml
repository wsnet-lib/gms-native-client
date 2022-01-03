function scr_tris_check_finish(symbol) {
	with (obj_tris) {
		// Check diagonals
		if (
			(grid[0][0].symbol == symbol && grid[1][1].symbol == symbol && grid[2][2].symbol == symbol) ||
			(grid[2][0].symbol == symbol && grid[1][1].symbol == symbol && grid[0][2].symbol == symbol)
		) {
			winner = symbol;
			return;
		}
		
		for (var i=0; i<3; i++) {
			// Check verticals
			if (grid[i][0].symbol == symbol && grid[i][1].symbol == symbol && grid[i][2].symbol == symbol) {
				winner = symbol;
				return;
			}
			
			// Check horizontals
			if (grid[0][i].symbol == symbol && grid[1][i].symbol == symbol && grid[2][i].symbol == symbol) {
				winner = symbol;
				return;
			}
		}
	
		// Check draw
		for (var yy=0; yy<3; yy++) {
			for (var xx=0; xx<3; xx++) {
				if (!grid[xx][yy].selected) return;			
			}
		}
		winner = 2;
	}
}