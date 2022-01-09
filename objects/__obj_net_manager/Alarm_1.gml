/// Resend the reliable packets, which have not been acked
var packets = variable_struct_get_names(rpackets);
var packets_count = array_length(packets);
var num_resent_rpackets = 0;

for (var i=0; i<packets_count; i++) {
	var packet_id = packets[i];
	var packet = rpackets[$ packet_id];
		
	// If the packet has reached the max tempts, discard it
	if (packet.tempt >= NET_MAX_RELIABLE_TEMPTS) {
		variable_struct_remove(rpackets, packet_id);
	} else {
		// Else send again the packet
		packet.tempt++;
		network_send_raw(socket, packet.buffer, packet.buffer_size);
		num_resent_rpackets++;
	}
		
	buffer_delete(packet.buffer);
}

if (global.net_enable_logs && num_resent_rpackets) {
	__net_log("🡆 Resent " + string(num_resent_rpackets) + " out of " + string(packets_count) + " reliable packets");
}

alarm[2] = NET_TIMER_RESEND_RELIABLE;