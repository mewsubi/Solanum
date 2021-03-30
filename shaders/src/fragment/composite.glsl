#include "/src/include/settings.glsl"

uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D shadowtex0;

varying vec2 v_coord_tex;

void main() {
	/* RENDERTARGETS: 0 */

	#ifdef DEBUG
	vec2 coord = v_coord_tex;
	if( v_coord_tex.x < 0.5 && v_coord_tex.y < 0.5 ) {
		coord /= 0.5;
		gl_FragData[ 0 ] = texture2D( colortex1, coord );
	} else if( v_coord_tex.x < 0.5 && v_coord_tex.y >= 0.5 ) {
		coord.y -= 0.5;
		coord /= 0.5;
		gl_FragData[ 0 ] = texture2D( colortex0, coord );
	} else if( v_coord_tex.x >= 0.5 && v_coord_tex.y < 0.5 ) {
		coord.x -= 0.5;
		coord /= 0.5;
		gl_FragData[ 0 ] = texture2D( colortex0, coord );
	} else {
		coord -= 0.5;
		coord /= 0.5;
		gl_FragData[ 0 ] = texture2D( shadowtex0, coord );
	} 
	#else
	gl_FragData[ 0 ] = texture2D( colortex0, v_coord_tex );
	#endif
}