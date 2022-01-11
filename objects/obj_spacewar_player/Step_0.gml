event_inherited();

// Acceleration
var spd = .1;
if (keyboard_check(ord("W"))) motion_add(direction, spd);
speed = min(speed, 2);

// Rotation
if (keyboard_check(ord("A"))) direction += 3;
if (keyboard_check(ord("D"))) direction -= 3;
image_angle = direction;

// Optimize the net packets by only sending when a position transform is detected
if (x != prevX || prevY != y || prevSpeed != speed || prevDirection != direction) {
	transformChanged = true;	
}
prevX = x;
prevY = y;
prevSpeed = speed;
prevDirection = direction;
