// Play the move sound when moving around
if (speed && play_move_sound == undefined) {
	play_move_sound = audio_play_sound(snd_spacewar_player_move, 0, true);
	audio_sound_gain(play_move_sound, 1, 0)
} else if (!speed && play_move_sound != undefined) {	
	audio_sound_gain(play_move_sound, 0, 300)
	play_move_sound = undefined;
}

// Hit animation
if (hit_animation) {
	image_alpha = hit_animation_direction ? .5 : 1;
}

if (hp <= 0 && !audio_is_playing(snd_spacewar_player_explosion)) {
	audio_play_sound(snd_spacewar_player_explosion, 1, false);
	instance_destroy();
	effect_create_above(ef_explosion, x, y, 0, c_red);
	
	if (playerId == global.net_player_id) {
		game_restart();
	}
}