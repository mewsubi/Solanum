#include "/src/include/settings.glsl"

varying vec2 v_coord_tex;
varying vec4 v_color;

void main() {
	vec4 position = ftransform();
	gl_Position = position;

	v_color = gl_Color;
	v_coord_tex = ( gl_TextureMatrix[0] * gl_MultiTexCoord0 ).xy;
}