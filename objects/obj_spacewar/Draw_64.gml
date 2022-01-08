draw_set_color(c_white); draw_set_halign(fa_left); draw_set_valign(fa_top);

if (!instance_exists(obj_net_manager)) {
	draw_text(10, 30, "Error: connection lost");
	exit;
}

draw_set_halign(fa_right);
draw_text(room_width-10, 10, "Ping: " + string(obj_net_manager.ping_ms) + "ms");
draw_set_halign(fa_left);

// Players count
draw_text(10, 10, "Players: " + string(array_length(obj_net_manager.players)));