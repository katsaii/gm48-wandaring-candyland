/* Real Fake 3D
 */

/// @desc Returns a reference to the fake 3D controller.
function __rf3d_data() {
    static rf3d = {
        vOff : [0, 0, 0],
        vX : [1, 0, 0],
        vY : [0, 1, 0],
        vZ : [0, 0, 1],
    };
    return rf3d;
}

/// @desc Sets the origin of the fake 3D world.
/// @desc {real} x The X origin.
/// @desc {real} y The Y origin.
/// @desc {real} z The Z origin.
function rf3d_set_origin(_x, _y, _z) {
    var rf3d = __rf3d_data();
    var v_p = rf3d.vPos;
    v_p[@ 0] = _x;
    v_p[@ 1] = _y;
    v_p[@ 2] = _z;
}

/// @desc Sets the orientation of the fake 3D world.
/// @desc {real} angle The angle of rotation around the Z-axis.
/// @desc {real} pitch The angle of rotation around the X-axis.
function rf3d_set_orientation(_angle, _pitch) {
    var rf3d = __rf3d_data();
    var v_x = rf3d.vX;
    var v_y = rf3d.vY;
    var v_z = rf3d.vZ;
    // rotate about the Z-axis
    v_x[@ 0] = lengthdir_x(1, _angle);
    v_x[@ 1] = lengthdir_y(1, _angle);
    v_x[@ 2] = 0;
    v_y[@ 0] = lengthdir_x(1, _angle + 90);
    v_y[@ 1] = lengthdir_y(1, _angle + 90);
    v_y[@ 2] = 0;
}

/// @desc Draws a debug view of the basis vectors. (Red = X, Green = Y, Blue = Z)
/// @desc {real} x The X position to draw the basis vectors relative to.
/// @desc {real} y The Y position to draw the basis vectors relative to.
/// @desc {real} r The length of the basis vectors.
function rf3d_debug_draw(_x, _y, _r=20) {
    var rf3d = __rf3d_data();
    var v_x = rf3d.vX;
    var v_y = rf3d.vY;
    var v_z = rf3d.vZ;
    draw_line_colour(_x, _y, _x + _r * v_x[0], _y + _r * v_x[1], c_red, c_red);
    draw_line_colour(_x, _y, _x + _r * v_y[0], _y + _r * v_y[1], c_green, c_green);
    draw_line_colour(_x, _y, _x + _r * v_z[0], _y + _r * v_z[1], c_blue, c_blue);
}