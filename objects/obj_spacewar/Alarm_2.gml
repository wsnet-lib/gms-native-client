for (var i=0; i<array_length(played_audio_shots); i++) {
	var snd = played_audio_shots[i];
	if (!audio_is_playing(snd)) array_delete(played_audio_shots, i, 1);
}

alarm[2] = round(room_speed * audio_sound_length(snd_spacewar_player_shot));