switch (async_load[? "type"]) {
	case network_type_data:
		// Decode the buffer
		var buffer = async_load[? "buffer"];
		var buffer_size = buffer_get_size(buffer);
		var cmd_id = buffer_read(buffer, buffer_u8);
		var packet_id = buffer_peek(buffer, buffer_size - 5, buffer_u32);
		var reliable = buffer_peek(buffer, buffer_size - 1, buffer_u8);

		if (global.net_enable_logs && cmd_id != net_cmd.ping && cmd_id != net_cmd.ack) {
			__net_log("🡄 Command '" + string(commands[$ cmd_id]) + "' received from server with buffer " + __net_decode_buffer(buffer));
		}

		// Ack the server message when requested
		if (reliable == 2) {
			if (global.net_enable_logs && global.net_enable_trace_logs) {
				__net_log("🡆 Sending ack for the server message " + string(packet_id));
			}
			var ackBuffer = buffer_create(buffer_size, buffer_fixed, 1);
			buffer_copy(buffer, 0, buffer_size, ackBuffer, 0);
			buffer_poke(ackBuffer, 0, buffer_u8, net_cmd.ack);
			buffer_poke(ackBuffer, buffer_size-1, buffer_u8, 0);
			network_send_raw(socket, ackBuffer, buffer_size);
			buffer_delete(ackBuffer);
		}

		// Handle the packet
		__net_handle_incoming_packet(cmd_id, packet_id, buffer, buffer_size);		
	break;
	
	// For TCP/WS protocols
	case network_type_connect:
		events[net_evt.connection]();
	break;
	
	case network_type_disconnect:
		net_disconnect();
		events[net_evt.connection_close]();
	break;
}