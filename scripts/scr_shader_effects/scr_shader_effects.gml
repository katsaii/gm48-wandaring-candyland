
/// @desc Only colours greyscale pixels.
function shader_set_effect_colour_grey() {
    if (shader_is_compiled(shd_colour_grey)) {
        shader_set(shd_colour_grey);
    }
}

/// @desc Clipping effect.
/// @param {Real} x1 The left-most position to clip.
/// @param {Real} y1 The top-most position to clip.
/// @param {Real} x2 The right-most position to clip.
/// @param {Real} y2 The bottom-most position to clip.
function shader_set_effect_clip(_x1, _y1, _x2, _y2) {
    static u_point_a = shader_get_uniform(shd_clipping, "u_pointA");
    static u_point_b = shader_get_uniform(shd_clipping, "u_pointB");
    if (shader_is_compiled(shd_clipping)) {
        shader_set(shd_clipping);
        shader_set_uniform_f(u_point_a, _x1, _y1);
        shader_set_uniform_f(u_point_b, _x2, _y2);
    }
}

/// @desc Dithering effect.
/// @param {Real} [intensity=1] The intensity of the dithering.
function shader_set_effect_dithering(_intensity=1) {
    static u_intensity = shader_get_uniform(shd_dither, "u_intensity");
    if (shader_is_compiled(shd_dither)) {
        shader_set(shd_dither);
        shader_set_uniform_f(u_intensity, _intensity);
    }
}

/// @desc Outline effect.
/// @param {Real} texel_w The width of a texel.
/// @param {Real} texel_h The height of a texel.
/// @param {Real} colour The colour of the outline.
/// @param {Real} thickness The thickness of the outline.
function shader_set_effect_outline(_texel_w, _texel_h, _outline, _thickness) {
    static u_outline = shader_get_uniform(shd_outline_fast, "u_outline");
    static u_texel_w = shader_get_uniform(shd_outline_fast, "u_texelW");
    static u_texel_h = shader_get_uniform(shd_outline_fast, "u_texelH");
    static u_outline_slow = shader_get_uniform(shd_outline, "u_outline");
    static u_texel_w_slow = shader_get_uniform(shd_outline, "u_texelW");
    static u_texel_h_slow = shader_get_uniform(shd_outline, "u_texelH");
    static u_thickness_slow = shader_get_uniform(shd_outline, "u_thickness");
    if (_thickness < 1) {
        return;
    }
    if (_thickness == 1 && shader_is_compiled(shd_outline_fast)) {
        shader_set(shd_outline_fast);
        shader_set_uniform_f(u_outline,
                color_get_red(_outline) / 255,
                color_get_green(_outline) / 255,
                color_get_blue(_outline) / 255);
        shader_set_uniform_f(u_texel_w, _texel_w);
        shader_set_uniform_f(u_texel_h, _texel_h);
    } else if (shader_is_compiled(shd_outline)) {
        shader_set(shd_outline);
        shader_set_uniform_f(u_outline_slow,
                color_get_red(_outline) / 255,
                color_get_green(_outline) / 255,
                color_get_blue(_outline) / 255);
        shader_set_uniform_f(u_texel_w_slow, _texel_w);
        shader_set_uniform_f(u_texel_h_slow, _texel_h);
        shader_set_uniform_f(u_thickness_slow, _thickness);
    }
}

/// @desc Greyscale effect.
/// @param {Real} [ratio=1] The intensity of the greyscale.
function shader_set_effect_greyscale(_ratio=1) {
    static u_ratio = shader_get_uniform(shd_greyscale, "u_ratio");
    if (shader_is_compiled(shd_greyscale)) {
        shader_set(shd_greyscale);
        shader_set_uniform_f(u_ratio, _ratio);
    }
}

/// @desc Sepia effect.
/// @param {Real} [ratio=1] The intensity of the sepia.
function shader_set_effect_sepia(_ratio=1) {
    static u_ratio = shader_get_uniform(shd_sepia, "u_ratio");
    if (shader_is_compiled(shd_sepia)) {
        shader_set(shd_sepia);
        shader_set_uniform_f(u_ratio, _ratio);
    }
}

/// @desc Invert effect.
function shader_set_effect_invert() {
    if (shader_is_compiled(shd_invert)) {
        shader_set(shd_invert);
    }
}

/// @desc Saturation effect.
/// @param {Real} [intensity=1] The intensity of the saturation.
function shader_set_effect_saturate(_intensity=1) {
    static u_intensity = shader_get_uniform(shd_saturate, "u_intensity");
    if (shader_is_compiled(shd_saturate)) {
        shader_set(shd_saturate);
        shader_set_uniform_f(u_intensity, _intensity);
    }
}

/// @desc Brightness effect.
/// @param {Real} [ratio=0.5] The intensity of the brightness.
function shader_set_effect_brightness(_ratio=0.5) {
    static u_intensity = shader_get_uniform(shd_brightness, "u_intensity");
    if (shader_is_compiled(shd_brightness)) {
        shader_set(shd_brightness);
        shader_set_uniform_f(u_intensity, _ratio * 2 - 1);
    }
}

/// @desc Colour shift effect.
/// @param {Real} [angle=0] The number of degrees to rotate the hue.
function shader_set_effect_hue_shift(_angle=0) {
    static u_shift = shader_get_uniform(shd_hue_shift, "u_shift");
    if (shader_is_compiled(shd_hue_shift)) {
        shader_set(shd_hue_shift);
        shader_set_uniform_f(u_shift, _angle / 360);
    }
}

/// @desc Posterisation effect.
/// @param {Real} n The number of colours to limit.
/// @param {Real} [gamma=0.6] The gamma of the image.
function shader_set_effect_posterise(_n, _gamma=0.6) {
    static u_gamma = shader_get_uniform(shd_posterise, "u_gamma");
    static u_colour_count = shader_get_uniform(shd_posterise, "u_colour_count");
    if (shader_is_compiled(shd_posterise)) {
        shader_set(shd_posterise);
        shader_set_uniform_f(u_gamma, _gamma);
        shader_set_uniform_f(u_colour_count, _n);
    }
}

/// @desc Draws this sprite with a pattern masked over it.
/// @param {Real} sprite The sprite to draw.
/// @param {Real} subimg The subimage of the sprite to use.
/// @param {Real} x X position.
/// @param {Real} y Y position.
/// @param {Real} xscale X scale.
/// @param {Real} yscale Y scale.
/// @param {Real} rot Rotation.
/// @param {Real} col Blend.
/// @param {Real} alpha Alpha.
/// @param {Real} pattern The sprite of the pattern of mask.
/// @param {Real} subpattern The subimage of the pattern to mask.
/// @param {Real} xoff The X offset for this pattern.
/// @param {Real} yoff The Y offset for this pattern.
function draw_sprite_pattern(_sprite, _subimg, _x, _y, _xscale, _yscale, _angle, _colour, _alpha, _pattern, _subpattern, _xoff, _yoff) {
    static sampler_texture = shader_get_sampler_index(shd_pattern, "s_samplerTexture");
    static sampler_size = shader_get_uniform(shd_pattern, "u_samplerSize");
    static sampler_uvs = shader_get_uniform(shd_pattern, "u_samplerUVs");
    static sampler_offset = shader_get_uniform(shd_pattern, "u_samplerOffset");
    if (shader_is_compiled(shd_pattern)) {
        var last_shader = shader_current();
        shader_set(shd_pattern);
        texture_set_stage(sampler_texture, sprite_get_texture(_pattern, _subpattern));
        shader_set_uniform_f(sampler_size, sprite_get_width(_pattern), sprite_get_height(_pattern));
        shader_set_uniform_f_array(sampler_uvs, sprite_get_uvs(_pattern, _subpattern));
        shader_set_uniform_f(sampler_offset, _xoff, _yoff);
        draw_sprite_ext(_sprite, _subimg, _x, _y,
                _xscale, _yscale, _angle, _colour, _alpha);
        if (last_shader == -1) {
            shader_reset();
        } else {
            shader_set(last_shader);
        }
    }
}