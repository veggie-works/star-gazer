## The menu that appears when you pause the game
class_name PauseMenu extends BaseUI

## The name of the scene that loads when quitting from the pause menu
@export_file(".tscn") var main_menu_scene: String

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

## Only allow closing while an animation is not playing
var can_toggle: bool:
	get:
		return not animator.is_playing()

func _ready() -> void:
	var viewport_texture: ViewportTexture = get_viewport().get_texture()
	background_blur.texture = ImageTexture.create_from_image(viewport_texture.get_image())
			
func open() -> void:
	if not can_toggle:
		return
	super.open()
	pause()
	animator.play("open")
	
func close() -> void:
	if not can_toggle:
		return
	animator.play("close")
	settings_ui.hide()
	_on_quit_warning_quit_canceled()

## Pause or unpause the game
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

func _on_settings_ui_hidden():
	margin_container.show()

func _on_quit_warning_quit_confirmed() -> void:
	close()
	SceneManager.change_scene(main_menu_scene)

func _on_quit_warning_quit_canceled() -> void:
	quit_warning.hide()
	menu_buttons.show()
