event_inherited();

// Acceleration
var spd = .1;
if (keyboard_check(ord("W"))) motion_add(direction, spd);
speed = min(speed, 2);

// Rotation
if (keyboard_check(ord("A"))) direction += 3;
if (keyboard_check(ord("D"))) direction -= 3;
image_angle = direction;