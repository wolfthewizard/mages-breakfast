shader_type spatial;
uniform sampler2D source_texture;
uniform float scaling = 0.33;
uniform float angle = 0.0;
uniform float scroll_speed_mult = 0.5;

float when_lt(float x, float y) {
  return max(sign(y - x), 0.0);
}

void fragment() {
	float angle2 = angle + PI;
	vec2 uv = (UV - 0.5) * 2.0;
	vec2 scroll_dir = vec2(sin(angle2), cos(angle2));
	uv = uv - scroll_dir * TIME * scroll_speed_mult;
	uv = uv / scaling;
	float len = length(uv);
	float ang = atan(uv.y / uv.x);
	ang += PI * when_lt(uv.x, 0.0);
	ang += angle2;
	uv = vec2(cos(ang), sin(ang)) * len;
	ALBEDO = texture(source_texture, uv).rgb;
}

void light() {
	// Called for every pixel for every light affecting the material.
}
