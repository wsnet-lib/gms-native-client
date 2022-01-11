 // Fire animation
if (!create_shots) exit;

var count = irandom_range(1, 3);
for (var i=0; i<count; i++) {
	var shot = instance_create_layer(shotX + irandom_range(-5, 5), shotY + irandom_range(-5, 5), "Instances", obj_spacewar_shot);
	with (shot) {
		playerId = other.playerId;
		image_index = other.image_index;
		motion_set(point_direction(other.shotX, other.shotY, other.shotTargetX, other.shotTargetY), irandom_range(7, 10));	
		image_angle = direction;
	}
}

alarm[1] = irandom_range(3, 5);