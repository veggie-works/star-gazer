## Behavior for pulsing an object's color on and off
class_name Pulser extends Node2D

## The flasher component to use for the color pulse
@onready var flasher: Flasher = $"../flasher"

## The color to pulse
var pulse_color: Color
## The rate at which the object is pulsing
var pulse_rate: float
## Whether the object is pulsing
var is_pulsing: bool

func _process(_delta: float) -> void:
	if is_pulsing and not flasher.is_flashing:
		var flash_color := Color(pulse_color.r, pulse_color.g, pulse_color.b, 1.0)
		flasher.flash(flash_color, pulse_color.a, pulse_rate / 2, pulse_rate / 2)

## Start pulsing the object.
func start_pulse(color := Color.BLACK, new_pulse_rate: float = 0.25) -> void:
	is_pulsing = true
	pulse_color = color
	pulse_rate = new_pulse_rate

## Stop object pulsing
func stop_pulse() -> void:
	is_pulsing = false
	if flasher.is_flashing:
		flasher.reset_color()
