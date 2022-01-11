event_inherited();
image_speed = 0;
friction = .05;
x = irandom_range(100, room_width-100);
y = irandom_range(100, room_height-100);
direction = irandom(360);
hp = 100;

can_shot = true;
transformChanged = true;
prevX = x;
prevY = y;
prevSpeed = speed;
prevDirection = direction;
