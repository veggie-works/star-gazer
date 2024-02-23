## Full screen blanker for transitioning between scenes
class_name Fader extends BaseUI

## Emitted when the fader finishes fading in
signal faded_in
## Emitted when the fader finishes fading out
signal faded_out

## Controls the fade in and fade out animations
@onready var animator: AnimationPlayer = $animator

func open() -> void:
	super.open()
	animator.play("fade_in")

func close() -> void:
	animator.play("fade_out")

func _on_animator_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"fade_in":
			faded_in.emit()
		"fade_out":
			super.close()
			faded_out.emit()
