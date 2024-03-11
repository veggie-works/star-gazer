## A custom camera controller
extends Camera2D

## Data structure used for storing the min and max values for each axis
class TargetRanges:
	## The minimum position value for all targets along the x-axis
	var min_x: float
	## The maximum position value for all targets along the x-axis
	var max_x: float
	## The minimum position value for all targets along the y-axis
	var min_y: float
	## The maximum position value for all targets along the y-axis
	var max_y: float

## The base zoom factor
const BASE_ZOOM: float = 4

## The speed at which the camera lerps to its targets
@export var tracking_speed: float = 5
## A list of targets to track
@export var targets: Array[Node2D] = []
## The maximum distance that the camera has to be from its target position before it stops tracking
@export var end_tracking_threshold: float = 10

## Controls camera shake
@onready var shaker: Shaker = $shaker
## The area outside of which the camera will start tracking its targets
@onready var deadzone: Area2D = $deadzone
## The collider bounds for the deadzone
@onready var deadzone_collision: CollisionShape2D = deadzone.get_node("collision")
## The root window containing this camera
@onready var root_window: Window = get_tree().get_root()

## Backing field for the locked variable
var _locked_backing_field: bool

## Whether the camera is locked to a position
var locked: bool:
	get:
		return _locked_backing_field
	set(value):
		_locked_backing_field = value
		tracking = not value

## Whether the camera is tracking
var tracking: bool

func _ready() -> void:
	zoom = Vector2.ONE * BASE_ZOOM
	# Make objects in visibility layer 20 invisible
	get_viewport().set_canvas_cull_mask_bit(20, false)

func _process(delta: float) -> void:
	if targets.all(func(target): return target != null):
		var deadzone_size: Vector2 = deadzone_collision.get_shape().get_rect().size
		var rect := Rect2(global_position - deadzone_size / 2, deadzone_size)
		if not locked and not rect.has_point(get_target_pos()):
			tracking = true
		if tracking:
			track(delta)

## Add a target for this camera to track
func add_target(target: Node2D, immediate: bool = true, recursive: bool = false) -> void:
	targets.append(target)
	if recursive:
		for child in target.get_children():
			if child is Node2D:
				add_target(child, immediate, recursive)
	if immediate:
		global_position = get_target_pos()
		zoom = Vector2.ONE * get_target_zoom()
		tracking = false

## Set a single target for the camera
func set_target(target: Node2D, recursive: bool = false) -> void:
	targets.clear()
	add_target(target, true, recursive)

## Shake the camera
func shake(amount: float, duration: float, x: bool = true, y: bool = true) -> void:
	if shaker:
		if x and y:
			shaker.shake(amount * SaveManager.settings.screen_shake_intensity, duration)
		elif x and not y:
			shaker.shake_x(amount * SaveManager.settings.screen_shake_intensity, duration)
		elif not x and y:
			shaker.shake_y(amount * SaveManager.settings.screen_shake_intensity, duration)

## Track targets
func track(delta: float) -> void:
	if global_position.distance_to(get_target_pos())<= end_tracking_threshold:
		tracking = false
	global_position = global_position.lerp(get_target_pos(), tracking_speed * delta)
	zoom = zoom.lerp(Vector2.ONE * get_target_zoom(), tracking_speed * delta)

## Fetch the position that the camera should track to
func get_target_pos() -> Vector2:
	var target_ranges: TargetRanges = get_target_ranges()
	var center_x: float = target_ranges.min_x + (target_ranges.max_x - target_ranges.min_x) / 2
	var center_y: float = target_ranges.min_y + (target_ranges.max_y - target_ranges.min_y) / 2
	return Vector2(center_x, center_y)
	
## Calculate the zoom factor that the camera should have in order to fit all targets in frame
func get_target_zoom() -> float:
	if len(targets) <= 1:
		return BASE_ZOOM
	var target_ranges: TargetRanges = get_target_ranges()
	var x_range: float = target_ranges.max_x - target_ranges.min_x
	var y_range: float = target_ranges.max_y - target_ranges.min_y
	var zoom_factor: float = min((root_window.size.x / x_range) * 0.9, (root_window.size.x / y_range) * 0.9, BASE_ZOOM)
	return zoom_factor

## Calculate the minimum and maximum values of the x- and y-axes and return them as an object
func get_target_ranges() -> TargetRanges:
	var target_ranges := TargetRanges.new()
	target_ranges.min_x = targets.reduce(func(x, target):
		return target.global_position.x if target.global_position.x < x else x,
	INF)
	target_ranges.max_x = targets.reduce(func(x, target):
		return target.global_position.x if target.global_position.x > x else x,
	-INF)
	target_ranges.min_y = targets.reduce(func(y, target): 
		return target.global_position.y if target.global_position.y < y else y,
	INF)
	target_ranges.max_y = targets.reduce(func(y, target):
		return target.global_position.y if target.global_position.y > y else y,
	-INF)
	return target_ranges
