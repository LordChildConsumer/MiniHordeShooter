shader_type canvas_item;

uniform float pct: hint_range(0.0, 1.0, 0.01) = 1.0;
uniform float bar_size: hint_range(0.0, 1.0, 0.001) = 0.15;
uniform vec4 over: source_color = vec4(0.0, 1.0, 0.0, 1.0);
uniform vec4 under: source_color = vec4(1.0, 0.0, 0.0, 1.0);
uniform vec4 bar: source_color = vec4(1.0, 1.0, 1.0, 1.0);

vec4 square(vec2 uv, float width, bool invert)
{
	uv = uv * 2.0 - 1.0;
	
	vec2 abs_uv = abs(uv.xy);
	float square = step(width, max(abs_uv.x, abs_uv.y));
	if (invert) { square = 1.0 - square; }
	return vec4(vec3(square), square);
}

vec4 square_stroke(vec2 uv, float width, float stroke_width, bool invert)
{
	uv = uv * 2.0 - 1.0;
	
	vec2 abs_uv = abs(uv.xy);
	float dist = max(abs_uv.x, abs_uv.y);
	vec3 stroke = vec3( step(width, dist) - step(width + stroke_width, dist) );
	if (invert) {  stroke = 1.0 - stroke;  }
	return vec4(vec3(stroke), stroke.r);
}


void fragment() {
	vec4 o = square(UV, pct, true) * over;
	vec4 u = square(UV, pct, false) * under;
	vec4 b = square_stroke(UV, pct, bar_size * pct, false) * bar;
	COLOR = o + u + b;
}