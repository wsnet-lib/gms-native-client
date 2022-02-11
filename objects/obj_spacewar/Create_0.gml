window_set_size(960, 540);
alarm[0] = 1; // Center the window position
randomize();
tickrate = room_speed / 30; // Server updates tickrate
is_admin = undefined; // If the current player is an admin
audio_play_sound(snd_spacewar_bg, 10, true);
played_audio_shots = []; // Currently played audio shots
alarm[2] = 1; // Start the shots audio check manager

// Networking messages types
enum spacewar_msg {
	player_pos, // Update a player position
	player_state, // Set the players state,
	shot // Shot
}

/** Create the players (self and the enemies) */
function createPlayers() {
	var player = instance_create_layer(-999, -999, "Instances", obj_spacewar_player);
	player.playerId = global.net_player_id;	
	player.image_index = irandom(sprite_get_number(spr_spacewar_player));
	
	var playerMap = global.net_players_map[$ player.playerId];
	playerMap.obj = player;
	
	// Broadcast its state
	var state = {
		id: player.playerId,
		index: player.image_index,
		hp: player.hp,
		receive_state: true
	};
	net_send_struct(spacewar_msg.player_state, all, state, true);
	
	// Create the other enemies and ask their state
	for (var i=0, len=array_length(global.net_players); i<len; i++) {
		var netEnemy = global.net_players[i];
		var enemy = instance_create_layer(-999, -999, "Instances", obj_spacewar_enemy);
		enemy.playerId = netEnemy.id;
		
		var enemyMap = global.net_players_map[$ netEnemy.id];
		enemyMap.obj = enemy;
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
	createPlayers();
});

// When a new player joins, add it as enemy
net_event(net_evt.player_join, function(success, player) {
	// Create the new enemy instance
	var enemy = instance_create_layer(-999, -999, "Instances", obj_spacewar_enemy);
	enemy.playerId = player.id;
	
	var enemyMap = global.net_players_map[$ player.id];
	enemyMap.obj = enemy;
});

// Remove a player from the game
net_event(net_evt.player_leave, function(success, player) {
	with (obj_spacewar_enemy) {
		if (playerId != player.id) continue;
		instance_destroy();
	}
});

// Update a player position state
// If this is the first update, directly set the final variables and not the target variables
net_on(spacewar_msg.player_pos, function(sender_id, pos) {
	var enemyMap = global.net_players_map[$ sender_id];
	if (enemyMap == undefined) return;
	with (enemyMap.obj) {
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

// Set the players state
net_on(spacewar_msg.player_state, function(sender_id, state) {
	var enemyMap = global.net_players_map[$ state.id];	
	if (enemyMap == undefined) return;
	with (enemyMap.obj) {
		image_index = state.index;
		hp = state.hp;
	}
	
	// Send back my state to the sender
	if (state.receive_state) {
		var playerState = {
			id: obj_spacewar_player.playerId,
			index: obj_spacewar_player.image_index,
			hp: obj_spacewar_player.hp,
			receive_state: false
		};
		net_send_struct(spacewar_msg.player_state, sender_id, playerState, true);
	}
});

// Create an enemy shot
net_on(spacewar_msg.shot, function(sender_id, pos) {
	var enemyMap = global.net_players_map[$ sender_id];
	if (enemyMap == undefined) return;
	with (enemyMap.obj) {
		shotX = pos[0];
		shotY = pos[1];
		shotTargetX = pos[2];
		shotTargetY = pos[3];
		scr_spacewar_create_shot();
	}
});

net_lobby_join_auto();