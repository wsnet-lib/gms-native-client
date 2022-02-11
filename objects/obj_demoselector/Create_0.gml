window_set_size(room_width, room_height);
alarm[0] = 1; // Center the window position

brk = chr(13) + chr(10);

/** Server connection */
net_connect("localhost", 8080);
//net_connect("udp-test-1.fly.dev", 8080);
global.net_enable_logs = true;
global.net_enable_trace_logs = true;

// Quit the game on a server generic error or if the server has reconnected (pratically if the previous lobby is lost)
net_event(net_evt.error, game_end);
net_event(net_evt.lobby_data, function(success, has_reconnected) {
	if (has_reconnected) game_end();
});