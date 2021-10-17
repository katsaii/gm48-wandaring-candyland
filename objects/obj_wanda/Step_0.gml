/// @desc Update position and angle.
var dir_x = input_direction(keyboard_check, [vk_right, ord("D")], [vk_left, ord("A")]);
var dir_y = input_direction(keyboard_check, [vk_down, ord("S")], [vk_up, ord("W")]);
targetAngle += 45 * input_direction(keyboard_check_pressed, [ord("Q")], [ord("E")]);
x += dir_y * -dsin(obj_control.angle) + dir_x * dcos(obj_control.angle);
y += dir_y * dcos(obj_control.angle) + dir_x * dsin(obj_control.angle);
obj_control.posX = x;
obj_control.posY = y;
var diff = -angle_difference(obj_control.angle, targetAngle);
obj_control.angle += diff * 0.1;
// jump
if (allowJump) {
    if (jumpTimer == -1 && input(keyboard_check, [vk_space, ord("X"), vk_enter])) {
        allowJump = false;
        jumpTimer = 0;
        jumpParity = !jumpParity;
    }
} else if (input(keyboard_check_released, [vk_space, ord("X"), vk_enter])) {
    allowJump = true;
}
// update sprite
var moving = x != xprevious || y != yprevious;
if (moving) {
    movementAngle = point_direction(xprevious, yprevious, x, y);
}
var facing = floor((angle_difference(-obj_control.angle, movementAngle) + 360 + 45) % 360 / 90) % 4;
var sprites = subimages[facing];
flip = sprites.flip;
if (jumpTimer != -1) {
    jumpTimer += 0.03;
    image_index = sprites.jump[jumpParity ? 0 : 1];
    var height = 30;
    z = -height * (1 - (2 * jumpTimer - 1) * (2 * jumpTimer - 1));
    if (z > 0) {
        // death
        jumpTimer = -1;
        z = 0;
    }
    obj_control.posZ = z;
} else if (moving) {
    var frame_idx = (current_time * 0.005) % 4;
    image_index = sprites.walk[frame_idx];
} else {
    image_index = sprites.idle;
}