// Check if you can select this box
if (!instance_exists(obj_net_manager) || obj_tris.turn != obj_net_manager.player_id || obj_tris.winner != -1 || selected) exit;

// Select the box (place the symbol on it)
selected = true;
obj_tris.turn = !obj_tris.turn;
net_send_array(tris_msg.select, obj_tris.other_player.id, [xpos, ypos], 1);
image_index = obj_tris.player_symbol + 2;
symbol = obj_tris.player_symbol;

// Check the game over
scr_tris_check_finish(symbol);