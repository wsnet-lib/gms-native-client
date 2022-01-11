/**
 * Create a lobby
 *
 * @note This message is sent as reliable.
 *
 * @param {String} [lobby_name] Lobby name
 * @param {Integer<u8>} [max_players] Max count of players allowed in the lobby
 * @param {String} [username] Username of the lobby admin
 * @param {String} [password] Optional lobby password (empty string or undefined = public lobby)
 */
function net_lobby_create(lobby_name = "", max_players = 12, username = "", password = "") {
	if (password == undefined) password = "";
	
	var buf = buffer_create(5 + string_byte_length(lobby_name) + string_byte_length(username) +
		string_byte_length(password) + NET_HEADER_SIZE, buffer_fixed, 1);
	buffer_write(buf, buffer_u8, net_cmd.lobby_create);
	buffer_write(buf, buffer_string, lobby_name); //name
	buffer_write(buf, buffer_u8, max_players); //max players
	buffer_write(buf, buffer_string, username); //username
	buffer_write(buf, buffer_string, password); //password
	
	__net_send(buf, 1);
}