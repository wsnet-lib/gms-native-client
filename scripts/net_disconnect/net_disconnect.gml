/**
 * Disconnect from the server (virtually) by freeing the memory
 */
function net_disconnect() {
	if (!global.net_connected) return;
	
	global.net_connected = false;
	delete global.net_enable_logs;
	delete global.net_enable_trace_logs;
	delete global.net_ping_ms;
	delete global.net_error_id;
	delete global.net_lobby_id;	
	delete global.net_players_count;	
	delete global.net_player_id;
	delete global.net_player_name;
	delete global.net_admin_id;
	delete global.net_players;
	delete global.net_players_map;
	delete global.net_lobbies;
	
	// Tell the server that the client is quitting
	var buffer = buffer_create(1 + NET_HEADER_SIZE, buffer_fixed, 1);
	buffer_write(buffer, buffer_u8, net_cmd.disconnect);
	__net_send(buffer);
	
	with (__obj_net_manager) {
		network_destroy(socket);
		instance_destroy();
	}
}