if (other.playerId == playerId) exit;
has_been_hit = true;
hit_animation = true;
alarm[0] = 150; // Stop the has_been_hit mode
alarm[4] = 50; // Stop the hit animation
alarm[5] = 5; // Reverse the hit animation
hp = max(0, hp - irandom_range(.5, 2));
with (other) instance_destroy();