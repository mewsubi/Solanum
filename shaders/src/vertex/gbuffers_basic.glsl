#include "/src/include/settings.glsl"

varying vec4 v_color;

void main() {
	vec4 position = ftransform();
	gl_Position = position;

	v_color = gl_Color;
}