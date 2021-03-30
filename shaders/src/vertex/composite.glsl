varying vec2 v_coord_tex;

void main() {
	vec4 position = gl_Vertex;
	v_coord_tex = position.xy;
	gl_Position = position - 0.5;
}