//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main()
{
	vec4 col = texture2D( gm_BaseTexture, v_vTexcoord );
	vec4 not_col;
	float avg = (col.r + col.g + col.b) / 3.0;
	col.r = avg;
	col.g = avg;
	col.b = avg;
	/*
	if (col.r >= minval || col.g >= minval || col.b >= minval)
	{
		col.a = 0.0;
	}
	else
	{
		col.r = 1.0;
		col.g = 1.0;
		col.b = 1.0;
	}
	*/
    gl_FragColor = v_vColour * col;
}
