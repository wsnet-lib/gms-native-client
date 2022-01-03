/**
 * Allow or disallow the joining of new players into the lobby
 *
 * @note The event will be also broadcasted to the other lobby players
 * @note This message is sent as reliable.
 *
 * @param {Integer} allow
 */
function net_lobby_allow_join(allow) {
	var buf = buffer_create(2 + NET_HEADER_SIZE, buffer_fixed, 1);
	buffer_write(buf, buffer_u8, net_cmd.lobby_allow_join);
	buffer_write(buf, buffer_u8, allow);
	
	__net_send(buf, 1);
}