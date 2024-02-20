## The menu that appears when you pause the game
class_name PauseMenu extends BaseUI

## Controls the pause menu's animations
@onready var animator: AnimationPlayer = $animator
## The texture that blurs when the pause menu appears
@onready var background_blur: TextureRect = $background_blur
## Parent container of menu buttons list
@onready var margin_container: MarginContainer = $margin_container
## Parent of the main pause menu buttons
@onready var menu_buttons: VBoxContainer = $margin_container/menu_buttons
## UI for configuring game settings
@onready var settings_ui: Control = $settings_ui
## A confirmation warning that appears when quitting the game
@onready var quit_warning: VBoxContainer = $margin_container/quit_warning
## The viewport that the current level scene is a child of
@onready var viewport: SubViewport = get_node("/root/main/screen_container/screen")

## Only allow closing while an animation is not playing
var can_toggle: bool:
	get:
		return not animator.is_playing()

func _ready() -> void:
	background_blur.texture = viewport.get_texture()
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if not can_toggle:
			return
			
		if visible:
			settings_ui.hide()
			margin_container.show()
			close()
		else:
			open()
			
func open() -> void:
	super.open()
	pause()
	animator.play("open")
	
func close() -> void:
	animator.play("close")
	
func pause(do_pause: bool = true) -> void:
	get_tree().set_pause(do_pause)

func _on_animator_animation_finished(anim_name: String) -> void:
	match anim_name:
		"close":
			pause(false)
			super.close()

func _on_resume_button_pressed() -> void:
	close()

func _on_settings_button_pressed() -> void:
	margin_container.hide()
	settings_ui.show()

func _on_quit_button_pressed() -> void:
	menu_buttons.hide()
	quit_warning.show()

func _on_quit_confirm_pressed() -> void:
	close()
	SceneManager.change_scene(MainMenu)

func _on_quit_cancel_pressed() -> void:
	quit_warning.hide()
	menu_buttons.show()

func _on_settings_ui_hidden():
	margin_container.show()
