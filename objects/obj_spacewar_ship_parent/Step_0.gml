// Play the move sound when moving around
if (speed && play_move_sound == undefined) {
	play_move_sound = audio_play_sound(snd_spacewar_player_move, 0, true);
	audio_sound_gain(play_move_sound, 1, 0)
} else if (!speed && play_move_sound != undefined) {	
	audio_sound_gain(play_move_sound, 0, 300)
	play_move_sound = undefined;
}

	