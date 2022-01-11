if (!firstUpdateReceived) exit;

event_inherited();

// Lerp the enemy position to the actual current position. The lerp is used to reduce lag effects
speed = speedTarget;
direction = lerp_angle(direction, directionTarget, 5); 
image_angle = direction;

// Fix the position if out of sync
if (point_distance(x, y, xTarget, yTarget) > 10) {
	x = lerp(x, xTarget, 1);
	y = lerp(y, yTarget, 1);
}