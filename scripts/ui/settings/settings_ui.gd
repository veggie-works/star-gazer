## UI for modifying game settings
extends Control

## Child panel for adjust accessibility settings
@onready var accessibility_settings_panel: Control = $accessibility_settings_panel
## Child panel for adjust audio values
@onready var audio_settings_panel: Control = $audio_settings_panel
## Child panel for modifying input bindings
@onready var input_bindings_panel: Control = $input_bindings_panel
## Parent container of menu buttons list
@onready var margin_container: MarginContainer = $margin_container
@onready var menu_buttons: VBoxContainer = margin_container.get_node("menu_buttons")
	
func _on_back_button_pressed() -> void:
	hide()

func _on_accessibility_settings_button_pressed() -> void:
	margin_container.hide()
	accessibility_settings_panel.show()

func _on_accessibility_settings_panel_hidden() -> void:
	margin_container.show()

func _on_audio_settings_button_pressed() -> void:
	margin_container.hide()
	audio_settings_panel.show()

func _on_audio_settings_panel_hidden() -> void:
	margin_container.show()

func _on_input_bindings_button_pressed() -> void:
	margin_container.hide()
	input_bindings_panel.show()

func _on_input_bindings_panel_hidden() -> void:
	margin_container.show()

func _on_hidden() -> void:
	margin_container.show()
	accessibility_settings_panel.hide()
	audio_settings_panel.hide()
	input_bindings_panel.hide()
