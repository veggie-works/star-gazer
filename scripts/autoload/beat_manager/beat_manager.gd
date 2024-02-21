## Manages the game's musical heartbeat
extends Node

## The timer that controls the music beat
@onready var beat_timer: Timer = $beat_timer

## Emitted when a beat plays
signal beat

## The amount of time left before the next beat
var time_to_next_beat: float:
	get:
		return beat_timer.time_left

func _on_beat_timer_timeout() -> void:
	beat.emit()
