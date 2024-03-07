// Flash the non-transparent pixels of a canvas item
shader_type canvas_item;

// The color when flashing
uniform vec3 flash_color: source_color = vec3(1.0);
// The amount to flash
uniform float flash_amount: hint_range(0.0, 1.0) = 0.0;

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	color = mix(color, vec4(flash_color, 1.0), flash_amount);
	COLOR = color;
}