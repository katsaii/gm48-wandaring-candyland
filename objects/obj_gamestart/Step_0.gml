/// @desc Decrement count.
timer -= 0.0025;
if (timer < 0) {
    instance_destroy();
}