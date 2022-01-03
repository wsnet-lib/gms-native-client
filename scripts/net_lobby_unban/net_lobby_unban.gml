/**
 * Unban a player from the lobby
 *
 * @note This message is sent as reliable.
 *
 * @param {String} short_hash Player short hash identifier (this field is retrieved from the "lobby_bans" event)
 */
function net_lobby_unban(short_hash) {
	var buf = buffer_create(2 + NET_HEADER_SIZE, buffer_fixed, 1);
	buffer_write(buf, buffer_u8, net_cmd.lobby_unban);
	buffer_write(buf, buffer_string, short_hash);
	
	__net_send(buf, 1);
}