/**
 * Send a ds_map of mixed values to a player
 *
 * @param {Integer} msgId Custom message ID
 * @param {Integer} player Player ID
 * @param {DsMap<String, Any>} payload Data to send
  * @param {Integer} [reliable] If the packet has to be reliable (0 or 1)
 */
function net_send_map(msgId, player, payload, reliable=0) {
	if (player < 0) player = 255; // Broadcast
	
	// Precalculate the payload size
	var len = ds_map_size(payload);
	
	// Build the buffer
	var buf = buffer_create(7 + len, buffer_grow, 1);
	buffer_write(buf, buffer_u8, net_cmd.game_message);
	buffer_write(buf, buffer_u8, player);
	buffer_write(buf, buffer_u16, msgId);
	buffer_write(buf, buffer_u8, net_type.map);
	
	buffer_write(buf, buffer_u16, len);
	var key = ds_map_find_first(payload);	
	for (var i = 0; i<len; i++) {
		__net_buffer_append_mixed_value(buf, payload[? key]);
		key = ds_map_find_next(payload, key);
	}
	
	buffer_resize(buf, buffer_tell(buf) + NET_HEADER_SIZE);
	__net_send(buf, reliable);
}