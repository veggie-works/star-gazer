// Cuts out of a canvas item the shape of an input texture
shader_type canvas_item;

// The texture mask to cut out of the canvas item
uniform sampler2D cutout_texture;

void fragment() {
	vec4 cutout_color = texture(cutout_texture, UV);
	if (cutout_color.a > 0.0) {
		COLOR.a = 0.0;
	}
}
