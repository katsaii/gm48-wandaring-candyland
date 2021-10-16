/// @desc Enable views.
view_enabled = true;
view_set_visible(VIEW_ID, true);
camera_set_view_size(VIEW_CAM, VIEW_DEFAULT_WIDTH, VIEW_DEFAULT_HEIGHT);
camera_set_view_pos(VIEW_CAM, -floor(VIEW_DEFAULT_WIDTH / 2), -floor(VIEW_DEFAULT_HEIGHT / 2));