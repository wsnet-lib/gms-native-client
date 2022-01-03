/**
 * Print a pretty log message
 *
 * @param {String} message
 */
function __net_log(message) {
	show_debug_message("[NET] " + date_datetime_string(date_current_datetime()) + " - " + message);
}