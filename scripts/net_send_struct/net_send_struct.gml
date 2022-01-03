/**
 * Send a struct to a player. The value will be json stringified
 *
 * @param {Integer} msgId Custom message ID
 * @param {Integer} player Player ID
 * @param {Struct} payload Data to send
  * @param {Integer} [reliable] If the packet has to be reliable (0 or 1)
 */
function net_send_struct(msgId, player, payload, reliable=0) {
	if (player < 0) player = 255; // Broadcast
	
	var encoded_payload = json_stringify(payload);
	var buf = buffer_create(6 + string_byte_length(encoded_payload) + NET_HEADER_SIZE, buffer_fixed, 1);
	buffer_write(buf, buffer_u8, net_cmd.game_message);
	buffer_write(buf, buffer_u8, player);
	buffer_write(buf, buffer_u16, msgId);
	buffer_write(buf, buffer_u8, net_type.struct);
	buffer_write(buf, buffer_string, encoded_payload);
	
	__net_send(buf, reliable);
}