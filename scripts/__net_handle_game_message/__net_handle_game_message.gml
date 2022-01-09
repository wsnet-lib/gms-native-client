/**
 * Handle the incoming game message
 *
 * @param {Buffer} buffer Data buffer
 * @param {Integer} buffer_size Data buffer size
 */
function __net_handle_game_message(buffer, buffer_size) {
	var sender_id = buffer_read(buffer, buffer_u8);
	var msg_id = buffer_read(buffer, buffer_u16);
	var type = buffer_read(buffer, buffer_u8);
	var callback = game_message_callbacks[$ msg_id];
	
	if (callback == undefined) {
		if (debug_mode) show_error("Error: unregistered callback for msg_id = " + string(msg_id), true);
		return;
	}
	
	switch (type) {
		case net_type.raw:
			callback(sender_id, buffer, buffer_size);
		break;
			
		case net_type.byte:
			callback(sender_id, buffer_read(buffer, buffer_u8));
	  break;
			
		case net_type.byte_array:
	    var len = buffer_read(buffer, buffer_u16);
	    var arr = array_create(len);
	    for (var i=0; i<len; i++) {
				arr[i] = buffer_read(buffer, buffer_u8);
			}
			callback(sender_id, arr);
	  break;
			
		case net_type.number:
			callback(sender_id, buffer_read(buffer, buffer_f32));
	  break;
        
	  case net_type.number_array:
		  var len = buffer_read(buffer, buffer_u16);
		  var arr = array_create(len); 
		  for (var i=0; i<len; i++) {
		    arr[i] = buffer_read(buffer, buffer_f32); 
			}
	    callback(sender_id, arr);
	  break;

	  case net_type.text:
			callback(sender_id, buffer_read(buffer, buffer_string));
	  break;
        
	  case net_type.text_array:
		  var len = buffer_read(buffer, buffer_u16);
	    var arr = array_create(len);
			for (var i=0; i<len; i++) {
	      arr[i] = buffer_read(buffer, buffer_string); 
			}
	    callback(sender_id, arr);
	  break;

	  case net_type.array:
	    var len = buffer_read(buffer, buffer_u16);
	    var arr = array_create(len);
			
	    for (var i=0; i<len; i++) {
	      switch (buffer_read(buffer, buffer_u8)) {
					case net_type.byte:
						arr[i] =  buffer_read(buffer, buffer_u8);
					break;
						
					case net_type.integer32:
						arr[i] = buffer_read(buffer, buffer_u32);
					break;
						
					case net_type.integer64:
						arr[i] = buffer_read(buffer, buffer_u64);
					break;
					
					case net_type.number:
						arr[i] = buffer_read(buffer, buffer_f32);
					break;
						
					case net_type.text:
						arr[i] = buffer_read(buffer, buffer_string);
					break;
						
					case net_type.struct:
						arr[i] = json_parse(buffer_read(buffer, buffer_string));
					break;
				}
			}
			callback(sender_id, arr);
	  break;
        
	  case net_type.list:
	    var len = buffer_read(buffer, buffer_u16);
	    var arr = ds_list_create();
	    for (var i=0; i<len; i++) {
	      switch (buffer_read(buffer, buffer_u8)) {
					case net_type.byte:
						ds_list_add(arr, buffer_read(buffer, buffer_u8));
					break;
						
					case net_type.integer32:
						ds_list_add(arr, buffer_read(buffer, buffer_u32));
					break;
						
					case net_type.integer64:
						ds_list_add(arr, buffer_read(buffer, buffer_u64));
					break;
					
					case net_type.number:
						ds_list_add(arr, buffer_read(buffer, buffer_f32));
					break;
						
					case net_type.text:
						ds_list_add(arr, buffer_read(buffer, buffer_string));
					break;
						
					case net_type.struct:
						ds_list_add(arr, json_parse(buffer_read(buffer, buffer_string)));
					break;
				}
	    }
	    callback(sender_id, arr);
	  break;
        
	  case net_type.map:
	    var len = buffer_read(buffer, buffer_u16);
	    var arr = ds_map_create();
				
	    for (var i=0; i<len; i++) {
	      var key = buffer_read(buffer, buffer_string);
            
				switch (buffer_read(buffer, buffer_u8)) {
					case net_type.byte:
						ds_map_add(arr, key, buffer_read(buffer, buffer_u8));
					break;
						
					case net_type.integer32:
						ds_map_add(arr, key, buffer_read(buffer, buffer_u32));
					break;
						
					case net_type.integer64:
						ds_map_add(arr, key, buffer_read(buffer, buffer_u64));
					break;
					
					case net_type.number:
						ds_map_add(arr, key, buffer_read(buffer, buffer_f32));
					break;
						
					case net_type.text:
						ds_map_add(arr, key,  buffer_read(buffer, buffer_string));
					break;
						
					case net_type.struct:
						ds_map_add(arr, key,  json_parse(buffer_read(buffer, buffer_string)));
					break;
				}
			}
	    callback(sender_id, arr);
	  break;
			
		case net_type.struct:
			callback(sender_id, json_parse(buffer_read(buffer, buffer_string)));
		break;

	  default:
			if (debug_mode) show_error("Error: Incorrect " + string(msg_id), true);
	}
}