/// @desc Draw billboard.
shader_set_effect_colour_grey();
rf3d_draw_begin(sprite_index, image_index);
rf3d_add_billboard(x, y, z, image_blend);
rf3d_draw_end();
shader_reset();