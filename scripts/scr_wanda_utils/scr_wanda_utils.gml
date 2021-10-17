
function input_direction(_f, _vks_pos, _vks_neg) {
    return input(_f, _vks_pos) - input(_f, _vks_neg);
}

function input(_f, _vks) {
    for (var i = array_length(_vks) - 1; i >= 0; i -= 1) {
        if (_f(_vks[i])) {
            return true;
        }
    }
    return false;
}

#macro CELL_SIZE (16)
#macro CELL_LEFT (1)
#macro CELL_BOTTOM (2)
#macro CELL_RIGHT (4)
#macro CELL_TOP (8)
#macro CELL_ALL (CELL_LEFT | CELL_BOTTOM | CELL_RIGHT | CELL_TOP)
#macro CELL_NONE (0)

function draw_island(_cell_x, _cell_y, _height, _occlude) {
    var col = c_yellow;
    var col_cliff = c_red;
    var x1 = _cell_x * CELL_SIZE;
    var y1 = _cell_y * CELL_SIZE;
    var x2 = x1 + CELL_SIZE;
    var y2 = y1 + CELL_SIZE;
    var z_bot = 0;
    var z_top = -_height * CELL_SIZE;
    rf3d_draw_begin(spr_grass, 0);
    rf3d_add_sprite_pos(
            x1, y1, z_top,
            x2, y1, z_top,
            x2, y2, z_top,
            x1, y2, z_top, col);
    rf3d_draw_end();
    rf3d_draw_begin(spr_grass, 1);
    if not (_occlude & CELL_LEFT) {
        rf3d_add_sprite_pos(
                x1, y1, z_top,
                x1, y2, z_top,
                x1, y2, z_bot,
                x1, y1, z_bot, col_cliff);
    }
    if not (_occlude & CELL_BOTTOM) {
        rf3d_add_sprite_pos(
                x1, y2, z_top,
                x2, y2, z_top,
                x2, y2, z_bot,
                x1, y2, z_bot, col_cliff);
    }
    if not (_occlude & CELL_RIGHT) {
        rf3d_add_sprite_pos(
                x2, y2, z_top,
                x2, y1, z_top,
                x2, y1, z_bot,
                x2, y2, z_bot, col_cliff);
    }
    if not (_occlude & CELL_TOP) {
        rf3d_add_sprite_pos(
                x2, y1, z_top,
                x1, y1, z_top,
                x1, y1, z_bot,
                x2, y1, z_bot, col_cliff);
    }
    rf3d_draw_end();
}