## The game's main menu
class_name MainMenu extends BaseLevel

## Parent container of menu buttons list
@onready var margin_container: MarginContainer = $margin_container
## UI for changing game settings
@onready var settings_ui: Control = $settings_ui

func _ready() -> void:
	AudioManager.stop_music()
	GameCamera.enabled = false
	UIManager.delete_ui(PauseMenu)
	if OS.is_debug_build():
		UIManager.delete_ui(DebugPanel)

func _on_settings_button_pressed() -> void:
	margin_container.hide()
	settings_ui.show()

func _on_start_button_pressed() -> void:
	UIManager.create_ui(PauseMenu, true)
	if OS.is_debug_build():
		UIManager.create_ui(DebugPanel)
	SaveManager.load_game(0)
	SceneManager.change_scene(SaveManager.save_data.save_scene)

func _on_settings_ui_hidden():
	margin_container.show()
