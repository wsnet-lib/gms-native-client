/**
 * Ban a player from the lobby
 *
 * @note The event will be also broadcasted to the other lobby players
 * @note This message is sent as reliable.
 * @note A lobby may have up to 65535 banned players at the same time
 *
 * @param {Integer} player_id Player ID
 */
function net_lobby_ban(player_id) {
	var buf = buffer_create(3 + NET_HEADER_SIZE, buffer_fixed, 1);
	buffer_write(buf, buffer_u8, net_cmd.lobby_allow_join);
	buffer_write(buf, buffer_u8, player_id);
	buffer_write(buf, buffer_u8, 1); //0: kick, 1: ban
	
	__net_send(buf, 1);
}