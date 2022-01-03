/**
 * Register a callback for an incoming game message
 *
 * @param {Integer} msgId Message ID
 * @param {Function} callback
 */
function net_on(msgId, callback) {
	obj_net_manager.game_message_callbacks[$ msgId] = callback;
}