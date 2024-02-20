class_name MainMenu extends BaseLevel

## Parent container of menu buttons list
@onready var margin_container: MarginContainer = $margin_container
## UI for changing game settings
@onready var settings_ui: Control = $settings_ui

func _ready() -> void:
	UIManager.delete_ui(PauseMenu)

func _on_settings_button_pressed() -> void:
	margin_container.hide()
	settings_ui.show()

func _on_start_button_pressed() -> void:
	UIManager.create_ui(PauseMenu, true)
	SceneManager.change_scene(BaseLevel)


func _on_settings_ui_hidden():
	margin_container.show()
