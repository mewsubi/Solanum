#include "/src/include/settings.glsl"
#include "/src/utils/util_shadow.glsl"

uniform sampler2D lightmap;

uniform mat4 gbufferModelViewInverse;
uniform mat4 shadowModelView;
uniform mat4 shadowProjection;

varying vec4 v_pos_clip_shadow;

varying vec2 v_coord_tex;
varying vec2 v_coord_lm;
varying vec4 v_color;

void main() {
	vec4 pos_view = gl_ModelViewMatrix * gl_Vertex;

	v_color = gl_Color * texture2DLod( lightmap, ( gl_TextureMatrix[1] * gl_MultiTexCoord1 ).xy, 0 );
	v_coord_tex = ( gl_TextureMatrix[0] * gl_MultiTexCoord0 ).xy;

	v_pos_clip_shadow = shadowProjection * shadowModelView * gbufferModelViewInverse * pos_view;
	v_pos_clip_shadow.xy = v_pos_clip_shadow.xy * calc_distort( v_pos_clip_shadow.xyz );
	v_pos_clip_shadow.z *= 0.3;
	v_pos_clip_shadow = ( v_pos_clip_shadow * ( 0.5 / v_pos_clip_shadow.w ) ) + 0.5;

	gl_Position = gl_ProjectionMatrix * pos_view;
}