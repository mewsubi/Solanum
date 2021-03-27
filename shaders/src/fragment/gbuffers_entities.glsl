uniform sampler2D tex;
uniform sampler2D lightmap;
uniform vec4 entityColor;

varying vec2 v_coord_tex;
varying vec2 v_coord_lm;
varying vec4 v_color;

void main() {
	vec4 albedo = texture2D( tex, v_coord_tex );
	vec4 light = texture2D( lightmap, v_coord_lm );

	/* RENDERTARGETS: 0 */
	vec4 color = albedo * light * v_color;
	color.rgb = mix( color.rgb, entityColor.rgb, entityColor.a );
	gl_FragData[ 0 ] = color;
}