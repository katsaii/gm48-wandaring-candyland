
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