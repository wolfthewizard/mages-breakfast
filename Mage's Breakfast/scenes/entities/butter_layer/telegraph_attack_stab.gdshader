shader_type spatial;
uniform vec3 color = vec3(1.0, 0.1, 0.1);
uniform float thickness;
uniform float dampening;
uniform vec2 from = vec2(2.0, 1.0);
uniform vec2 to = vec2(0.0, 0.5);

void fragment() {
	vec2 dir = to - from;
	float dir_ang = atan(dir.y / dir.x);
	if (dir.x < 0.0) {
		dir_ang += PI;
	}
	vec2 uv = (UV - 0.5) * 2.0;
	uv.x += to.x * from.y - to.y * from.x;
	float len = length(uv);
	float ang = atan(uv.y / uv.x);
	if (uv.x < 0.0) {
		ang += PI;
	}
	ang += dir_ang;
	uv = vec2(cos(ang), sin(ang)) * len;
	float val = uv.x;
	val = 	smoothstep(-thickness - dampening, -thickness, val) - 
			smoothstep(thickness, thickness + dampening, val);
	ALBEDO = color;
	ALPHA *= val;
}

void light() {
	// Called for every pixel for every light affecting the material.
}
