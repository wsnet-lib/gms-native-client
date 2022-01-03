/**
 * Remove a player from the players list
 *
 * @param {Integer} removed_player_id
 *
 * @return {Struct<Player>|undefined} Return the removed player or undefined
 */
function __net_remove_player(removed_player_id) {
	var removed_player = players_map[$ removed_player_id];
	if (!removed_player) return undefined;
	
	var len = array_length(players);
	for (var i=0; i<len; i++) {
		if (players[i].id == removed_player.id) {
			array_delete(players, i, 1);
			break;
		}
	}
	
	variable_struct_remove(players_map, removed_player.id);
	return removed_player;
}