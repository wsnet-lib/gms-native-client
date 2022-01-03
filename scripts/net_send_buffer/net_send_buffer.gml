/**
 * Send a buffer to a player
 *
 * @param {Integer} msgId Custom message ID
 * @param {Integer} player Player ID which to send this message
 * @param {Bufffer} payload Data to send
 * @param {Integer} [reliable] If the packet has to be reliable (0 or 1)
 */
function net_send_buffer(msgId, player, payload, reliable=0) {
	if (player < 0) player = 255; // Broadcast 
	
	var size = buffer_get_size(payload);
	var buf = buffer_create(5 + size + NET_HEADER_SIZE, buffer_fixed, 1);
	buffer_write(buf, buffer_u8, net_cmd.game_message);
	buffer_write(buf, buffer_u8, player);
	buffer_write(buf, buffer_u16, msgId);
	buffer_write(buf, buffer_u8, net_type.raw);
	buffer_copy(payload, 0, size, buf, 0);
	
	__net_send(buf, reliable);
}