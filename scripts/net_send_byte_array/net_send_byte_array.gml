/**
 * Send an array of u8 bytes to a player
 *
 * @param {Integer} msgId Custom message ID
 * @param {Integer} player Player ID
 * @param {Array<Integer<u8>>} payload Data to send
  * @param {Integer} [reliable] If the packet has to be reliable (0 or 1)
 */
function net_send_byte_array(msgId, player, payload, reliable=0) {
	if (player < 0) player = 255; // Broadcast
	
	var len = array_length(payload);	
	var buf = buffer_create(7 + len + NET_HEADER_SIZE, buffer_fixed, 1);
	buffer_write(buf, buffer_u8, net_cmd.game_message);
	buffer_write(buf, buffer_u8, player);
	buffer_write(buf, buffer_u16, msgId);
	buffer_write(buf, buffer_u8, net_type.byte_array);
	
	buffer_write(buf, buffer_u16, len);
	for (var i = 0; i<len; i++) {
	    buffer_write(buf, buffer_u8, payload[i]);
	}
	
	__net_send(buf, reliable);
}