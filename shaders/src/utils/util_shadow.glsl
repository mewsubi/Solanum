float calc_distort( vec3 pos ) {
	return 1.0 / ( length( pos.xy ) + 0.1 );
}