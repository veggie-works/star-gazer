class_name MainMenu extends BaseLevel

func _ready() -> void:
	if UIManager.get_ui(PauseMenu) != null:
		UIManager.delete_ui(PauseMenu)

func _on_settings_button_pressed() -> void:
	pass # Replace with function body.

func _on_start_button_pressed() -> void:
	UIManager.create_ui(PauseMenu, true)
	SceneManager.change_scene(BaseLevel)
