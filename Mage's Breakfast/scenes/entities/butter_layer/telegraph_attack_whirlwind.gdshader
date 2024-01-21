shader_type spatial;
uniform vec3 color = vec3(1.0, 0.1, 0.1);
uniform float thickness;
uniform float dampening;
uniform float angle;
uniform bool reverse;

void fragment() {
	ALBEDO = color;
	vec2 uv = (UV - 0.5) * 2.0;
	float len = length(uv);
	float ang = atan(uv.y / uv.x);
	if (uv.x < 0.0) {
		ang += PI;
	}
	ang += angle;
	uv = vec2(cos(ang), sin(ang)) * len;
	if (!reverse) {
		ang = -ang;
	}
	float val1 = fract((ang - TIME) / PI);
	val1 = sqrt(sqrt(val1));
	float val2 = uv.x;
	val2 = 	smoothstep(-thickness - dampening, -thickness, val2) - 
			smoothstep(thickness, thickness + dampening, val2);
	float combined = max(val1, val2);
	ALPHA *= combined;
}

void light() {
	// Called for every pixel for every light affecting the material.
}
