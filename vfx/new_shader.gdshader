shader_type canvas_item;

varying float x_pos;

void vertex() {
	// Called for every vertex the material is visible on.
	//VERTEX += sin(TIME) * 50.0;
	//VERTEX = VERTEX.yx;
	//TEXTURE_PIXEL_SIZE
	x_pos += 1.0;
	float a = sin(TIME);
	if (x_pos > TEXTURE_PIXEL_SIZE.x ) {
		VERTEX.x -= 100.0;
	}
}

void fragment() {
	// Called for every pixel the material is visible on.
	//float columns = 2.0;
	//float rows = 2.0;
	//vec2 grid = fract(vec2(UV.x * columns, UV.y * rows));
	//COLOR.rgb = vec3(grid.r, grid.g, 0.0);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
