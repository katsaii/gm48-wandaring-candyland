
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
    var x1 = _cell_x;
    var y1 = _cell_y;
    var x2 = x1 + CELL_SIZE;
    var y2 = y1 + CELL_SIZE;
    var z_bot = 0;
    var z_top = _height;
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

function instance_create_on_grid(_row, _col, _obj, _offset=undefined) {
    var inst = instance_create_layer(_row * CELL_SIZE, _col * CELL_SIZE, layer, _obj);
    if (_offset != undefined) {
        inst.z = -(_offset + 1) * CELL_SIZE;
        inst.zstart = inst.z;
    }
    return inst;
}

function convert_byte_to_number(_byte) {
    if (_byte >= ord("0") && _byte <= ord("9")) {
        return _byte - ord("0");
    }
    return 0;
}

function load_room_from_file(_path) {
    var grid = load_csv(_path);
    for (var row = ds_grid_width(grid) - 1; row >= 0; row -= 1) {
        for (var col = ds_grid_height(grid) - 1; col >= 0; col -= 1) {
            var line = grid[# row, col];
            if not (is_string(line)) {
                line = string(line);
            }
            switch (string_length(line)) {
            case 0:
                line += "X";
            case 1:
                line += "0";
            case 2:
                line += "X";
            case 3:
                line += "0";
            }
            var p_type = string_byte_at(line, 1);
            var p_offset = convert_byte_to_number(string_byte_at(line, 2));
            var e_type = string_byte_at(line, 3);
            var e_offset = convert_byte_to_number(string_byte_at(line, 4)) + p_offset;
            switch (p_type) {
            case ord("X"):
                break;
            case ord("p"):
                instance_create_on_grid(row, col, obj_platform, p_offset);
                break;
            }
            var e_row = row + 0.5;
            var e_col = col + 0.5;
            switch (e_type) {
            case ord("X"):
                break;
            case ord("w"):
                instance_create_on_grid(e_row, e_col, obj_wanda, e_offset);
                break;
            }
        }
    }
    ds_grid_destroy(grid);
}