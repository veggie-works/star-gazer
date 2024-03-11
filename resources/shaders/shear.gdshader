// Shears an object along the x- and/or y-axes
shader_type canvas_item;

// The amount to shear the canvas item horizontally
uniform float shear_x: hint_range(-1, 1) = 1;
// The amount to shear the canvas item vertically
uniform float shear_y: hint_range(-1, 1) = 0;

void vertex() {
	mat4 transform_matrix = mat4(
		vec4(1.0, shear_y, 0.0, 0.0),
		vec4(-shear_x, 1.0, 0.0, 0.0),
		vec4(0.0, 0.0, 1.0, 0.0),
		vec4(0.0, 0.0, 0.0, 1.0)
	);
	
	VERTEX = (transform_matrix * vec4(VERTEX, 0.0, 1.0)).xy;
}
