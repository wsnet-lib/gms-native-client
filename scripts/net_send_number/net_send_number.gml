/**
 * Send a float32 to a player
 *
 * @param {Integer} msgId Custom message ID
 * @param {Integer} player Player ID
 * @param {Real<f64>} payload Data to send
  * @param {Integer} [reliable] If the packet has to be reliable (0 or 1)
 */
function net_send_number(msgId, player, payload, reliable=0) {
	if (player < 0) player = 255; // Broadcast
	
	var buf = buffer_create(9 + NET_HEADER_SIZE, buffer_fixed, 1);
	buffer_write(buf, buffer_u8, net_cmd.game_message);
	buffer_write(buf, buffer_u8, player);
	buffer_write(buf, buffer_u16, msgId);
	buffer_write(buf, buffer_u8, net_type.number);
	buffer_write(buf, buffer_f32, payload);
	
	__net_send(buf, reliable);
}