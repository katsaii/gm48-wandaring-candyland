/// @desc Test draw.
rf3d_draw_debug(mouse_x, mouse_y);
rf3d_draw_begin(spr_test, 0);
repeat (500) {
rf3d_add_billboard(irandom_range(-100, 100), irandom_range(-100, 100), 0, c_red);
rf3d_add_billboard(irandom_range(-100, 100), irandom_range(-100, 100), 0, c_green);
rf3d_add_billboard(irandom_range(-100, 100), irandom_range(-100, 100), 0, c_blue);
}
rf3d_draw_end();