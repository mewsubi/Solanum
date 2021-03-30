#include "/src/include/settings.glsl"

uniform sampler2D tex;

uniform sampler2DShadow shadowtex0;
uniform sampler2D shadowcolor0;

varying vec3 v_pos_clip_shadow;

varying vec2 v_coord_tex;
varying vec4 v_color;

varying float v_dot_N_L;

void main() {
	vec4 albedo = texture2D( tex, v_coord_tex );

	float sample_shadow = shadow2D( shadowtex0, v_pos_clip_shadow.xyz ).r;

	vec4 color = albedo * v_color;
	vec3 diffuse = color.rgb * max( v_dot_N_L, 0.0 ) * 0.7;
	color.rgb *= 0.3;

	#ifdef COLORED_SHADOWS
	if( sample_shadow < 0.75 ) {
		vec4 color_shadow = texture2D( shadowcolor0, v_pos_clip_shadow.xy );
		diffuse *= color_shadow.rgb * ( 1.0 - sample_shadow );
	}
	#else
	diffuse *= sample_shadow;
	#endif

	color.rgb += diffuse;

	/* RENDERTARGETS: 0 */
	gl_FragData[ 0 ] = color;
}