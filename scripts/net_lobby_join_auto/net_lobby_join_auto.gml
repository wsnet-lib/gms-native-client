/**
 * Automatically join into the first available public lobby. The search may also be sorted by date or players count
 *
 * @note The event will be also broadcasted to the other lobby players
 * @note This message is sent as reliable.
 *
 * @param {String} [username] Player username
 * @param {Real<net_sort>} [date_sort] Optional date sorting
 * @param {Real<net_sort>} [players_count_sort] Optional players count sorting
 */
function net_lobby_join_auto(username = "", date_sort = net_sort.no_sort, players_count_sort = net_sort.no_sort) {
	var buf = buffer_create(4 + string_byte_length(username)	+ NET_HEADER_SIZE, buffer_fixed, 1);
	buffer_write(buf, buffer_u8, net_cmd.lobby_join_auto);
	buffer_write(buf, buffer_u8, date_sort); 
	buffer_write(buf, buffer_u8, players_count_sort); 
	buffer_write(buf, buffer_string, username);
		
	__net_send(buf, 1);
}