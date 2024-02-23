## Controls shaking of an object
class_name Shaker extends Node2D

## The current amount of shake applied to the object
var current_shake_magnitude: float
## The position of the object before it began shaking
var original_position: Vector2
## The amount of shake to remove every frame
var unshake_amount: float

func _process(delta: float) -> void:
	if current_shake_magnitude > 0:
		update_shake(delta)

## Begin object shake
func shake(amount: float, duration: float) -> void:
	original_position = owner.global_position
	current_shake_magnitude = amount
	unshake_amount = amount / duration

## Update the current object shake
func update_shake(delta: float) -> void:
	owner.global_position = original_position + Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized() * current_shake_magnitude
	current_shake_magnitude -= unshake_amount * delta
