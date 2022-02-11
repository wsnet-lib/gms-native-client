/** Send the delayed packets */
if (!global.net_test_packet_delay_min && !global.net_test_packet_delay_max) exit;

var packets = variable_struct_get_names(delayed_packets);

for (var i=0, l=array_length(packets); i<l; i++) {
	var packet_id = packets[i];
	var packet = delayed_packets[$ packet_id];

	// Reduce the packet delay time
	packet.delay--;
	
	// Send or decode the packet
	if (packet.delay < 1) {		
		network_send_raw(socket, packet.buffer, packet.size);
		buffer_delete(packet.buffer);
		variable_struct_remove(delayed_packets, packet_id);
	}
}