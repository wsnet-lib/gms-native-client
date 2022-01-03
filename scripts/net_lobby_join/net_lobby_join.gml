/**
 * Join a specific lobby
 *
 * @note The event will be also broadcasted to the other lobby players
 * @note This message is sent as reliable.
 *
 * @param {Integer<u32>} lobby_id Lobby ID
 * @param {String} username Player username
 * @param {String} [password] Optional lobby password (empty string or undefined for public lobbies)
 */
function net_lobby_join(lobby_id, username, password) {
	if (password == undefined) password = "";
	
	var buf = buffer_create(7 + string_byte_length(username) + string_byte_length(password) +
		+ NET_HEADER_SIZE, buffer_fixed, 1);
	buffer_write(buf, buffer_u8, net_cmd.lobby_join);
	buffer_write(buf, buffer_string, username); //username
	buffer_write(buf, buffer_u32, lobby_id);  //lobby id        
	buffer_write(buf, buffer_string, password); //password 
	
	__net_send(buf, 1);
}