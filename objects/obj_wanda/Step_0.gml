/// @desc Update position and angle.
var dir_x = input(keyboard_check, [vk_right, ord("D")], [vk_left, ord("A")]);
var dir_y = input(keyboard_check, [vk_down, ord("S")], [vk_up, ord("W")]);
targetAngle += 45 * input(keyboard_check_pressed, [ord("Q")], [ord("E")]);
x += dir_y * -dsin(obj_control.angle) + dir_x * dcos(obj_control.angle);
y += dir_y * dcos(obj_control.angle) + dir_x * dsin(obj_control.angle);
obj_control.posX = x;
obj_control.posY = y;
var diff = -angle_difference(obj_control.angle, targetAngle);
obj_control.angle += diff * 0.1;
// update sprite
if (x != xprevious || y != yprevious) {
    movementAngle = point_direction(xprevious, yprevious, x, y);
}
var facing = floor((angle_difference(-obj_control.angle, movementAngle) + 360 + 45) % 360 / 90) % 4;
var sprites = subimages[facing];
image_index = sprites.idle;
flip = sprites.flip;