/// @desc Update position and angle.
if (respawnTimer != -1) {
    var t = respawnTimer;
    respawnTimer += 0.025;
    if (respawnTimer > 1) {
        respawnTimer = -1;
    } else if (t < 0.5 && respawnTimer >= 0.5) {
        x = lastPlatform.x + CELL_SIZE / 2;
        y = lastPlatform.y + CELL_SIZE / 2;
        z = lastPlatform.z - CELL_SIZE / 4;
        jumpTimer = -1;
        allowJump = true;
    }
}
zprevious = z;
var dir_x = input_direction(keyboard_check, [vk_right, ord("D")], [vk_left, ord("A")]);
var dir_y = input_direction(keyboard_check, [vk_down, ord("S")], [vk_up, ord("W")]);
targetAngle += 45 * input_direction(keyboard_check_pressed, [ord("Q")], [ord("E")]);
x += dir_y * -dsin(obj_control.angle) + dir_x * dcos(obj_control.angle);
y += dir_y * dcos(obj_control.angle) + dir_x * dsin(obj_control.angle);
var diff = -angle_difference(obj_control.angle, targetAngle);
obj_control.angle += diff * 0.1;
// jump
if (allowJump) {
    if (jumpTimer == -1 && input(keyboard_check, [vk_space, ord("X"), vk_enter])) {
        allowJump = false;
        jumpTimer = 0;
        jumpZ = z;
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
    z = jumpZ - jumpHeight * (1 - (2 * jumpTimer - 1) * (2 * jumpTimer - 1));
    if (z > 0 && respawnTimer == -1) {
        // death
        respawnTimer = 0;
    }
} else if (moving) {
    var frame_idx = (current_time * 0.005) % 4;
    image_index = sprites.walk[frame_idx];
} else {
    image_index = sprites.idle;
}
// collision check
var collision = noone;
var hitbox_radius = 5;
var wanda_x = x;
var wanda_y = y;
var wanda_z = z;
with (obj_platform) {
    if (wanda_z >= z) {
        var pos_x = clamp(wanda_x, x, x + CELL_SIZE);
        var pos_y = clamp(wanda_y, y, y + CELL_SIZE);
        if (point_distance(wanda_x, wanda_y, pos_x, pos_y) < hitbox_radius) {
            collision = id;
            break;
        }
    }
}
if (collision != noone) {
    lastPlatform = collision;
    if (zprevious < collision.z) {
        // landing on a platform
        z = collision.z;
        jumpTimer = -1;
    } else if (wanda_z != z) {
        x = xprevious;
        y = yprevious;
    }
} else if (jumpTimer == -1) {
    allowJump = false;
    jumpTimer = 0.5;
    jumpZ = z + jumpHeight;
    jumpParity = !jumpParity;
}
obj_control.posX = x;
obj_control.posY = y;
obj_control.posZ = z;