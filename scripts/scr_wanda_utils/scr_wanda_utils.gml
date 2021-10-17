
function input(_f, _vks_pos, _vks_neg) {
    var dir = 0;
    for (var i = min(array_length(_vks_pos), array_length(_vks_neg)) - 1; i >= 0; i -= 1) {
        dir += _f(_vks_pos[i]) - _f(_vks_neg[i]);
    }
    return clamp(dir, -1, 1);
}