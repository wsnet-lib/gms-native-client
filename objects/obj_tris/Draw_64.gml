draw_set_color(c_white); draw_set_halign(fa_left); draw_set_valign(fa_top);

if (!instance_exists(obj_net_manager)) {
	draw_text(10, 30, "Error: connection lost");
	exit;
}

draw_set_halign(fa_right);
draw_text(room_width-10, 10, "Ping: " + string(obj_net_manager.ping_ms) + "ms");
draw_set_halign(fa_left);

if (other_player == undefined) {
	draw_set_halign(fa_center); draw_set_valign(fa_middle);
	draw_text(room_width/2, room_height/2, "Waiting another player..");
	exit;
}

if (player_symbol == undefined) {
	draw_set_halign(fa_center); draw_set_valign(fa_middle);
	draw_text(room_width/2, room_height/2, "Waiting for the start from the admin..");
	exit;
}

draw_set_halign(fa_left); draw_set_valign(fa_top);
draw_text(10, 10, "Player: " + (!player_symbol ? "X" : "O"));

if (winner == -1) {
	if (turn == obj_net_manager.player_id) {
		draw_text(10, 30, "It's your turn");
	} else {
		draw_text(10, 30, "It's the opponent turn");
	}	
} else {
	if (winner == 2) {
		draw_text(10, 30, "No one won, it's a draw!");
	} else if (winner == player_symbol) {
		draw_text(10, 30, "You won!");
	} else {
		draw_text(10, 30, "You lost!");
	}
	
	draw_set_color(c_green);
	draw_text(10, 50, "Press R to restart the game");
}