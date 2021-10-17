/// @desc Update position and angle.
if (respawnTimer != -1) {
    var t = respawnTimer;
    respawnTimer += 0.025;
    if (respawnTimer > 1) {
        respawnTimer = -1;
    } else if (t < 0.5 && respawnTimer >= 0.5) {
        if (instance_exists(lastPlatform)) {
            x = lastPlatform.x + CELL_SIZE / 2;
            y = lastPlatform.y + CELL_SIZE / 2;
            z = lastPlatform.z - CELL_SIZE / 4;
        } else {
            x = xstart;
            y = ystart;
            z = zstart;
        }
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
        var snd = audio_play_sound(snd_jump, 0, false);
        audio_sound_gain(snd, choose(1.5, 1.75), 0);
        audio_sound_pitch(snd, choose(0.8, 1.25, 1.5));
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
var hitbox_radius = 5;
var grounded = false;
with (obj_platform) {
    var pos_x = clamp(other.x, x, x + CELL_SIZE);
    var pos_y = clamp(other.y, y, y + CELL_SIZE);
    var pos_distance = point_distance(pos_x, pos_y, other.x, other.y);
    if (pos_distance >= hitbox_radius) {
        // outside of collider
        continue;
    }
    if (abs(other.z - z) < 1) {
        grounded = true;
    }
    if (other.z > z && other.zprevious <= z) {
        other.z = z;
        other.jumpTimer = -1;
        other.lastPlatform = id;
    } else if (other.z > z) {
        var push_angle = point_direction(pos_x, pos_y, other.x, other.y);
        var push_distance = hitbox_radius - pos_distance;
        other.x += lengthdir_x(push_distance, push_angle);
        other.y += lengthdir_y(push_distance, push_angle);
    }
}
if (!grounded && jumpTimer == -1) {
    jumpTimer = 0.5;
    jumpZ = z + jumpHeight;
    jumpParity = !jumpParity;
}
obj_control.posX = x;
obj_control.posY = y;
obj_control.posZ = z;
// collide with stars
var hitbox_radius_collectible = 20;
with (obj_star) {
    if (point_distance_3d(other.x, other.y, other.z, x, y, z) >= hitbox_radius_collectible) {
        // outside of star
        continue;
    }
    if (follow == noone) {
        follow = obj_wanda;
        var prev_star = other.heldStar;
        if (prev_star != noone) {
            prev_star.follow = id;
        }
        other.heldStar = id;
    }
}