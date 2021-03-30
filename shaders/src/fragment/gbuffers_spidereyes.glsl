#include "/src/include/settings.glsl"

uniform sampler2D tex;

varying vec2 v_coord_tex;
varying vec4 v_color;

void main() {
	vec4 albedo = texture2D( tex, v_coord_tex );

	/* RENDERTARGETS: 0 */
	gl_FragData[ 0 ] = albedo * v_color;
}