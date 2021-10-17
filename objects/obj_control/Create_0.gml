/// @desc Initialise controller and load the room.
gpu_set_ztestenable(true);
gpu_set_alphatestenable(true);
gpu_set_cullmode(cull_counterclockwise);
angle = 0;
pitch = 45;
posX = 0;
posY = 0;
posZ = 0;
depth = 10000; // draw the background first uwu
// load room
load_room_from_file("level.csv");
var snd = audio_play_sound(bgm_music, 100, true);
audio_sound_gain(snd, 0, 0);
audio_sound_gain(snd, 0.125, game_get_speed(gamespeed_microseconds) * 2 / 10);