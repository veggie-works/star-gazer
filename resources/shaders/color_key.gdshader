shader_type canvas_item;

// The color of the pixels to be replaced
uniform vec3 key_color: source_color = vec3(1.0, 0.0, 1.0);
// The color to replace the keyed pixels with
uniform vec3 replace_color: source_color = vec3(1.0);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	if (color.rgb == key_color) {
		COLOR = vec4(replace_color, 1.0);
	} else {
		COLOR = color;	
	}
}
