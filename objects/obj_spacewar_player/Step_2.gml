// Room limit collision
if (x < sprite_xoffset) x = sprite_xoffset;
if (x > room_width - sprite_xoffset) x = room_width - sprite_xoffset;
if (y < sprite_yoffset) y = sprite_yoffset;
if (y > room_height - sprite_yoffset) y = room_height - sprite_yoffset;