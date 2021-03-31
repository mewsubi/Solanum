#include "/src/include/settings.glsl"
#extension GL_ARB_shader_texture_lod : enable

uniform sampler2D lightmap;

varying vec2 v_coord_tex;
varying vec4 v_color;

void main() {
	vec4 position = ftransform();
	gl_Position = position;

	v_color = gl_Color * texture2DLod( lightmap, clamp( mat2( gl_TextureMatrix[1] ) * gl_MultiTexCoord1.xy, 0.03125, 0.96875 ), 0 );
	v_coord_tex = ( gl_TextureMatrix[0] * gl_MultiTexCoord0 ).xy;
}