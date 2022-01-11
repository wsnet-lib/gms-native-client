// Broadcast the player position
with (obj_spacewar_player) {
	net_send_array(spacewar_msg.player_pos, all, [x, y, speed, direction]);	
}

alarm[1] = tickrate;