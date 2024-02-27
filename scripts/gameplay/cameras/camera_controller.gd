## A custom camera controller
extends Camera2D

## The speed at which the camera should track its targets
@export_range(1, 15) var track_speed: float = 5
## A list of targets to track
@export var targets: Array[Node2D] = []
## Whether to track targets along the horizontal axis
@export var track_x: bool = true
## Whether to track targets along the vertical axis
@export var track_y: bool = true

## Controls camera shake
@onready var shaker: Shaker = $shaker

func _process(delta: float) -> void:
	if targets.all(func(target): return target != null):
		track(delta)

## Add a target for this camera to track
func add_target(target: Node2D) -> void:
	targets.append(target)
	global_position = get_target_pos()
	
## Shake the camera
func shake(amount: float, duration: float) -> void:
	if shaker:
		shaker.shake(amount * SaveManager.settings.screen_shake_intensity, duration)

## Track targets
func track(delta: float) -> void:
	global_position = global_position.lerp(get_target_pos(), track_speed * delta)

## Fetch the position that the camera should track to
func get_target_pos() -> Vector2:
	var center_x: float = global_position.x
	var center_y: float = global_position.y
	if track_x:
		var min_x: float = targets.reduce(func(x, target):
			return target.global_position.x if target.global_position.x < x else x,
		INF)
		var max_x: float = targets.reduce(func(x, target):
			return target.global_position.x if target.global_position.x > x else x,
		-INF)
		center_x = min_x + (max_x - min_x) / 2
	if track_y:
		var min_y: float = targets.reduce(func(y, target): 
			return target.global_position.y if target.global_position.y < y else y,
		INF)
		var max_y: float = targets.reduce(func(y, target):
			return target.global_position.y if target.global_position.y > y else y,
		-INF)
		center_y = min_y + (max_y - min_y) / 2
	return Vector2(center_x, center_y)
