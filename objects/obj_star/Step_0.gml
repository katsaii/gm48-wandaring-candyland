/// @desc Follow object.
var trail_distance = 20;
if (follow != noone) {
    var anchor_x = follow.x;
    var anchor_y = follow.y;
    var anchor_z = follow.z;
    var dist = point_distance_3d(anchor_x, anchor_y, anchor_z, x, y, z);
    if (dist > trail_distance) {
        var scale = trail_distance / dist;
        x = anchor_x + scale * (x - anchor_x);
        y = anchor_y + scale * (y - anchor_y);
        z = anchor_z + scale * (z - anchor_z);
    }
}