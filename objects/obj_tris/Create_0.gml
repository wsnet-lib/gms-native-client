window_set_size(room_width, room_height);
alarm[0] = 1; // Center the window position
randomize();
player1_symbol = undefined;
player2_symbol = undefined;
player_symbol = undefined;
is_admin = undefined;
turn = undefined; // Which player can play
other_player = undefined; // Who is the other player
winner = -1; // If the game has ended
grid = array_create(3, array_create(3)); // Create the boxes grid
restarting = false; // If the game is restarting

// Networking messages types
enum tris_msg {
	start, // Game start
	select, // Player has selected a box
	finish, // The game is over
}

// Quit the game on a server generic error or if the server has reconnected (pratically if the previous lobby is lost)
net_event(net_evt.error, game_end);
net_event(net_evt.lobby_data, function(success, has_reconnected) {
	if (has_reconnected) game_end();
});

// If no lobbies are found, just create a lobby, otherwise note who is the opponent player
net_event(net_evt.lobby_join, function(success)  {
	if (success) {
		other_player = global.net_players[0];
	} else {
		net_lobby_create("Lobby", 2, "P1");
	}
});

net_event(net_evt.lobby_create, function(success, lobby_id) {
	// Decide the player symbols and who starts the game
	player1_symbol = irandom(1);
	player2_symbol = !player1_symbol ? 1 : 0;
	turn = irandom(1);
	player_symbol = player1_symbol;
	is_admin = true;
});

// When the other player has joined, tell the initial choices and the confirm to start
net_event(net_evt.player_join, function(success, player) {	
	other_player = global.net_players[1];
	net_send_array(tris_msg.start, other_player.id, [player1_symbol ,player2_symbol, turn], 1);
	scr_tris_create_grid();
});

// When the other player leaves, quit the game
net_event(net_evt.player_leave, function() {
	net_lobby_leave();
});

net_event(net_evt.lobby_leave, function() {
	// The alarm ensures that the other client has restarted (just for debugging)
	alarm[1] = 10;
});

// The player2 will wait for this start message with the initial choices
net_on(tris_msg.start, function(sender_id, choices) {
	player1_symbol = choices[0];
	player2_symbol = choices[1];
	turn = choices[2];
	player_symbol = player2_symbol;
	is_admin = false;
	scr_tris_create_grid();
});

// Check the game over when the other player select a box
net_on(tris_msg.select, function(sender_id, pos) {
	var xpos = pos[0];
	var ypos = pos[1];
	turn = !turn;
	var box = grid[xpos][ypos];
	box.selected = true;
	var symbol = !sender_id ? player1_symbol : player2_symbol;
	box.image_index = 2 + symbol;	
	box.symbol = symbol;
	scr_tris_check_finish(symbol);
});

net_lobby_join_auto("P2");