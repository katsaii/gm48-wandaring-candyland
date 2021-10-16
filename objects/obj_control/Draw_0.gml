/// @desc Test draw.
rf3d_draw_debug(mouse_x, mouse_y);
rf3d_draw_begin(spr_test, 0);
rf3d_add_billboard(10, 0, 0, c_red);
rf3d_add_billboard(-10, 0, 0, c_green);
rf3d_add_billboard(0, 10, 0, c_blue);
rf3d_draw_end();