/* Real Fake 3D
 */

/// @desc Sets the origin of the fake 3D world.
/// @desc {real} x The X origin.
/// @desc {real} y The Y origin.
/// @desc {real} z The Z origin.
function rf3d_set_origin(_x, _y, _z) {
    var rf3d = __rf3d_get_data();
    var v_p = rf3d.vOff;
    v_p[@ 0] = _x;
    v_p[@ 1] = _y;
    v_p[@ 2] = _z;
}

/// @desc Sets the orientation of the fake 3D world.
/// @desc {real} angle The angle of rotation around the Z-axis.
/// @desc {real} pitch The angle of rotation around the X-axis.
function rf3d_set_orientation(_angle, _pitch) {
    var rf3d = __rf3d_get_data();
    var v_x = rf3d.vX;
    var v_y = rf3d.vY;
    var v_z = rf3d.vZ;
    v_x[@ 0] = dcos(_angle);
    var v_x_pitch_radius = dsin(_angle);
    v_x[@ 1] = v_x_pitch_radius * -dcos(_pitch);
    v_x[@ 2] = v_x_pitch_radius * dsin(_pitch);
    v_y[@ 0] = dcos(_angle - 90);
    var v_y_pitch_radius = dsin(_angle - 90);
    v_y[@ 1] = v_y_pitch_radius * -dcos(_pitch);
    v_y[@ 2] = v_y_pitch_radius * dsin(_pitch);
    v_z[@ 0] = 0;
    v_z[@ 1] = dsin(_pitch);
    v_z[@ 2] = dcos(_pitch);
}

/// @desc Draws a debug view of the basis vectors. (Red = X, Green = Y, Blue = Z)
/// @desc {real} x The X position to draw the basis vectors relative to.
/// @desc {real} y The Y position to draw the basis vectors relative to.
/// @desc {real} r The length of the basis vectors.
function rf3d_draw_debug(_x, _y, _r=20) {
    var rf3d = __rf3d_get_data();
    var v_x = rf3d.vX;
    var v_y = rf3d.vY;
    var v_z = rf3d.vZ;
    draw_line_colour(_x, _y, _x + _r * v_z[0], _y + _r * v_z[1], c_blue, c_blue);
    draw_line_colour(_x, _y, _x + _r * v_y[0], _y + _r * v_y[1], c_green, c_green);
    draw_line_colour(_x, _y, _x + _r * v_x[0], _y + _r * v_x[1], c_red, c_red);
}

/// @desc Draws a sprite that always faces the screen.
/// @desc {real} sprite The sprite to draw.
/// @desc {real} image The subimage of the sprite to draw.
/// @desc {real} x The X position to draw the billboard sprite at.
/// @desc {real} y The Y position to draw the billboard sprite at.
/// @desc {real} z The Y position to draw the billboard sprite at.
/// @desc {real} [blend] The colour of the billboard sprite.
/// @desc {real} [alpha] The transparency of the billboard sprite.
function rf3d_draw_billboard(_spr, _img, _x, _y, _z, _col=c_white, _alp=1) {
    var rf3d = __rf3d_get_data();
    var tex = __rf3d_get_texture_data(_spr, _img);
    var v_pos = rf3d.vOff;
    var v_x = rf3d.vX;
    var v_y = rf3d.vY;
    var v_z = rf3d.vZ;
    _x -= v_pos[0];
    _y -= v_pos[1];
    _z -= v_pos[2];
    var screen_x = floor(_x * v_x[0] + _y * v_y[0] + _z * v_z[0]);
    var screen_y = floor(_x * v_x[1] + _y * v_y[1] + _z * v_z[1]);
    var screen_depth = _x * v_x[2] + _y * v_y[2] + _z * v_z[2];
    var screen_depth_top = screen_depth + tex.height * v_z[2];
    var x1 = screen_x - tex.offX;
    var y1 = screen_y - tex.offY;
    var x2 = x1 + tex.width;
    var y2 = y1 + tex.height;
    var vbuff = vertex_create_buffer();
    vertex_begin(vbuff, __rf3d_get_full_fat_vertex_format());
    vertex_position_3d(vbuff, x1, y1, screen_depth_top);
    vertex_colour(vbuff, _col, _alp);
    vertex_texcoord(vbuff, tex.uvLeft, tex.uvTop);
    vertex_position_3d(vbuff, x1, y2, screen_depth);
    vertex_colour(vbuff, _col, _alp);
    vertex_texcoord(vbuff, tex.uvLeft, tex.uvBottom);
    vertex_position_3d(vbuff, x2, y1, screen_depth_top);
    vertex_colour(vbuff, _col, _alp);
    vertex_texcoord(vbuff, tex.uvRight, tex.uvTop);
    vertex_position_3d(vbuff, x2, y1, screen_depth_top);
    vertex_colour(vbuff, _col, _alp);
    vertex_texcoord(vbuff, tex.uvRight, tex.uvTop);
    vertex_position_3d(vbuff, x1, y2, screen_depth);
    vertex_colour(vbuff, _col, _alp);
    vertex_texcoord(vbuff, tex.uvLeft, tex.uvBottom);
    vertex_position_3d(vbuff, x2, y2, screen_depth);
    vertex_colour(vbuff, _col, _alp);
    vertex_texcoord(vbuff, tex.uvRight, tex.uvBottom);
    vertex_end(vbuff);
    vertex_submit(vbuff, pr_trianglelist, tex.page);
    vertex_delete_buffer(vbuff);
}

/// @desc Returns a reference to the fake 3D controller.
function __rf3d_get_data() {
    static rf3d = {
        vOff : [0, 0, 0],
        vX : [1, 0, 0],
        vY : [0, 1, 0],
        vZ : [0, 0, 1],
    };
    return rf3d;
}

/// @desc Packages the sprite information into a single structure.
/// @param {real} sprite The id of the sprite to package.
/// @param {real} subimg The id of the subimage to use.
function __rf3d_get_texture_data(_sprite, _subimg) {
    var idx_spr = sprite_exists(_sprite) &&
            _subimg >= 0 &&
            _subimg < sprite_get_number(_sprite) ? _sprite : -1;
    var sprite_data = {
        idx : idx_spr,
        img : _subimg,
        offX : 0,
        offY : 0,
        width : 0,
        height : 0,
        page : -1,
        uvLeft : 0,
        uvTop : 0,
        uvRight : 1,
        uvBottom : 1,
    };
    if (idx_spr != -1) {
        var width = sprite_get_width(_sprite);
        var height = sprite_get_height(_sprite);
        var uvs = sprite_get_uvs(_sprite, _subimg);
        var uv_left = uvs[0];
        var uv_top = uvs[1];
        var uv_right = uvs[2];
        var uv_bottom = uvs[3];
        var uv_x_offset = uvs[4]; // number of pixels trimmed from the left
        var uv_y_offset = uvs[5]; // number of pixels trimmed from the top
        var uv_x_ratio = uvs[6]; // ratio of discarded pixels horizontally
        var uv_y_ratio = uvs[7]; // ratio of discarded pixels vertically
        var uv_width = (uv_right - uv_left) / uv_x_ratio;
        var uv_height = (uv_bottom - uv_top) / uv_y_ratio;
        var uv_kw = uv_width / width;
        var uv_kh = uv_height / height;
        sprite_data.offX = sprite_get_xoffset(_sprite) - uv_x_offset;
        sprite_data.offY = sprite_get_yoffset(_sprite) - uv_y_offset;
        sprite_data.width = width * uv_x_ratio;
        sprite_data.height = height * uv_y_ratio;
        sprite_data.page = sprite_get_info(_sprite).frames[_subimg].texture;
        sprite_data.uvLeft = uv_left - uv_x_offset * uv_kw;
        sprite_data.uvTop = uv_top - uv_y_offset * uv_kh;
        sprite_data.uvRight = sprite_data.uvLeft + uv_width;
        sprite_data.uvBottom = sprite_data.uvTop + uv_height;
    }
    return sprite_data;
}

/// @desc Returns the preferred vertex format.
function __rf3d_get_full_fat_vertex_format() {
    static init = true;
    static format = undefined;
    if (init) {
        init = false;
        vertex_format_begin();
        vertex_format_add_position_3d();
        vertex_format_add_colour();
        vertex_format_add_texcoord();
        format = vertex_format_end();
    }
    return format;
}