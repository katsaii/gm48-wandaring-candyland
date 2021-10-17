/// @desc Test draw.
rf3d_draw_debug(mouse_x, mouse_y);
shader_set_effect_colour_grey();
rf3d_draw_begin(spr_foliage, 3);
rf3d_add_billboard(50, 0, 0, c_red);
rf3d_add_billboard(-50, 0, 0, c_green);
rf3d_add_billboard(0, 50, 0, c_blue);
rf3d_draw_end();
shader_reset();