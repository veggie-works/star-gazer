## Controls flashing of a canvas item
class_name Flasher extends Node2D

## The material of the owner of this flasher
@onready var owner_material: ShaderMaterial:
	get:
		return owner.material

## The duration that the flash will increase to the starting flash color and amount
var ramp_up_time: float

## The duration that the flash will fade out to transparent
var ramp_down_time: float

## The highest flash amount value to ramp up to or ramp down from 
var peak_flash_amount: float

## The current time ramping up to the flash color
var current_ramp_up_time: float

## The current time ramping down to transparent
var current_ramp_down_time: float

## Backing field for the is_flashing variable
var _is_flashing_backing_field: bool

## Whether the object is flashing
var is_flashing: bool:
	get:
		return _is_flashing_backing_field
	set(value):
		_is_flashing_backing_field = value
		if not value:
			owner_material.set_shader_parameter("flash_amount", 0)

func _ready() -> void:
	is_flashing = false

func _process(delta: float) -> void:
	if current_ramp_up_time < ramp_up_time:
		var flash_amount: float = Globals.map(current_ramp_up_time / ramp_up_time, 0.0, 1.0, 0.0, peak_flash_amount)
		owner_material.set_shader_parameter("flash_amount", flash_amount)
		current_ramp_up_time += delta
	elif current_ramp_down_time < ramp_down_time:
		var flash_amount: float = Globals.map(1.0 - current_ramp_down_time / ramp_down_time, 0.0, 1.0, 0.0, peak_flash_amount)
		owner_material.set_shader_parameter("flash_amount", flash_amount)
		current_ramp_down_time += delta
	elif is_flashing:
		is_flashing = false

## Flash a color for a duration of time
func flash(color := Color.WHITE, new_peak_flash_amount: float = 1.0, new_ramp_down_time: float = 0.25, new_ramp_up_time: float = 0.0) -> void:
	owner_material.set_shader_parameter("flash_color", color)
	peak_flash_amount = new_peak_flash_amount
	ramp_up_time = new_ramp_up_time
	ramp_down_time = new_ramp_down_time
	current_ramp_up_time = 0.0
	current_ramp_down_time = 0.0
	is_flashing = true

## Restore object's color to its original state
func reset_color() -> void:
	owner_material.set_shader_parameter("flash_amount", 0.0)
