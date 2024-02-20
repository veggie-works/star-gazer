## UI for modifying game settings
extends Control

## Child panel for modifying input bindings
@onready var input_bindings_panel: Control = $input_bindings_panel
## Parent container of menu buttons list
@onready var margin_container: MarginContainer = $margin_container

func _on_back_button_pressed() -> void:
	hide()

func _on_input_bindings_button_pressed() -> void:
	margin_container.hide()
	input_bindings_panel.show()

func _on_input_bindings_panel_hidden() -> void:
	margin_container.show()

func _on_hidden():
	margin_container.show()
	input_bindings_panel.hide()
