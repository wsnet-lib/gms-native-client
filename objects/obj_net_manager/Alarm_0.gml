/// Server disconnection check
var timer = get_timer();
if (timer - __last_server_pong > NET_TIMER_SERVER_DISCONNECTION) {
	if (enable_logs) {
	__net_log("Lost connection to the server");
	}
	net_disconnect();
	exit;
}

/// Send a ping to the server
if (enable_logs && enable_trace_logs) {
	__net_log("◯🡆 Sending ping to the server");
}
__ping_timer = timer;
var buffer = buffer_create(1 + NET_HEADER_SIZE, buffer_fixed, 1);
buffer_write(buffer, buffer_u8, net_cmd.ping);
__net_send(buffer);

alarm[0] = NET_TIMER_PING;