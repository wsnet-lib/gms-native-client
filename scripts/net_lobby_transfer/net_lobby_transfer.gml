/**
 * Transfer the admin to another player in the lobby
 *
 * @note The event will be also broadcasted to the other lobby players
 * @note This message is sent as reliable.
 *
 * @param {Integer} player_id Player ID of the new admin
 */
function net_lobby_transfer(player_id) {
	var buf = buffer_create(2 + NET_HEADER_SIZE, buffer_fixed, 1);
	buffer_write(buf, buffer_u8, net_cmd.lobby_transfer);
	buffer_write(buf, buffer_u8, player_id); // New admin id
	
	__net_send(buf, 1);
}