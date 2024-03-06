## Controls shaking of an object
class_name Shaker extends Node2D

## The duration between each shake
@export var shake_interval: float = 0.025

## The position of the object before it began shaking
var original_position: Vector2
## The amount of shake to remove every frame
var unshake_amount: float
## Whether to shake along the x-axis
var shake_horizontally: bool
## Whether to shake along the y-axis
var shake_vertically: bool
## The current shake vector applied to the object
var current_shake_vector: Vector2
## The current amount of shake applied to the object
var current_shake_magnitude: float
## The current time that the object has been offset for during a shake
var current_shake_time: float

func _physics_process(delta: float) -> void:
	if current_shake_magnitude > 0:
		current_shake_time += delta
		if current_shake_time >= shake_interval:
			update_shake()

## Set shake values
func _shake_internal(amount: float, duration) -> void:
	original_position = owner.global_position
	current_shake_magnitude = amount
	if shake_horizontally:
		current_shake_vector.x = 1
	if shake_vertically:
		current_shake_vector.y = 1
	unshake_amount = amount / duration

## Begin object shake in all directions
func shake(amount: float, duration: float) -> void:
	_shake_internal(amount, duration)
	shake_horizontally = true
	shake_vertically = true

## Shake object only along the x-axis	
func shake_x(amount: float, duration) -> void:
	_shake_internal(amount, duration)
	shake_horizontally = true
	shake_vertically = false

## Shake object only along the y-axis	
func shake_y(amount: float, duration) -> void:
	_shake_internal(amount, duration)
	shake_horizontally = false
	shake_vertically = true

## Update the current object shake
func update_shake() -> void:
	if shake_horizontally and shake_vertically:
		current_shake_vector = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized() * current_shake_magnitude
	if shake_horizontally and not shake_vertically:
		current_shake_vector.x = current_shake_magnitude * -sign(current_shake_vector.x)
	elif not shake_horizontally and shake_vertically:
		current_shake_vector.y = current_shake_magnitude * -sign(current_shake_vector.y)
	owner.global_position += current_shake_vector
	current_shake_magnitude -= unshake_amount * current_shake_time
	current_shake_time = 0
