#include "/src/include/settings.glsl"

uniform sampler2D tex;
uniform vec4 entityColor;

varying vec2 v_coord_tex;
varying vec4 v_color;

void main() {
	vec4 albedo = texture2D( tex, v_coord_tex );

	/* RENDERTARGETS: 0 */
	vec4 color = albedo * v_color;
	color.rgb = mix( color.rgb, entityColor.rgb, entityColor.a );
	gl_FragData[ 0 ] = color;
}