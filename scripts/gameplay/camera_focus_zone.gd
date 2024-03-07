## Locks the camera into a specific zoom
extends Node2D

## The shape to focus on when the player enters the trigger
@onready var focus_area: CollisionShape2D = $focus_area

## The rect that the focus area encloses
@onready var focus_rect: Rect2 = focus_area.shape.get_rect()

func _on_trigger_body_entered(_body: Player) -> void:
	GameCamera.locked = true
	var zoom_tween: Tween = create_tween()
	zoom_tween.tween_property(GameCamera, "global_position", focus_area.global_position, 0.25).set_trans(Tween.TRANS_SINE)
	zoom_tween.parallel().tween_property(GameCamera, "zoom", Vector2.ONE * get_viewport_rect().size.x / focus_rect.size.x, 0.25).set_trans(Tween.TRANS_SINE)
	zoom_tween.play()

func _on_trigger_body_exited(_body: Player) -> void:
	GameCamera.locked = false
