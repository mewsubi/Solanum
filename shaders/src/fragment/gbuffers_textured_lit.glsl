uniform sampler2D tex;
uniform sampler2D lightmap;

varying vec2 v_coord_tex;
varying vec2 v_coord_lm;
varying vec4 v_color;

void main() {
	vec4 albedo = texture2D( tex, v_coord_tex );
	vec4 light = texture2D( lightmap, v_coord_lm );

	/* RENDERTARGETS: 0 */
	gl_FragData[ 0 ] = albedo * light * v_color;
}