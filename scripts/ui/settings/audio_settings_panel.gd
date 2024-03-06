## UI for adjusting audio levels
extends Control

## Lists out all the audio settings
@onready var audio_settings_list: VBoxContainer = $panel/margin_container/audio_settings_list
## Container for master volume control slider
@onready var master_volume_container: HBoxContainer = audio_settings_list.get_node("master_volume_container")
## Control for master volume
@onready var master_volume_slider: HSlider = master_volume_container.get_node("master_volume_slider")
## Label displaying the master volume, in percent
@onready var master_volume_value_label: Label = master_volume_container.get_node("value_label")
## Container for music volume control slider
@onready var music_volume_container: HBoxContainer = audio_settings_list.get_node("music_volume_container")
## Control for music volume
@onready var music_volume_slider: HSlider = music_volume_container.get_node("music_volume_slider")
## Label displaying the music volume, in percent
@onready var music_volume_value_label: Label = music_volume_container.get_node("value_label")
## Container for SFX volume control slider
@onready var sfx_volume_container: HBoxContainer = audio_settings_list.get_node("sfx_volume_container")
## Control for SFX volume
@onready var sfx_volume_slider: HSlider = sfx_volume_container.get_node("sfx_volume_slider")
## Label displaying the SFX volume, in percent
@onready var sfx_volume_value_label: Label = sfx_volume_container.get_node("value_label")

func _ready() -> void:
	# Initialize audio settings from save settings file
	master_volume_slider.value = SaveManager.settings.master_volume
	master_volume_value_label.text = " %d%%" % round(SaveManager.settings.master_volume * 100)
	music_volume_slider.value = SaveManager.settings.music_volume
	music_volume_value_label.text = " %d%%" % round(SaveManager.settings.music_volume * 100)
	sfx_volume_slider.value = SaveManager.settings.sfx_volume
	sfx_volume_value_label.text = " %d%%" % round(SaveManager.settings.sfx_volume * 100)

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

func _on_back_button_pressed() -> void:
	hide()
