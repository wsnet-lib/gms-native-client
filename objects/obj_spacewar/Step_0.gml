// View follow animation
if (instance_exists(obj_spacewar_player)) {
	var cameraX = camera_get_view_x(view_camera);
	var cameraY = camera_get_view_y(view_camera);
	var cameraW = camera_get_view_width(view_camera);
	var cameraH = camera_get_view_height(view_camera);
	
	var viewTargetX = clamp(obj_spacewar_player.x - cameraW/2, 0, room_width-cameraW);
	var viewTargetY = clamp(obj_spacewar_player.y - cameraH/2, 0, room_height-cameraH);
	
	camera_set_view_pos(view_camera, lerp(cameraX, viewTargetX, .1), lerp(cameraY, viewTargetY, .1));
}