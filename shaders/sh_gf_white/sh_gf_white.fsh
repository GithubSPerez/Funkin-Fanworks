//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main()
{
	vec4 col = texture2D( gm_BaseTexture, v_vTexcoord );
	vec4 ocol = col;
	col.a = 0.0;
	if ((ocol.r >= 0.42 && ocol.r <= 0.43) && (ocol.g >= 0.058 && ocol.g <= 0.059) && (ocol.b >= 0.039 && ocol.b <= 0.04))
	{
		col.a = ocol.a;
	}
	col.r = 1.0;
	col.g = 1.0;
	col.b = 1.0;
    gl_FragColor = v_vColour * col;
}
