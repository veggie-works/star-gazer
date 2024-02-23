## Behavior for pulsing an object's color on and off
class_name Pulser extends Node2D

## The flasher component to use for the color pulse
@onready var flasher: Flasher = %flasher

## The color to pulse
var pulse_color: Color
## The rate at which the object is pulsing
var pulse_rate: float
## Whether the object is pulsing
var is_pulsing: bool

func _process(delta: float) -> void:
	if is_pulsing and not flasher.is_flashing:
		flasher.flash(pulse_color, 1.0, pulse_rate / 2, pulse_rate / 2)

func start_pulse(color := Color.BLACK, pulse_rate: float = 0.25) -> void:
	is_pulsing = true
	pulse_color = color
	self.pulse_rate = pulse_rate

func stop_pulse() -> void:
	is_pulsing = false
