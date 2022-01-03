/**
 * Append a mixed value to a buffer
 * 
 * @param {Buffer} buffer
 * @param {Any} value
 */
function __net_buffer_append_mixed_value(buffer, value) {
	if (is_int32(value)) {
	    buffer_write(buffer, buffer_u8, net_type.integer32);
	    buffer_write(buffer, buffer_u32, value);
	}
	else if (is_int64(value)) {
	    buffer_write(buffer, buffer_u8, net_type.integer64);
	    buffer_write(buffer, buffer_u64, value);
	}
	else if (is_real(value)) {
	    buffer_write(buffer, buffer_u8, net_type.number);
	    buffer_write(buffer, buffer_f32, value);
	}
	else if (is_string(value)) {
	    buffer_write(buffer, buffer_u8, net_type.text); 
	    buffer_write(buffer, buffer_string, value);        
	}
	else if (is_bool(value)) {
	    buffer_write(buffer, buffer_u8, net_type.byte);
	    buffer_write(buffer, buffer_u8, value);
	}
	else if (is_struct(value)) {
	    buffer_write(buffer, buffer_u8, net_type.struct);
	    buffer_write(buffer, buffer_string, json_stringify(value));
	}
	else {
		show_error("Trying to send a value with an unsupported type. Supported types: int32, int64, real, string, bool, struct", true);
	}
}