shader_type canvas_item;


uniform float speed = 0.1;
uniform float alpha = 0.5;
uniform float shrink_factor = 1;


void fragment() {
	// ADJUST SIZE
	vec2 uv = UV - 0.5;
	uv /= shrink_factor;
	uv += 0.5;
	
	// ADJUST ALPHA
	vec4 color = texture(TEXTURE, uv);
	color.a *= alpha;
	COLOR = color;
}

void vertex() {
	UV.x += TIME * speed;
	UV.y -= TIME * speed;
}
