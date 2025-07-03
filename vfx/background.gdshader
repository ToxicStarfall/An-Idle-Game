shader_type canvas_item;

uniform float a = 0.5;


void vertex() {
	// Called for every vertex the material is visible on.
	//VERTEX += vec2(1, sin(TIME) * 50.0);
	//VERTEX.x += VERTEX.y;   // Tilt effect

	//VERTEX *= 0.5 + sin(fract(TIME) * 2.0) + 1.0;
	//float pi = 3.141592653589793;
	//VERTEX *= .5 + (sin(fract(TIME) * 3.0 * 1.) + 1.) / 4.;

	//float rate = 0.5;
	//VERTEX *= (UV/2.0) + abs(sin(TIME*rate)) / 2.0;
	//VERTEX.xy / 128.0;
}


uniform sampler2D gradient;

void fragment() {
	// Called for every pixel the material is visible on.
	//COLOR = vec4(UV, 1, 1);
	//COLOR.r = 0.5;
	COLOR = texture(TEXTURE, UV);

	//COLOR = texture(TEXTURE, UV + vec2(0.5, 0));
	//COLOR = texture(TEXTURE, UV * sin(TIME));

	//COLOR = vec4(VERTEX, 1.0, 1.0);
	COLOR = vec4(
		COLOR.r,
		COLOR.g,
		COLOR.b,
		COLOR.a
	);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
