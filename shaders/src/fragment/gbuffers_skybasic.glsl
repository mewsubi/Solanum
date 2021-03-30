#include "/src/include/settings.glsl"

varying vec4 v_color;

void main() {
	/* RENDERTARGETS: 0 */
	gl_FragData[ 0 ] = v_color;
}