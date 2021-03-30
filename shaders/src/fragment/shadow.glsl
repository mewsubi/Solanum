#include "/src/include/settings.glsl"

uniform sampler2D tex;

varying vec2 v_coord_tex;

void main() {
	vec4 color = texture2D( tex, v_coord_tex );

	#ifdef COLORED_SHADOWS
	if( color.a > 0.95 ) color.rgb *= 0.0;
	#endif
	
	gl_FragData[ 0 ] = color;
}