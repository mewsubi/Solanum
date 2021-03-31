#include "/src/include/settings.glsl"
#extension GL_ARB_shader_texture_lod : enable

uniform sampler2D tex;

varying vec2 v_coord_tex;
#ifdef COLORED_SHADOWS
varying vec4 v_color;
#endif

void main() {
	vec4 color = texture2DLod( tex, v_coord_tex, 0 )
	#ifdef COLORED_SHADOWS
	* v_color
	#endif
	;

	#ifdef COLORED_SHADOWS
	if( color.a > 0.9 ) color.rgb *= 0.0;
	#endif
	
	gl_FragData[ 0 ] = color;
}