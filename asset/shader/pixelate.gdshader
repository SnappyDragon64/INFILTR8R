shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform int x = 960;
uniform int y = 540;

void fragment()
{
	float st_x = (round(SCREEN_UV.x * float(x))+0.5)/float(x);
	float st_y = (round(SCREEN_UV.y * float(y))+0.5)/float(y);
	vec2 st = vec2(st_x, st_y);
    vec4 tex_col = textureLod(screen_texture, st, 0);
    COLOR = tex_col;
}