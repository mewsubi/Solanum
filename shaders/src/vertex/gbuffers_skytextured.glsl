varying vec2 v_coord_tex;

void main() {
	vec4 position = ftransform();
	gl_Position = position;

	v_coord_tex = ( gl_TextureMatrix[0] * gl_MultiTexCoord0 ).xy;
}