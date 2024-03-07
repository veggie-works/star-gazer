// Replace a color and flash the canvas item
shader_type canvas_item;

// The color of the pixels to be replaced
uniform vec3 key_color: source_color = vec3(1.0, 0.0, 1.0);
// The color to replace the keyed pixels with
uniform vec3 replace_color: source_color = vec3(1.0);
// The color when flashing
uniform vec3 flash_color: source_color = vec3(1.0);
// The amount to flash
uniform float flash_amount: hint_range(0.0, 1.0) = 0.0;

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	vec4 key_color_a = vec4(key_color, 1.0);
	if (distance(color, key_color_a) < 0.1) {
		color = vec4(replace_color, 1.0);
	}
	
	vec3 color_rgb = mix(color.rgb, flash_color, flash_amount);
	color.rgb = color_rgb;
	
	COLOR = color;
}
