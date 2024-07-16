shader_type canvas_item;

uniform float pct: hint_range(0.0, 1.0, 0.01) = 1.0;
uniform float bar_size: hint_range(0.0, 1.0, 0.001) = 0.001;
uniform vec3 over: source_color = vec3(0.0, 1.0, 0.0);
uniform vec3 under: source_color = vec3(1.0, 0.0, 0.0);
uniform vec3 bar: source_color = vec3(1.0, 1.0, 1.0);


// Source: https://www.shadertoy.com/view/wtcczf
float ease_in_sine(float x)
{
    return 1.0 - cos((x * PI) / 2.0);
}


void fragment() {
	vec4 c = texture(TEXTURE, UV);
	
	float npct = mix(pct, ease_in_sine(pct), pct);
	
	// Over/Under
	if (UV.x <= npct) {
		c = vec4(over, 1.0);
	} else {
		c = vec4(under, 1.0);
	}
	
	// Bar
	if (abs(npct - UV.x) <= (bar_size * pct) && npct < 1.0) {
		c = vec4(bar, 1.0);
	}
	
	COLOR = c;
}