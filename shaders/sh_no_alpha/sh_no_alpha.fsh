//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main()
{
	vec4 col = v_vColour;
	col.a = texture2D( gm_BaseTexture, v_vTexcoord ).a;
	if (col.a != 0.0)
	{
		col.a = v_vColour.a;
	}
    gl_FragColor = col;
}
