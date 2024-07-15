shader_type canvas_item;


uniform vec2 cam_position;
uniform vec4 star_color: source_color;
uniform sampler2D star_noise : repeat_enable;

vec2 polar_coordinates(vec2 uv, vec2 center, float zoom, float repeat)
{
	vec2 dir = uv - center;
	float radius = length(dir) * 2.0;
	float angle = atan(dir.y, dir.x) * 1.0/(3.1416 * 2.0);
	return mod(vec2(radius * zoom, angle * repeat), 1.0);
}


void fragment() {
	vec4 c = texture(star_noise, SCREEN_UV + (cam_position * SCREEN_PIXEL_SIZE));
	float a = step(0.6, c.r);
	
	COLOR = vec4(a) * star_color;
}