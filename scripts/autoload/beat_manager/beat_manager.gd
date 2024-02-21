## Manages the game's musical heartbeat
extends Node

## The window of time in which a perfect attack may be executed
const PERFECT_ATTACK_WINDOW: float = 0.15
## The window of time in which a perfect dash may be executed
const PERFECT_DASH_WINDOW: float = 0.2
## The window of time in which a perfect parry may be executed
const PERFECT_PARRY_WINDOW: float = 0.1

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
