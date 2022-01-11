/**
 * Create the shot animation
 */
function scr_spacewar_create_shot() {
	create_shots = true;
	alarm[1] = 1; // Fire animation
	alarm[2] = 10; // End fire animation
	
	// Play the shot sound (up to the limit)
	if (array_length(obj_spacewar.played_audio_shots) < 3) {
		var snd = audio_play_sound(snd_spacewar_player_shot, 0, false);
		array_push(obj_spacewar.played_audio_shots, snd);
	}
}