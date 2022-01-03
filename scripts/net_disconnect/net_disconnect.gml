/**
 * Disconnect from the server (virtually) by freeing the memory
 */
function net_disconnect() {
	if (!instance_exists(obj_net_manager)) return;
	
	// Tell the server that the client is quitting
	var buffer = buffer_create(1 + NET_HEADER_SIZE, buffer_fixed, 1);
	buffer_write(buffer, buffer_u8, net_cmd.disconnect);
	__net_send(buffer);
	
	with (obj_net_manager) {
		network_destroy(socket);
		instance_destroy();
	}
}