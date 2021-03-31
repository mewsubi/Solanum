#include "/src/include/settings.glsl"
#include "/src/utils/util_shadow.glsl"
#include "/src/utils/util_transform.glsl"
#extension GL_ARB_shader_texture_lod : enable

attribute vec3 mc_Entity;

uniform sampler2D lightmap;

uniform mat4 gbufferModelViewInverse;
uniform mat4 shadowModelView;
uniform mat4 shadowProjection;

uniform vec3 gViewToSClipR0;
uniform vec3 gViewToSClipR1;
uniform vec3 gViewToSClipR2;

uniform vec3 gViewToSClipC3;

varying vec3 v_pos_clip_shadow;

varying vec2 v_coord_tex;
varying vec2 v_coord_lm;
varying vec4 v_color;

varying float v_dot_N_L;

void main() {
	vec3 pos_view = mulMat4Vec3( gl_ModelViewMatrix, gl_Vertex.xyz );

	v_color = gl_Color * texture2DLod( lightmap, clamp( mat2( gl_TextureMatrix[1] ) * gl_MultiTexCoord1.xy, 0.03125, 0.96875 ), 0 );
	v_coord_tex = ( gl_TextureMatrix[0] * gl_MultiTexCoord0 ).xy;

	//mat3 gViewToSClip = mat3( gViewToSClipC0, gViewToSClipC1, gViewToSClipC2 );
	v_pos_clip_shadow = vec3( dot( gViewToSClipR0, pos_view ), dot( gViewToSClipR1, pos_view ), dot( gViewToSClipR2, pos_view ) );
	//mat4 gViewToSClip = gbufferModelViewInverse * shadowModelView * shadowProjection;
	//v_pos_clip_shadow = mulMat4Vec3( gViewToSClip, pos_view );
	//v_pos_clip_shadow = gViewToSClip * pos_view + gViewToSClipC3;

	vec3 normal = normalize( gl_Normal );
	v_dot_N_L = dot( normal, normalize( vec3( shadowModelView[ 0 ][ 2 ], shadowModelView[ 1 ][ 2 ], shadowModelView[ 2 ][ 2 ] ) ) );

	v_pos_clip_shadow += gViewToSClipC3;
	float distort = calc_distort( v_pos_clip_shadow.xyz );
	v_pos_clip_shadow.xy = v_pos_clip_shadow.xy * distort;
	v_pos_clip_shadow.z *= 0.3;
	v_pos_clip_shadow = v_pos_clip_shadow * 0.5 + 0.5;
	v_pos_clip_shadow -= vec3( 0.0, 0.0, max( 0.005 * ( 1.0 - v_dot_N_L ), 0.0005 ) * ( 1.0 / distort ) );

	gl_Position = gl_ProjectionMatrix * vec4( pos_view, 1.0 );
}