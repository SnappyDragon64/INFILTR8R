shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

void fragment() {
    vec4 sprite_color = texture(TEXTURE, UV);

    if (sprite_color.a == 1.0) {
    	vec4 color = texture(screen_texture, SCREEN_UV);
        COLOR = vec4(1.0 - color.rgb, 1.0);
    }
}