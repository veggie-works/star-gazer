## The game's main menu
class_name MainMenu extends BaseLevel

## Parent container of menu buttons list
@onready var margin_container: MarginContainer = $margin_container
## Warning for whether the player really wants to exit the game
@onready var exit_warning: VBoxContainer = $exit_warning
## UI for changing game settings
@onready var settings_ui: Control = $settings_ui

func _ready() -> void:
	AudioManager.stop_music()
	GameCamera.enabled = false
	UIManager.delete_ui(PauseMenu)
	if OS.is_debug_build():
		UIManager.delete_ui(DebugPanel)

func _on_start_button_pressed() -> void:
	UIManager.create_ui(PauseMenu, true)
	if OS.is_debug_build():
		UIManager.create_ui(DebugPanel)
	SaveManager.load_game(0)
	SceneManager.change_scene_load_save_point(SaveManager.save_data.last_save_point)

func _on_settings_button_pressed() -> void:
	margin_container.hide()
	settings_ui.show()

func _on_exit_button_pressed() -> void:
	margin_container.hide()
	exit_warning.show()

func _on_settings_ui_hidden():
	margin_container.show()

func _on_exit_warning_quit_canceled() -> void:
	exit_warning.hide()
	margin_container.show()

func _on_exit_warning_quit_confirmed() -> void:
	get_tree().quit()
