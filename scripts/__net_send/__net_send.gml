/**
 * Send a buffer to the server, by appending the header and registering the reliable trigger if specified
 *
 * @param {Buffer} buffer
 * @param {Boolean} [reliable]
 */
function __net_send(buffer, reliable=0) {
	with (__obj_net_manager) {
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
		
		// The condition will emulate a network with a packet loss
		var can_send_packet = (!global.net_test_packet_loss_min && !global.net_test_packet_loss_max) ||
			irandom(100) > irandom_range(global.net_test_packet_loss_min, global.net_test_packet_loss_max);
		
		var immediate_packet = !global.net_test_packet_delay_min && !global.net_test_packet_delay_max;
			
		if (can_send_packet) {
			// Send the packet
			if (immediate_packet) {
				network_send_raw(socket, buffer, size);
			} else {
				// Schedule the packet for a delayed sending (for network emulation purposes)	
				variable_struct_set(delayed_packets, current_packet_id, { 
					buffer: buffer, 
					size: size, 
					delay: irandom_range(global.net_test_packet_delay_min, global.net_test_packet_delay_max),
					send: true
				});
			}
		} else {
			__net_log("⚠ NETWORK EMULATION: Packet " + string(current_packet_id) + " has been dropped");
		}
	
		if (reliable) {
			variable_struct_set(rpackets, current_packet_id, {
				buffer: buffer, 
				buffer_size: size,
				tempt: 0
			});
		} else if (can_send_packet && immediate_packet) {
			buffer_delete(buffer);
		}
	}
}