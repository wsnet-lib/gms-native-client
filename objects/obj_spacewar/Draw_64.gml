draw_set_color(c_white); draw_set_halign(fa_left); draw_set_valign(fa_top);

if (!global.net_connected) {
	draw_text(10, 30, "Error: connection lost");
	exit;
}

draw_set_halign(fa_right);
draw_text(room_width-10, 10, "Ping: " + string(global.net_ping_ms) + "ms");
draw_set_halign(fa_left);

// Players count
draw_text(10, 10, "Players: " + string(array_length(global.net_players)));

draw_set_color(c_red); draw_set_halign(fa_right);
draw_text(room_width-10, 30, "DEMO WORK IN PROGRESS");