uniform sampler2D tex;

varying vec2 v_coord_tex;
varying vec4 v_color;

void main() {
	/* RENDERTARGETS: 0 */
	gl_FragData[ 0 ] = texture2D( tex, v_coord_tex );
}