#include "/src/include/settings.glsl"
#include "/src/utils/util_shadow.glsl"

varying vec2 v_coord_tex;

void main() {
	vec4 pos_shadow = ftransform();
	pos_shadow.xy = pos_shadow.xy * calc_distort( pos_shadow.xyz );
	pos_shadow.z *= 0.3;
	gl_Position = pos_shadow;
	v_coord_tex = ( gl_TextureMatrix[ 0 ] * gl_MultiTexCoord0 ).xy;
}