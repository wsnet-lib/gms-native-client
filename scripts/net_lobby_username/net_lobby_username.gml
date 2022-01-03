/**
 * Rename the player username. The player must have joined a lobby
 *
 * @note The event will be also broadcasted to the other lobby players
 * @note This message is sent as reliable.
 *
  * @param {String} username New player username
 */
function net_lobby_username(new_username) {
	var buf = buffer_create(2 + string_byte_length(new_username) + NET_HEADER_SIZE, buffer_fixed, 1);
	buffer_write(buf, buffer_u8, net_cmd.lobby_username);
	buffer_write(buf, buffer_string, new_username);
	
	__net_send(buf, 1);
}