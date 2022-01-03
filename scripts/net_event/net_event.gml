/**
 * Register a callback for an incoming event
 *
 * @param {Integer} eventId Event ID
 * @param {Function} callback
 */
function net_event(eventId, callback) {
	obj_net_manager.events[eventId] = callback;
}