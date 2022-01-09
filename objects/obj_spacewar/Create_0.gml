window_set_size(960, 540);
alarm[0] = 1; // Center the window position
randomize();
tickrate = room_speed / 30; // Server updates tickrate
is_admin = undefined; // If the current player is an admin

/** Server connection */
net_connect("localhost", 8080);
global.net_enable_logs = true;
global.net_enable_trace_logs = true;

// Networking messages types
enum spacewar_msg {
	player_pos, // Update a player position
}

// Quit the game on a server generic error or if the server has reconnected (pratically if the previous lobby is lost)
net_event(net_evt.error, game_end);
net_event(net_evt.lobby_data, function(success, has_reconnected) {
	if (has_reconnected) game_end();
});

function createPlayers() {
	var player = instance_create_layer(-999, -999, "Instances", obj_spacewar_player);
	player.playerId = global.net_player_id;
	
	for (var i=0, len=array_length(global.net_players); i<len; i++) {
		var netEnemy = global.net_players[i];
		var enemy = instance_create_layer(-999, -999, "Instances", obj_spacewar_enemy);
		enemy.playerId = netEnemy.id;
	}
	
	alarm[1] = 1; // Start the players state updates
}

// If no lobbies are found, just create a lobby
net_event(net_evt.lobby_join, function(success)  {	
	is_admin = !success;
	if (!success) {
		net_lobby_create();
	} else {
		// Create the player object (on lobby join)
		createPlayers();
	}
});

// Create the player object (on lobby creation)
net_event(net_evt.lobby_create, function(success) {
	createPlayers()
});

// When a new player joins, add it as enemy
net_event(net_evt.player_join, function(success, player) {	
	var enemy = instance_create_layer(-999, -999, "Instances", obj_spacewar_enemy);
	enemy.playerId = player.id;
});

// Remove a player from the game
net_event(net_evt.player_leave, function(success, player) {
	with (obj_spacewar_enemy) {
		if (playerId != player.id) continue;
		instance_destroy();
		break;
	}
});

// Update a player position state
// If this is the first update, directly set the final variables and not the target variables
net_on(spacewar_msg.player_pos, function(sender_id, pos) {
	with (obj_spacewar_enemy) {
		if (playerId != sender_id) continue;
		
		if (!firstUpdateReceived) {
			x = pos[0];			
			y = pos[1];
			speed = pos[2];
			direction = pos[3];
			xTarget = x;
			yTarget = y;
			speedTarget = speed;
			directionTarget = direction;
			firstUpdateReceived = true;
		} else {
			xTarget = pos[0];
			yTarget = pos[1];
			speedTarget = pos[2];
			directionTarget = pos[3];
		}
		break;
	}
});

net_lobby_join_auto();