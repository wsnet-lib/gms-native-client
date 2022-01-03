/**
 * Change the lobby password
 *
 * @note This message is sent as reliable.
 *
 * @param {String} password New lobby password
 */
function net_lobby_password(password) {
	var buf = buffer_create(2 + string_byte_length(password) + NET_HEADER_SIZE, buffer_fixed, 1);
	buffer_write(buf, buffer_u8, net_cmd.lobby_password);
	buffer_write(buf, buffer_string, password);
	
	__net_send(buf, 1);
}