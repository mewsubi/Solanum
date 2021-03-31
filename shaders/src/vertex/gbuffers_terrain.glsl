#include "/src/include/settings.glsl"
#include "/src/utils/util_shadow.glsl"
#include "/src/utils/util_transform.glsl"
#extension GL_ARB_shader_texture_lod : enable

attribute vec3 mc_Entity;

uniform sampler2D lightmap;

uniform vec3 cameraPosition;
uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;
uniform mat4 shadowModelView;
uniform mat4 shadowProjection;
uniform vec3 shadowDir;

uniform vec3 gViewToSClipR0;
uniform vec3 gViewToSClipR1;
uniform vec3 gViewToSClipR2;

uniform vec3 sMVPR0;
uniform vec3 sMVPR1;
uniform vec3 sMVPR2;
uniform vec3 sMVPC3;

uniform vec3 gViewToSClipC3;

varying vec3 v_vec_view;

varying vec3 v_pos_clip_shadow;

varying vec2 v_coord_tex;
varying vec4 v_color;
varying vec3 v_normal;

varying float v_dot_N_L;
varying float v_metallic;
varying float v_roughness;

void main() {
	vec3 pos_view = mulMat4Vec3( gl_ModelViewMatrix, gl_Vertex.xyz );

	v_color = gl_Color * texture2DLod( lightmap, clamp( mat2( gl_TextureMatrix[1] ) * gl_MultiTexCoord1.xy, 0.03125, 0.96875 ), 0 );
	v_coord_tex = ( gl_TextureMatrix[0] * gl_MultiTexCoord0 ).xy;

	vec3 pos_world = mulMat4Vec3( gbufferModelViewInverse, pos_view );

	//v_pos_clip_shadow = vec3( dot( gViewToSClipR0, pos_view ), dot( gViewToSClipR1, pos_view ), dot( gViewToSClipR2, pos_view ) );
	v_vec_view = pos_world;
	v_pos_clip_shadow = vec3( dot( sMVPR0, pos_world ), dot( sMVPR1, pos_world ), dot( sMVPR2, pos_world ) );

	v_normal = normalize( gl_Normal );
	v_dot_N_L = clamp( dot( v_normal, shadowDir ), 0.0, 1.0 );

	v_pos_clip_shadow += sMVPC3;
	float distort = calc_distort( v_pos_clip_shadow.xyz );
	v_pos_clip_shadow.xy = v_pos_clip_shadow.xy * distort;
	v_pos_clip_shadow.z *= 0.3;
	v_pos_clip_shadow = v_pos_clip_shadow * 0.5 + 0.5;
	v_pos_clip_shadow -= vec3( 0.0, 0.0, max( 0.005 * ( 1.0 - v_dot_N_L ), 0.0005 ) * ( 1.0 / distort ) );

	float metadata = max( 0.0, floor( mc_Entity.x - 9999.5 ) );
	v_metallic = mod( metadata, 2 ) * 0.9;
	v_roughness = 1.0 - ( 231.0 / 255.0 );

	gl_Position = gl_ProjectionMatrix * vec4( pos_view, 1.0 );
}