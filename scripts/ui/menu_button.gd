extends Button

## The audio when clicking the button
@export var click_sound: AudioStream

func _on_pressed() -> void:
	AudioManager.play_clip(click_sound)
