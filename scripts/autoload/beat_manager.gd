## Manages timings taken from the audio manager
extends Node

## The window of time in which a perfect attack may be executed
const PERFECT_ATTACK_WINDOW: float = 0.15
## The window of time in which a perfect dodge may be executed
const PERFECT_DODGE_WINDOW: float = 0.2
## The window of time in which a perfect recovery may be executed
const PERFECT_RECOVERY_WINDOW: float = 0.15

## Whether a perfect attack was executed
var perfect_attacked: bool:
	get:
		return AudioManager.time_to_next_beat < PERFECT_ATTACK_WINDOW / 2 or AudioManager.beat_length - AudioManager.time_to_next_beat < PERFECT_ATTACK_WINDOW / 2
		
## Whether a perfect recovery was executed
var perfect_recovery: bool:
	get:
		return AudioManager.time_to_next_beat < PERFECT_RECOVERY_WINDOW / 2 or AudioManager.beat_length - AudioManager.time_to_next_beat < PERFECT_RECOVERY_WINDOW / 2
