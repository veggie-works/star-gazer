## Controls shaking of an object
class_name Shaker extends Node2D

## The current amount of shake applied to the object
var current_shake_magnitude: float
## The position of the object before it began shaking
var original_position: Vector2
## The amount of shake to remove every frame
var unshake_amount: float
## Whether to shake along the x-axis
var shake_horizontally: bool
## Whether to shake along the y-axis
var shake_vertically: bool

func _process(delta: float) -> void:
	if current_shake_magnitude > 0:
		update_shake(delta)

func _shake_internal(amount: float, duration) -> void:
	original_position = owner.global_position
	current_shake_magnitude = amount
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
func update_shake(delta: float) -> void:
	var shake_x: float = randf_range(-1, 1) if shake_horizontally else 0
	var shake_y: float = randf_range(-1, 1) if shake_vertically else 0
	var shake_vector := Vector2(shake_x, shake_y).normalized()
	owner.global_position = original_position + shake_vector * current_shake_magnitude
	current_shake_magnitude -= unshake_amount * delta
