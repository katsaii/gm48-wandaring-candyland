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
// draw shadow
if (platformZ != infinity) {
    rf3d_draw_begin(spr_shadow, 0);
    var z_ = platformZ - 1;
    var r = 3;
    rf3d_add_sprite_pos(
            x - r, y - r, z_,
            x + r, y - r, z_,
            x + r, y + r, z_,
            x - r, y + r, z_);
    rf3d_draw_end();
}