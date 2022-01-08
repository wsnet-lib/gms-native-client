#macro NET_TIMER_SERVER_DISCONNECTION 10000000
#macro NET_TIMER_PING 60
#macro NET_TIMER_RESEND_RELIABLE 120
#macro NET_MAX_RELIABLE_TEMPTS 5
#macro NET_HEADER_SIZE 5

enum net_evt {
	connection,
	connection_close,	
	error,
	lobby_data,
	lobby_create,
	lobby_join,
	lobby_leave,
	lobby_allow_join,
	lobby_get_banned,
	lobby_get_list,
	lobby_max_players,
	lobby_password,
	lobby_transfer,
	lobby_unban,	
	player_join,
	player_leave,
	player_kickban,
	player_username,	
	events_count
}

enum net_cmd {
    error,
	game_message,
	lobby_list,
	lobby_create,
	lobby_join,
	lobby_join_auto,
	lobby_player_joined,
	lobby_leave,
	lobby_player_left,
	lobby_transfer,
	lobby_transfer_changed,
	lobby_allow_join,
	lobby_allow_join_changed,
	lobby_max_players,
	lobby_max_players_changed,
	lobby_kick,
	lobby_player_kicked,
	lobby_username,
	lobby_player_username,
	lobby_bans,
	lobby_unban,
	lobby_password,
	lobby_data,
	ack,
	ping,
	disconnect
}

enum net_sort {
    no_sort,
    ascending,
    descending
}

enum net_type {
    raw,
    byte,
    byte_array,
    number,
    number_array,
    text,
    text_array,
    array,
    list,
    map,
	integer32,
    integer64,
	struct
}

enum net_error {
    no_error,
    command_not_found,
    player_not_found,
    lobby_not_found,
    unauthorized,
    wrong_password,
    max_lobby_players,
    input_validation_failed,
    already_in_lobby,
    server_error,
    callback_not_found,
    incorrect_type,
	reliable_packet_not_found
}

/**
 * Bind a network socket to the specified server
 * The connection status is handled through periodic pings (specifically useful for UDP).
 * This also acts as an init function and the memory can be freed by the net_disconnect() function
 *
 * @version 2.0.0
 *
 * @param {String} address The address of the remote server
 * @param {String} port The port of the remote server
 * @param {Function [on_connect] On connection callback (useful for TCP/WS protocols)
 * @param {Real} [socket_type] Socket type (by default network_socket_udp)
 * @param {String} [layer] The layer which the net manager instance will be created
 */
function net_connect(address, port, on_connect = undefined, socket_type = network_socket_udp, layer = "Instances") {
	instance_create_layer(0, 0, layer, obj_net_manager);
	
	with (obj_net_manager) {
		server_uuid = undefined;
		enable_logs = false; // Globally enable the generic logs
		enable_trace_logs = false; // Enable additional logs for minor things like pings and acks
		packet_id = 0; // Packet ID sequence
		__last_server_pong = get_timer();
		__ping_timer =  __last_server_pong; // Internal usage. Used to precisely calculate the ping
		ping_ms = 0; // Ping in ms
		
		rpackets = {}; // Map of reliable messages
		socket = network_create_socket(socket_type); // Socket
		events = array_create(net_evt.events_count, function() {}); // Events callbacks
		error_id = undefined;
		game_message_callbacks = {}; // Game messages callbacks
		
		// Connection callback
		if (on_connect != undefined && on_connect != noone) {
			events[net_evt.connection] = on_connect;	
		}
		
		// Lobby state
		lobby_id = undefined;
		players_count = 0;
		player_id = undefined;
		player_name = undefined;		
		admin_id = undefined;
		players = [];
		players_map = {};
		lobbies = [];
	
		// Command names struct (for debugging only)
		commands = {};
		commands[$ net_cmd.error] = "error";
		commands[$ net_cmd.game_message] = "game_message";
		commands[$ net_cmd.lobby_list] = "lobby_list";
		commands[$ net_cmd.lobby_create] = "lobby_create";
		commands[$ net_cmd.lobby_join] = "lobby_join";
		commands[$ net_cmd.lobby_join_auto] = "lobby_join_auto";
		commands[$ net_cmd.lobby_player_joined] = "lobby_player_joined";
		commands[$ net_cmd.lobby_leave] = "lobby_leave";
		commands[$ net_cmd.lobby_player_left] = "lobby_player_left";
		commands[$ net_cmd.lobby_transfer] = "lobby_transfer";
		commands[$ net_cmd.lobby_transfer_changed] = "lobby_transfer_changed";
		commands[$ net_cmd.lobby_allow_join] = "lobby_allow_join";
		commands[$ net_cmd.lobby_allow_join_changed] = "lobby_allow_join_changed";
		commands[$ net_cmd.lobby_max_players] = "lobby_max_players";
		commands[$ net_cmd.lobby_max_players_changed] = "lobby_max_players_changed";
		commands[$ net_cmd.lobby_kick] = "lobby_kick";
		commands[$ net_cmd.lobby_player_kicked] = "lobby_player_kicked";
		commands[$ net_cmd.lobby_username] = "lobby_username";
		commands[$ net_cmd.lobby_player_username] = "lobby_player_username";
		commands[$ net_cmd.lobby_bans] = "lobby_bans";
		commands[$ net_cmd.lobby_unban] = "lobby_unban";
		commands[$ net_cmd.lobby_password] = "lobby_password";
		commands[$ net_cmd.lobby_data] = "lobby_data";
		commands[$ net_cmd.ack] = "ack";
		commands[$ net_cmd.ping] = "ping";
		commands[$ net_cmd.disconnect] = "disconnect";
		
		// Error names struct (for debugging only)
		errors = {};
		errors[$ net_error.no_error] = "no_error";
		errors[$ net_error.command_not_found] = "command_not_found";
		errors[$ net_error.player_not_found] = "player_not_found";
		errors[$ net_error.lobby_not_found] = "lobby_not_found";
		errors[$ net_error.unauthorized] = "unauthorized";
		errors[$ net_error.wrong_password] = "wrong_password";
		errors[$ net_error.max_lobby_players] = "max_lobby_players";
		errors[$ net_error.input_validation_failed] = "input_validation_failed";
		errors[$ net_error.already_in_lobby] = "already_in_lobby";
		errors[$ net_error.server_error] = "server_error";
		errors[$ net_error.callback_not_found] = "callback_not_found";
		errors[$ net_error.incorrect_type] = "incorrect_type";
		errors[$ net_error.reliable_packet_not_found] = "reliable_packet_not_found";
		
		// Send the initial ping and check the server disconnection
		alarm[0] = 1;
	
		// Schedule the next reliable packets resending
		alarm[1] = NET_TIMER_RESEND_RELIABLE;
		
		// Bind the socket to the specified address and port
		network_connect_raw_async(socket, address, port);
	}	
}