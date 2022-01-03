/**
 * Debug a buffer by returning a list of u8 values. The buffer initial seek position is preserved.
 *
 * @param {Buffer} buffer
 *
 * @return {String} Decoded buffer
 */
function __net_decode_buffer(buffer) {
	var seek = buffer_tell(buffer);
	buffer_seek(buffer, buffer_seek_start, 0);
	
	var size = buffer_get_size(buffer);	
	var output = "";
	for (var i=0; i<size; i++) {
		output += string(buffer_read(buffer, buffer_u8));
		if (i<size-1) output += ", "
	}	
	
	buffer_seek(buffer, buffer_seek_start, seek);
	return output;
}