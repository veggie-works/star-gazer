## Player-specific finite state machine
class_name PlayerFSM extends StateMachine

func _input(event: InputEvent) -> void:
	check_perfect_inputs(event)
	current_state.input(event)

## Check whether a perfect input has been executed
func check_perfect_inputs(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		if AudioManager.time_to_next_beat < AudioManager.PERFECT_ATTACK_WINDOW / 2:
			print("PERFECT ATTACK")
		else:
			print("normal attack")
	elif event.is_action_pressed("block"):
		if AudioManager.time_to_next_beat < AudioManager.PERFECT_PARRY_WINDOW / 2 or \
			AudioManager.beat_length - AudioManager.time_to_next_beat < AudioManager.PERFECT_PARRY_WINDOW / 2:
			print("PERFECT PARRY")
		else:
			print("normal block")
