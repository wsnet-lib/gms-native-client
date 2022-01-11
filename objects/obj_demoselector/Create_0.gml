window_set_size(room_width, room_height);
alarm[0] = 1; // Center the window position

brk = chr(13) + chr(10);

/** Server connection */
net_connect("localhost", 8080);
global.net_enable_logs = true;
global.net_enable_trace_logs = true;