## UI for modifying game settings
extends Control

## Child panel for modifying input bindings
@onready var input_bindings_panel: Control = $input_bindings_panel
## Parent container of menu buttons list
@onready var margin_container: MarginContainer = $margin_container
@onready var menu_buttons: VBoxContainer = margin_container.get_node("menu_buttons")
## Container for master volume control slider
@onready var master_volume_container: HBoxContainer = menu_buttons.get_node("master_volume_container")
## Control for master volume
@onready var master_volume_slider: HSlider = master_volume_container.get_node("master_volume_slider")
## Label displaying the master volume, in percent
@onready var master_volume_value_label: Label = master_volume_container.get_node("value_label")
## Container for music volume control slider
@onready var music_volume_container: HBoxContainer = menu_buttons.get_node("music_volume_container")
## Control for music volume
@onready var music_volume_slider: HSlider = music_volume_container.get_node("music_volume_slider")
## Label displaying the music volume, in percent
@onready var music_volume_value_label: Label = music_volume_container.get_node("value_label")
## Container for SFX volume control slider
@onready var sfx_volume_container: HBoxContainer = menu_buttons.get_node("sfx_volume_container")
## Control for SFX volume
@onready var sfx_volume_slider: HSlider = sfx_volume_container.get_node("sfx_volume_slider")
## Label displaying the SFX volume, in percent
@onready var sfx_volume_value_label: Label = sfx_volume_container.get_node("value_label")
## Container for screen shake intensity slider
@onready var screen_shake_container: HBoxContainer = menu_buttons.get_node("screen_shake_intensity_container")
## Control for screen shake intensity
@onready var screen_shake_slider: HSlider = screen_shake_container.get_node("screen_shake_intensity_slider")
## Label displaying the screen shake intensity, in percent
@onready var screen_shake_value_label: Label = screen_shake_container.get_node("value_label")

func _ready() -> void:
	master_volume_slider.value = SaveManager.settings.master_volume
	master_volume_value_label.text = " %d%%" % round(SaveManager.settings.master_volume * 100)
	music_volume_slider.value = SaveManager.settings.music_volume
	music_volume_value_label.text = " %d%%" % round(SaveManager.settings.music_volume * 100)
	sfx_volume_slider.value = SaveManager.settings.sfx_volume
	sfx_volume_value_label.text = " %d%%" % round(SaveManager.settings.sfx_volume * 100)
	screen_shake_slider.value = SaveManager.settings.screen_shake_intensity
	screen_shake_value_label.text = " %d%%" % round(SaveManager.settings.screen_shake_intensity * 100)
	

func _on_back_button_pressed() -> void:
	hide()

func _on_input_bindings_button_pressed() -> void:
	margin_container.hide()
	input_bindings_panel.show()

func _on_input_bindings_panel_hidden() -> void:
	margin_container.show()

func _on_hidden() -> void:
	margin_container.show()
	input_bindings_panel.hide()

func _on_master_volume_slider_value_changed(value: float) -> void:
	SaveManager.settings.master_volume = value
	AudioManager.update_music_volume()
	master_volume_value_label.text = " %d%%" % round(SaveManager.settings.master_volume * 100)

func _on_music_volume_slider_value_changed(value: float) -> void:
	SaveManager.settings.music_volume = value
	AudioManager.update_music_volume()
	music_volume_value_label.text = " %d%%" % round(SaveManager.settings.music_volume * 100)

func _on_sfx_volume_slider_value_changed(value: float) -> void:
	SaveManager.settings.sfx_volume = value
	sfx_volume_value_label.text = " %d%%" % round(SaveManager.settings.sfx_volume * 100)

func _on_screen_shake_intensity_slider_value_changed(value: float) -> void:
	SaveManager.settings.screen_shake_intensity = value
	screen_shake_value_label.text = " %d%%" % round(SaveManager.settings.screen_shake_intensity * 100)
