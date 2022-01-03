/**
 * Change the max players allowed to join in the lobby
 *
 * @note This message is sent as reliable.
 *
 * @param {Integer} max_players Max players allowed to join in the lobby
 */
function net_lobby_max_players(max_players) {
	var buf = buffer_create(2 + NET_HEADER_SIZE, buffer_fixed, 1);
	buffer_write(buf, buffer_u8, net_cmd.lobby_max_players);
	buffer_write(buf, buffer_u8, max_players);
	
	__net_send(buf, 1);
}