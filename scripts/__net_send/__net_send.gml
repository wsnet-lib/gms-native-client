/**
 * Send a buffer to the server, by appending the header and registering the reliable trigger if specified
 *
 * @param {Buffer} buffer
 * @param {Boolean} [reliable]
 */
function __net_send(buffer, reliable=0) {
	with (obj_net_manager) {
		var current_packet_id = packet_id++;
	
		// Packet Header
		buffer_write(buffer, buffer_u32, current_packet_id);
		buffer_write(buffer, buffer_u8, reliable);
		
		// Logs
		if (global.net_enable_logs) {
			var cmd_id = buffer_peek(buffer, 0, buffer_u8);
			if (cmd_id != net_cmd.ping) {
				__net_log("🡆 Sending message '" + commands[$ cmd_id] + "' with buffer " + __net_decode_buffer(buffer));	
			}
		}
	
		var size = buffer_get_size(buffer);
		network_send_raw(socket, buffer, size);
	
		if (reliable) {
			variable_struct_set(rpackets, current_packet_id, {
				buffer: buffer, 
				buffer_size: size,
				tempt: 0
			});
		} else {
			buffer_delete(buffer);
		}
	}
}