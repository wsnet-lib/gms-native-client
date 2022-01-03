/**
 * Get the list of banned players of the currently joined lobby
 *
 * @note This message is sent as reliable.
 */
function net_lobby_get_banned() {
	var buf = buffer_create(1 + NET_HEADER_SIZE, buffer_fixed, 1);
	buffer_write(buf, buffer_u8, net_cmd.lobby_bans);
	
	__net_send(buf, 1);
}