#include "/src/include/settings.glsl"

uniform sampler2D tex;

uniform mat4 gbufferModelView;
uniform sampler2DShadow shadowtex0;
uniform sampler2D shadowcolor0;

uniform vec3 shadowDir;

varying vec3 v_vec_view;

varying vec3 v_pos_clip_shadow;

varying vec2 v_coord_tex;
varying vec4 v_color;
varying vec3 v_normal;

varying float v_dot_N_L;
varying float v_metallic;
varying float v_roughness;

#define PI 3.1415926535

float DistributionGGX(vec3 N, vec3 H, float roughness)
{
    float a = roughness;
    float a2 = a*a;
    float NdotH = max(dot(N, H), 0.0);
    float NdotH2 = NdotH*NdotH;

    float nom   = a2;
    float denom = (NdotH2 * (a2 - 1.0) + 1.0);
    denom = PI * denom * denom;

    return nom / denom;
}
// ----------------------------------------------------------------------------
float GeometrySchlickGGX(float NdotV, float roughness)
{
    float r = (roughness + 1.0);
    float k = (r) / 8.0;

    float nom   = NdotV;
    float denom = NdotV * (1.0 - k) + k;

    return nom / denom;
}
// ----------------------------------------------------------------------------
float GeometrySmith(vec3 N, vec3 V, vec3 L, float roughness)
{
    float NdotV = max(dot(N, V), 0.0);
    float NdotL = max(dot(N, L), 0.0);
    float ggx2 = GeometrySchlickGGX(NdotV, roughness);
    float ggx1 = GeometrySchlickGGX(NdotL, roughness);

    return ggx1 * ggx2;
}
// ----------------------------------------------------------------------------
vec3 fresnelSchlick(float cosTheta, vec3 F0)
{
    return F0 + (1.0 - F0) * pow(max(1.0 - cosTheta, 0.0), 5.0);
}

void main() {
	vec4 color_sample = texture2D( tex, v_coord_tex ) * v_color;
	vec3 albedo = pow( color_sample.rgb, vec3( 2.2 ) );

	vec3 N = v_normal;
	vec3 V = normalize( vec3( gbufferModelView[ 3 ][ 0 ], gbufferModelView[ 3 ][ 1 ], gbufferModelView[ 3 ][ 2 ] ) - v_vec_view );

	vec3 F0 = vec3( 0.04 ); 
	F0 = mix( F0, albedo, v_metallic );

	vec3 Lo = vec3( 0.0 );

	// calculate per-light radiance
    vec3 L = shadowDir;
    vec3 H = normalize( V + L );
    vec3 radiance = vec3( 5.0 );

    // Cook-Torrance BRDF
    float NDF = DistributionGGX(N, H, v_roughness);   
    float G   = GeometrySmith(N, V, L, v_roughness);      
    vec3 F    = fresnelSchlick(max(dot(H, V), 0.0), F0);
       
    vec3 nominator    = NDF * G * F; 
    float denominator = 4 * max(dot(N, V), 0.0) * max(dot(N, L), 0.0) + 0.001; // 0.001 to prevent divide by zero.
    vec3 specular = nominator / denominator;
    
    // kS is equal to Fresnel
    vec3 kS = F;
    // for energy conservation, the diffuse and specular light can't
    // be above 1.0 (unless the surface emits light); to preserve this
    // relationship the diffuse component (kD) should equal 1.0 - kS.
    vec3 kD = vec3(1.0) - kS;
    // multiply kD by the inverse metalness such that only non-metals 
    // have diffuse lighting, or a linear blend if partly metal (pure metals
    // have no diffuse light).
    kD *= 1.0 - v_metallic;	  

    // scale light by NdotL
    float NdotL = v_dot_N_L;

    // add to outgoing radiance Lo
    Lo += (kD * albedo / PI + specular) * radiance * NdotL;  // note that we already multiplied the BRDF by the Fresnel (kS) so we won't multiply by kS again

	
	float sample_shadow = shadow2D( shadowtex0, v_pos_clip_shadow.xyz ).r;

	#ifdef COLORED_SHADOWS
	if( sample_shadow < 0.75 ) {
		vec4 color_shadow = texture2D( shadowcolor0, v_pos_clip_shadow.xy );
		Lo *= color_shadow.rgb * ( 1.0 - sample_shadow );
	}
	#else
	Lo *= sample_shadow;
	#endif

	vec3 ambient = vec3( 0.2 ) * albedo;
    
    vec3 color = ambient + Lo;
    color = color / (color + vec3(1.0));
    // gamma correct
    color = pow(color, vec3(1.0/2.2)); 

	/* RENDERTARGETS: 0 */
	gl_FragData[ 0 ] = vec4( color, color_sample.a );
}