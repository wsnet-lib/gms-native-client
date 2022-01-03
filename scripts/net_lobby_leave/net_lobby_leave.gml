/**
 * Leave the currently joined lobby
 * @note The event will be also broadcasted to the other lobby players
 * @note This message is sent as reliable.
 */
function net_lobby_leave() {
	var buf = buffer_create(1 + NET_HEADER_SIZE, buffer_fixed, 1);
	buffer_write(buf, buffer_u8, net_cmd.lobby_leave);
	
	__net_send(buf, 1);
}