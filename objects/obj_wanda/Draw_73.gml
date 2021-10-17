if (respawnTimer != -1) {
    gpu_set_ztestenable(false);
    var cam = view_camera[view_current];
    var width = camera_get_view_width(cam);
    var height = camera_get_view_height(cam);
    var left = camera_get_view_x(cam);
    var top = camera_get_view_y(cam);
    var right = left + width;
    var bottom = top + height;
    var blend = (2 * respawnTimer - 1);
    blend = - blend * blend + 1;
    draw_primitive_begin(pr_trianglestrip);
    draw_vertex_color(left, top, c_black, blend);
    draw_vertex_color(right, top, c_black, blend);
    draw_vertex_color(left, bottom, c_black, blend);
    draw_vertex_color(right, bottom, c_black, blend);
    draw_primitive_end();
    gpu_set_ztestenable(true);
}