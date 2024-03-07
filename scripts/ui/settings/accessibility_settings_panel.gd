## UI for modifying accessibility settings
extends Control

## Lists out all the accessibility settings
@onready var accessibility_settings_list: VBoxContainer = $panel/margin_container/accessibility_settings_list
## Container for screen shake intensity slider
@onready var screen_shake_container: HBoxContainer = accessibility_settings_list.get_node("screen_shake_intensity_container")
## Control for screen shake intensity
@onready var screen_shake_slider: HSlider = screen_shake_container.get_node("screen_shake_intensity_slider")
## Label displaying the screen shake intensity, in percent
@onready var screen_shake_value_label: Label = screen_shake_container.get_node("value_label")

func _ready() -> void:
	screen_shake_slider.value = SaveManager.settings.screen_shake_intensity
	screen_shake_value_label.text = " %d%%" % round(SaveManager.settings.screen_shake_intensity * 100)

func _on_screen_shake_intensity_slider_value_changed(value: float) -> void:
	SaveManager.settings.screen_shake_intensity = value
	screen_shake_value_label.text = " %d%%" % round(SaveManager.settings.screen_shake_intensity * 100)

func _on_back_button_pressed() -> void:
	hide()
