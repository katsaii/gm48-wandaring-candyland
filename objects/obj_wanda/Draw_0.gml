/// @desc Draw wanda billboard.
rf3d_draw_begin(sprite_index, image_index);
rf3d_add_billboard(x, y, z, c_white, 1, flip);
rf3d_draw_end();
// dithering when occluded
shader_set_effect_dissolve();
rf3d_draw_begin(sprite_index, image_index);
rf3d_add_billboard(x, y, z, c_white, 1, flip, -1000);
rf3d_draw_end();
shader_reset();