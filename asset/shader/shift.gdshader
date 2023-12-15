shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform float shift = 0.0;

void fragment() {
    vec4 sprite_color = texture(TEXTURE, UV);
	
	if (sprite_color.a == 1.0) {
    	vec4 color = texture(screen_texture, SCREEN_UV);
		
		vec3 color_hsv;
		{
			vec3 c = vec3(color.x, color.y, color.z);
			vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
			vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
			vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));
			float d = q.x - min(q.w, q.y);
			float e = 1.0e-10;
			color_hsv=vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
		}
		
		color_hsv.x = mod((color_hsv.x + shift), 1.0f);
		
		vec3 color_rgb;
		{
			vec3 c = color_hsv;
			vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
			vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
			color_rgb=c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
		}

		color = vec4(color_rgb.rgb,color.a);
        COLOR.rgba = color;
    }
	
}