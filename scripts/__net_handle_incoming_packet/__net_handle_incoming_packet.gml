/**
 * Handle an incoming packet
 *
 * @param {Integer} cmd_id Command ID
 * @param {Integer} packet_id Packet ID
 * @param {Buffer} buffer Data buffer
 * @param {Integer} buffer_size Data buffer size
 */
function __net_handle_incoming_packet(cmd_id, packet_id, buffer, buffer_size) {
	switch (cmd_id) {
		case net_cmd.error:
			error_id = buffer_peek(buffer, 1, buffer_u8);
			events[net_evt.error](false);
		
			if (enable_logs) {
				__net_log("🡄 Error '" + string(errors[$ error_id]) + "' received");
			}
		break;
	
		case net_cmd.ping:
			__last_server_pong = get_timer();
			ping_ms = round((__last_server_pong - __ping_timer) / 1000);
		
			if (enable_logs && enable_trace_logs) {
				__net_log("🡄⬤ Pong received in " + string(ping_ms) + "ms");
			}
		break;
	
		case net_cmd.ack:
			// Ack a reliable packet
			if (enable_logs && enable_trace_logs) {
				__net_log("🡄 Server sent the ack for the client message " + string(packet_id));
			}
		
			var packet = rpackets[$ packet_id];
			buffer_delete(packet.buffer);
			variable_struct_remove(rpackets, packet_id);
		break;
	
		case net_cmd.game_message:
			__net_handle_game_message(buffer, buffer_size);			
			break;
			
		case net_cmd.lobby_data:
			var current_server_uuid = server_uuid;
			server_uuid = buffer_read(buffer, buffer_string);
			
			// Detect a server reconnection
			var has_reconnected = current_server_uuid != undefined && server_uuid != current_server_uuid;
		
			var in_lobby = buffer_read(buffer, buffer_u8);
			if (!in_lobby) {
				events[net_evt.lobby_data](false, has_reconnected, false);
				exit;
			}
			
	        lobby_id = buffer_read(buffer, buffer_u32);
	        admin_id = buffer_read(buffer, buffer_u8);
	        player_id = buffer_read(buffer, buffer_u8);			
			var current_players_count = buffer_read(buffer, buffer_u8);
			
			players_count = current_players_count + 1;			
			for (var i=0; i<current_players_count; i++) {
				var listPlayerId = buffer_read(buffer, buffer_u8);
				var listPlayerName = buffer_read(buffer, buffer_string);				
				var player = {
					id: listPlayerId,
					name: listPlayerName
				};
				array_push(players, player);
				players_map[$ player.id] = player;
					
	            if (player_id == player.id) {
	                player_name = player.name;
				}
	        }
				
			events[net_evt.lobby_data](false, has_reconnected, true);
	        break;
				
		case net_cmd.lobby_list:
			lobbies = [];
			var endOffset = buffer_size - NET_HEADER_SIZE;
             
			while (buffer_tell(buffer) < endOffset) {
				var listLobbyId = buffer_read(buffer, buffer_u32);
				var listLobbyName = buffer_read(buffer, buffer_string);
				var listPlayersCount = buffer_read(buffer, buffer_u8);
				var listMaxPlayers = buffer_read(buffer, buffer_u8);
				var listHasPassword = buffer_read(buffer, buffer_u8);
				array_push(lobbies, {
					id: listLobbyId,
					name: listLobbyName,
					players: listPlayersCount,
					max_players: listMaxPlayers,
					has_password: listHasPassword
				});
			}
				
			events[net_evt.lobby_get_list](true, lobbies);
			break;
				
		case net_cmd.lobby_create:
			error_id = buffer_read(buffer, buffer_u8);
			if (error_id) {
				events[net_evt.lobby_create](false);
				exit;
			}
				
	        lobby_id = buffer_read(buffer, buffer_u32);
	        player_id = 0;
			player_name = buffer_read(buffer, buffer_string);
	        admin_id = 0;
			players_count = 1;
            
	        var player = {
				id: 0,
				name: player_name
			};
			array_push(players, player);
			players_map[$ 0] = player;
				
			events[net_evt.lobby_create](true, lobby_id);
	        break;
				
		case net_cmd.lobby_join:
			error_id = buffer_read(buffer, buffer_u8);
			if (error_id) {
				events[net_evt.lobby_join](false);
				exit;
			}
			
	        lobby_id = buffer_read(buffer, buffer_u32);
	        admin_id = buffer_read(buffer, buffer_u8);
	        player_id = buffer_read(buffer, buffer_u8);
			var players_count = buffer_read(buffer, buffer_u8);
				
	        for (var i=0; i<players_count; i++) {
				var listPlayerId = buffer_read(buffer, buffer_u8);
				var listPlayerName = buffer_read(buffer, buffer_string);				
				var player = {
					id: listPlayerId,
					name: listPlayerName
				};
				array_push(players, player);
				players_map[$ player.id] = player;
					
	            if (player_id == player.id) {
	                player_name = player.name;
				}
	        }
				
			events[net_evt.lobby_join](true);
	        break;
				
		case net_cmd.lobby_player_joined:
			var listPlayerId = buffer_read(buffer, buffer_u8);
			var listPlayerName = buffer_read(buffer, buffer_string);
			var player = {
				id: listPlayerId,
				name: listPlayerName
			};
	        array_push(players, player);
			players_map[$ player.id] = player;
			events[net_evt.player_join](true, player);
	        break;
				
		case net_cmd.lobby_leave:
	        lobby_id = undefined;
	        player_id = undefined;
	        admin_id = undefined;
	        player_name = undefined;
			players = [];
			players_map = {};
	        events[net_evt.lobby_leave](buffer_read(buffer, buffer_u8));
	        break;
				
		case net_cmd.lobby_player_left:
	        var player_left_id = buffer_read(buffer, buffer_u8);
			var current_admin_id = admin_id;
	        admin_id = buffer_read(buffer, buffer_u8);
			
			// Side effect: if the player who left was an admin, trigger the related transfer event
			if (current_admin_id != admin_id) {
				events[net_evt.lobby_transfer](true, admin_id);
			}
	            
			var left_player = __net_remove_player(player_left_id);
			if (left_player != undefined) {
	            events[net_evt.player_leave](true, left_player);
	        }
	        break;
				
		case net_cmd.lobby_transfer:
	        error_id = buffer_read(buffer, buffer_u8);
	        if (error_id) {
				events[net_evt.lobby_transfer](false);
				exit;
			}
			
	        admin_id = buffer_read(buffer, buffer_u8); 
	        events[net_evt.lobby_transfer](true, admin_id);
	        break;
				
		case net_cmd.lobby_transfer_changed:
	        admin_id = buffer_read(buffer, buffer_u8); 
	        events[net_evt.lobby_transfer](true, admin_id);
	        break;
				
		case net_cmd.lobby_allow_join:
			error_id = buffer_read(buffer, buffer_u8);
	        if (error_id) {
				events[net_evt.lobby_allow_join](false);
				exit;
			}
			
	        var allow_join = buffer_read(buffer, buffer_u8);
	        events[net_evt.lobby_allow_join](true, allow_join);
	        break;
				
			case net_cmd.lobby_allow_join_changed:
			var allow_join = buffer_read(buffer, buffer_u8);
	        events[net_evt.lobby_allow_join](true, allow_join);
	        break;
				
		case net_cmd.lobby_max_players:
	        error_id = buffer_read(buffer, buffer_u8);
	        if (error_id) {
				events[net_evt.lobby_max_players](false);
				exit;
			}
			
			var max_players = buffer_read(buffer, buffer_u8);
	        events[net_evt.lobby_max_players](true, max_players);
	        break;
            
	    case net_cmd.lobby_max_players_changed:
			var max_players = buffer_read(buffer, buffer_u8)
	        events[net_evt.lobby_max_players](true, max_players);
	        break;
				
		case net_cmd.lobby_password:
	        error_id = buffer_read(buffer, buffer_u8);
	        if (error_id) {
				events[net_evt.lobby_password](false);
				exit;
			}
	        events[net_evt.lobby_password](true);
	        break;
				
		// Current player changes its username
		case net_cmd.lobby_username: 
			var player = {
				id: player_id,
				name: player_name
			};
		
			error_id = buffer_read(buffer, buffer_u8);
	        if (error_id) {
				events[net_evt.player_username](false, player);
				exit;
			}
			
			player.name = buffer_read(buffer, buffer_string);
			player_name = player.name;
		
	        var player_in_map = players_map[$ player_id];
			if (player_in_map != undefined) {
				player_in_map.name = player_name;
			}
				
	        events[net_evt.player_username](true, player);
	        break;
			
		// Another player changed its username
		case net_cmd.lobby_player_username:
			var listPlayerId = buffer_read(buffer, buffer_u8);
			var listPlayerName = buffer_read(buffer, buffer_string);
			var event_player = {
				id: listPlayerId,
				name: listPlayerName
			};
			
			var player_in_map = players_map[$ event_player.id];
			if (player_in_map != undefined) {
				player_in_map.name = event_player.name;
			}
	                    
	        events[net_evt.player_username](true, player);
	        break;
			
		case net_cmd.lobby_kick:
			error_id = buffer_read(buffer, buffer_u8); 
	        if (error_id) {
				events[net_evt.player_kickban](false, undefined, 0);
				exit;
			}
			
	        var kicked_player_id = buffer_read(buffer, buffer_u8); 
	        var kickOrBan = buffer_read(buffer, buffer_u8);
            
			var kicked_player = __net_remove_player(kicked_player_id);
			if (kicked_player != undefined) {
	            events[net_evt.player_kickban](true, kicked_player, kickOrBan);
	        }
	        break;
			
		case net_cmd.lobby_player_kicked:
	        var kicked_player_id = buffer_read(buffer, buffer_u8); 
	        var kickOrBan = buffer_read(buffer, buffer_u8);
			var kicked_player = players_map[$ kicked_player_id];
			if (kicked_player == undefined) exit;
            
	        // I was kicked
	        if (kicked_player_id == player_id) {
	            lobby_id = undefined;
	            player_id = undefined;
	            admin_id = undefined;
	            player_name = undefined;
				players = [];
				players_map = {};
	        } else {
		        // Another player has been kicked
				__net_remove_player(kicked_player_id);
			}
			
			events[net_evt.player_kickban](true, kicked_player, kickOrBan);
			break;
			
		case net_cmd.lobby_unban:
	        error_id = buffer_read(buffer, buffer_u8);
	        if (error_id) {
				events[net_evt.lobby_unban](false, undefined);
				exit;
			}
			
			var unbanned_player_ip_hash = buffer_read(buffer, buffer_string);
			events[net_evt.lobby_unban](true, unbanned_player_ip_hash);
	        break;
			
		case net_cmd.lobby_bans:
	        error_id = buffer_read(buffer, buffer_u8);
		    if (error_id) {
				events[net_evt.lobby_get_banned](false, undefined);
				exit;
			}
            
	        var count = buffer_read(buffer, buffer_u16);
	        var arr = array_create(count);
	        for(var i=0; i<count; i++) {
				var listIpHash = buffer_read(buffer, buffer_string);
				var listPlayerName = buffer_read(buffer, buffer_string);
	            arr[i] = {
					ip_hash: listIpHash,
					name: listPlayerName
				};
	        }
			
			events[net_evt.lobby_get_banned](true, arr);
	        break;
	}
}