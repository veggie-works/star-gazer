## Player-specific finite state machine
class_name PlayerFSM extends StateMachine

func _input(event: InputEvent) -> void:	
	current_state.input(event)

## Check whether a perfect input has been executed
func check_perfect_inputs(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		if AudioManager.time_to_next_beat <= AudioManager.PERFECT_ATTACK_WINDOW:
			pass # TODO: perfect attack
		else:
			pass # TODO: normal attack
	elif event.is_action_pressed("dash"):
		if AudioManager.time_to_next_beat <= AudioManager.PERFECT_DASH_WINDOW:
			pass # TODO: perfect dash
		else:
			pass # TODO: normal dash
