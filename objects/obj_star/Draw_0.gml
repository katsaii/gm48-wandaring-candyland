/// @desc Draw billboard.
var t = current_time * 0.1 + 5 * waveOffset;
var pos_x = x + 2.0 * dsin(t);
var pos_y = y + 3.0 * dsin(t + 90);
var pos_z = z + 2.0 * dsin(t + 45);
rf3d_draw_begin(sprite_index, image_index);
rf3d_add_billboard(pos_x, pos_y, pos_z);
rf3d_draw_end();
// dithering when occluded
shader_set_effect_dissolve();
rf3d_draw_begin(sprite_index, image_index);
rf3d_add_billboard(pos_x, pos_y, pos_z, c_white, 1, false, -1000);
rf3d_draw_end();
shader_reset();