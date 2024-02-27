## An after image of an actor's sprite
class_name AfterImage extends Sprite2D

## The duration that the after image fades for
@export var fade_time: float = 1

func _process(delta: float) -> void:
	modulate.a -= 1.0 / fade_time * delta
	if modulate.a <= 0:
		queue_free()
