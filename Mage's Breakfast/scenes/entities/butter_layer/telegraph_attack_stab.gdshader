shader_type spatial;
uniform vec3 color = vec3(1.0, 0.1, 0.1);
uniform float thickness;
uniform float dampening;
uniform vec2 from = vec2(0.0, 0.0);
uniform vec2 to = vec2(1.0, 0.5);

float dist(vec2 pt, float A, float B, float C) {
	return abs(A * pt.x + B * pt.y + C) / sqrt(A * A + B * B);
}

void fragment() {
	ALBEDO = color;
	float A = 1.0;
	float B = (from.x - to.x) / (to.y - from.y);
	float C = -from.x - B * from.y;
	
	vec2 uv = UV * 2.0 - 1.0;
	uv.y = -uv.y;
	float d = dist(uv, A, B, C);
	float val = 1.0 - smoothstep(thickness, thickness + dampening, d);
	ALPHA *= val;
}

void light() {
	// Called for every pixel for every light affecting the material.
}
