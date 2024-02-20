## Wrapper around Godot's own input action
class_name InputAction extends Node

## The name of the action corresponding to the input action in Godot's input mapping
@export var action_name: StringName

## The amount of time to buffer for
@export var buffer_time: float = 0.2

## Timer that counts down the time before the input buffer expires
@onready var buffer_timer: Timer = $buffer_timer

## Whether the input action is buffered
var is_buffered: bool:
	get:
		return not buffer_timer.is_stopped()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(action_name):
		buffer_timer.start(buffer_time)
